//
//  WiGameURLCache.m
//  WiGame3.0PoC
//
//  Created by Wang Qing on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LQURLCache.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kWiGameURLCacheInfoFileName = @"cacheinfo.plist";

static float const kWiGameURLCacheLastModFraction = 0.1f; // 10% since Last-Modified suggested by RFC2616 section 13.2.4
static NSTimeInterval const kWiGameURLCacheDefault = 3600; // Default cache expiration delay if none defined (1 hour)
static NSTimeInterval const kWiGameURLCacheInfoDefaultMinCacheInterval = 5 * 60; // 5 minute

static NSString *const kWiGameURLCacheInfoDiskUsageKey = @"diskUsage";
static NSString *const kWiGameURLCacheInfoAccessesKey = @"accesses";
static NSString *const kWiGameURLCacheInfoSizesKey = @"sizes";
static NSString *const kWiGameURLCacheInfoExpirationKey = @"expirations";

#pragma mark -
#pragma mark 实现NSCachedURLResponse的存盘

#define RESPONSE_KEY @"response"
#define USERINFO_KEY @"userInfo"
#define POLICY_KEY @"storagePolicy"

@implementation NSCachedURLResponse(NSCoder)
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeDataObject:self.data];
    [coder encodeObject:self.response forKey:RESPONSE_KEY];
    [coder encodeObject:self.userInfo forKey:USERINFO_KEY];
    [coder encodeInt:self.storagePolicy forKey:POLICY_KEY];
}

- (id)initWithCoder:(NSCoder *)coder{
    return [self initWithResponse:[coder decodeObjectForKey:RESPONSE_KEY]
                             data:[coder decodeDataObject]
                         userInfo:[coder decodeObjectForKey:USERINFO_KEY]
                    storagePolicy:[coder decodeIntForKey:POLICY_KEY]];
}
@end

#pragma mark -
#pragma mark 内部接口

@interface LQURLCache()
@property (nonatomic, readonly) NSMutableDictionary *staticCacheInfo;
@property (nonatomic, strong) NSOperationQueue *ioQueue;
@property (nonatomic, strong) NSOperation *periodicMaintenanceOperation;

@property (nonatomic, strong) NSString* diskPath;
@property (nonatomic, assign) BOOL cacheInfoDirty;

+ (NSDate *)expirationDateFromHeaders:(NSDictionary *)headers withStatusCode:(NSInteger)status defaultCacheInterval:(NSTimeInterval)defaultCacheInterval;
+ (NSString *)cacheKeyForURL:(NSURL *)url;

- (void)removeCachedResponseForCachedKeys:(NSArray *)cacheKeys;
- (void)saveCacheInfo;
- (void)periodicMaintenance;
- (void)storeToDisk:(NSDictionary *)context;
@end


#pragma mark -
#pragma mark 实现

@implementation LQURLCache
@dynamic staticCacheInfo;
@synthesize ioQueue, periodicMaintenanceOperation;
@synthesize minCacheInterval;
@synthesize defaultCacheInterval;

@synthesize diskPath;
@synthesize cacheInfoDirty;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    if (self != nil){
        self.diskPath = path;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES attributes:nil error:NULL];
        
        self.minCacheInterval = kWiGameURLCacheInfoDefaultMinCacheInterval;
        self.defaultCacheInterval = kWiGameURLCacheDefault;
        
        // Init the operation queue
        self.ioQueue = [[NSOperationQueue alloc] init];
        self.ioQueue.maxConcurrentOperationCount = 1; // used to streamline operations in a separate thread
        
    }
    return self;
}

#pragma mark -
#pragma mark Utilities
+ (NSString *)cacheKeyForURL:(NSURL *)url{
    //MD5编码
    const char *str = [[url absoluteString] UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

/*
 * Parse HTTP Date: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 */
+ (NSDate *)dateFromHttpDateString:(NSString *)httpDate{
    NSDate *date = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    // RFC 1123 date format - Sun, 06 Nov 1994 08:49:37 GMT
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    date = [dateFormatter dateFromString:httpDate];
    if (!date){
        // ANSI C date format - Sun Nov  6 08:49:37 1994
        [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss yyyy"];
        date = [dateFormatter dateFromString:httpDate];
        if (!date){
            // RFC 850 date format - Sunday, 06-Nov-94 08:49:37 GMT
            [dateFormatter setDateFormat:@"EEEE, dd-MMM-yy HH:mm:ss z"];
            date = [dateFormatter dateFromString:httpDate];
        }
    }
    
    return date;
}

/*
 * This method tries to determine the expiration date based on a response headers dictionary.
 */
+ (NSDate *)expirationDateFromHeaders:(NSDictionary *)headers withStatusCode:(NSInteger)status defaultCacheInterval:(NSTimeInterval)defaultCacheInterval{
    
    if (status != 200 && 
        status != 203 &&
        status != 300 && 
        status != 301 && 
        status != 302 &&
        status != 307 && 
        status != 410){
        // Uncacheable response status code
        return nil;
    }
    
    // Check Pragma: no-cache
    NSString *pragma = [headers objectForKey:@"Pragma"];
    if (pragma && [pragma isEqualToString:@"no-cache"]){
        // Uncacheable response
        return nil;
    }
    
    // Define "now" based on the request
    NSString *date = [headers objectForKey:@"Date"];
    NSDate *now;
    if (date){
        now = [self dateFromHttpDateString:date];
    }else{
        now = [NSDate date];
    }
    
    // Look at info from the Cache-Control: max-age=n header
    NSString *cacheControl = [headers objectForKey:@"Cache-Control"];
    if (cacheControl){
        NSRange foundRange = [cacheControl rangeOfString:@"no-cache"];
        if (foundRange.length > 0){
            // Can't be cached
            return nil;
        }
        
        NSInteger maxAge;
        foundRange = [cacheControl rangeOfString:@"max-age="];
        if (foundRange.length > 0){
            NSScanner *cacheControlScanner = [NSScanner scannerWithString:cacheControl];
            [cacheControlScanner setScanLocation:foundRange.location + foundRange.length];
            if ([cacheControlScanner scanInteger:&maxAge]){
                if (maxAge > 0){
                    return [NSDate dateWithTimeIntervalSinceNow:maxAge];
                }
                else{
                    return nil;
                }
            }
        }
    }
    
    // If not Cache-Control found, look at the Expires header
    NSString *expires = [headers objectForKey:@"Expires"];
    if (expires)
    {
        NSTimeInterval expirationInterval = 0;
        NSDate *expirationDate = [self dateFromHttpDateString:expires];
        if (expirationDate){
            expirationInterval = [expirationDate timeIntervalSinceDate:now];
        }
        if (expirationInterval > 0){
            // Convert remote expiration date to local expiration date
            return [NSDate dateWithTimeIntervalSinceNow:expirationInterval];
        }else{
            // If the Expires header can't be parsed or is expired, do not cache
            return nil;
        }
    }
    
    if (status == 302 || status == 307){
        // If not explict cache control defined, do not cache those status
        return nil;
    }
    
    // If no cache control defined, try some heristic to determine an expiration date
    NSString *lastModified = [headers objectForKey:@"Last-Modified"];
    if (lastModified){
        NSTimeInterval age = 0;
        NSDate *lastModifiedDate = [self dateFromHttpDateString:lastModified];
        if (lastModifiedDate){
            // Define the age of the document by comparing the Date header with the Last-Modified header
            age = [now timeIntervalSinceDate:lastModifiedDate];
        }
        if (age > 0){
            return [NSDate dateWithTimeIntervalSinceNow:(age * kWiGameURLCacheLastModFraction)];
        }else{
            return nil;
        }
    }
    
    // If nothing permitted to define the cache expiration delay nor to restrict its cacheability, use a default cache expiration delay
    return [NSDate dateWithTimeInterval:defaultCacheInterval sinceDate:now];
}


#pragma mark -
#pragma mark 保存缓存
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{
    if (request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringCacheData){
        // When cache is ignored for read, it's a good idea not to store the result as well as this option
        // have big chance to be used every times in the future for the same request.
        // NOTE: This is a change regarding default URLCache behavior
        return;
    }


    if (self.memoryCapacity > 0.0f){
        [super storeCachedResponse:cachedResponse forRequest:request];
    }
    
    BOOL saveToStorage = YES;
//    saveToStorage = cachedResponse.storagePolicy == NSURLCacheStorageAllowedInMemoryOnly;

#if TARGET_IPHONE_SIMULATOR
    saveToStorage = YES;
#endif

#ifdef ENABLE_TRACE
	NSLog(@"[WiGame Cache] response should save to storage = %d. URL = %@", saveToStorage, request.URL);
#endif
	
    if (saveToStorage
        && [cachedResponse.response isKindOfClass:[NSHTTPURLResponse class]]
        && cachedResponse.data.length < self.diskCapacity){
        NSDate *expirationDate = [LQURLCache expirationDateFromHeaders:[(NSHTTPURLResponse *)cachedResponse.response allHeaderFields]
                                                            withStatusCode:((NSHTTPURLResponse *)cachedResponse.response).statusCode
                                                      defaultCacheInterval:self.defaultCacheInterval];
        
        if (!expirationDate || 
            [expirationDate timeIntervalSinceNow] <= self.minCacheInterval){
#ifdef ENABLE_TRACE
            NSLog(@"[WiGame Cache] response does not require cache. URL = %@", request.URL);
#endif
            return;
        }
        
        [self.ioQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self
                                                                    selector:@selector(storeToDisk:)
                                                                      object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                              cachedResponse, @"cachedResponse",
                                                                              request, @"request",
                                                                              expirationDate, @"expirationDate",
                                                                              nil]]];
    }
}

#pragma mark -
#pragma mark 获取缓存数据
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    
    if (self.memoryCapacity > 0.0f){
        NSCachedURLResponse *memoryResponse = [super cachedResponseForRequest:request];
        if (memoryResponse){
            return memoryResponse;
        }
    }
    
    if (request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        || request.cachePolicy == NSURLRequestReloadIgnoringCacheData){
#ifdef ENABLE_TRACE
        NSLog(@"[WiGame Cache] Skip load cache URL=%@", request.URL);
#endif
        return nil;
    }        
	
	if (![[request.URL scheme] hasPrefix:@"http"]){
#ifdef ENABLE_TRACE
		NSLog(@"[WiGame Cache] No cache for this kind of request. scheme = %@", [request.URL scheme]);
#endif
		return nil;
	}
    
    NSString *cacheKey = [LQURLCache cacheKeyForURL:request.URL];
    
    // NOTE: We don't handle expiration here as even staled cache data is necessary for NSURLConnection to handle cache revalidation.
    //       Staled cache data is also needed for cachePolicies which force the use of the cache.
    @synchronized(self.staticCacheInfo){
        NSMutableDictionary *accesses = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoAccessesKey];
        NSMutableDictionary *expireDates = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoExpirationKey];
        // OPTI: Check for cache-hit in a in-memory dictionnary before to hit the FS
        if ([accesses objectForKey:cacheKey]){
            NSCachedURLResponse *diskResponse = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.diskPath stringByAppendingPathComponent:cacheKey]];
            if (diskResponse!=nil){
                // OPTI: Log the entry last access time for LRU cache eviction algorithm but don't save the dictionary
                // on disk now in order to save IO and time
                [accesses setObject:[NSDate date] forKey:cacheKey];
                self.cacheInfoDirty = YES;

                do{
                    //如果是只加载缓存，则不做网络验证
                    if (request.cachePolicy == NSURLRequestReturnCacheDataDontLoad){
						NSDate* expirationDate = [expireDates objectForKey:cacheKey];
						if (expirationDate != nil){
							//如果超期则返回空
							if ([expirationDate compare:[NSDate date]] != NSOrderedAscending){
#ifdef ENABLE_TRACE
								NSLog(@"[WiGame Cache] Load cached data directly. URL=%@", request.URL);
#endif
								if (self.memoryCapacity > 0.0f){
									[super storeCachedResponse:diskResponse forRequest:request];
								}
							}else{
#ifdef ENABLE_TRACE
								NSLog(@"[WiGame Cache] Cached data expired. URL=%@", request.URL);
#endif
								diskResponse = nil;
							}
						}
						break;
                    }
                    
                    NSHTTPURLResponse* oldRes = (NSHTTPURLResponse*) diskResponse.response;
					/**
					 * 检查是否有Expires头
					 */
					NSString* expires = [[oldRes allHeaderFields] objectForKey:@"Expires"];
					if (expires){
						NSDate* expirationDate = [expireDates objectForKey:cacheKey];
						if ([expirationDate compare:[NSDate date]] != NSOrderedAscending){
#ifdef ENABLE_TRACE
							NSLog(@"[WiGame Cache] 2. Load cached data directly. URL=%@", request.URL);
#endif
							
							//如果没有超时，则直接返回缓存结果
							if (self.memoryCapacity > 0.0f){
								[super storeCachedResponse:diskResponse forRequest:request];
							}
							break;
						}
					}
					

					if (self.memoryCapacity > 0.0f){
						[super storeCachedResponse:diskResponse forRequest:request];
					}
					
					/**
					 * 第一次从磁盘加载的时候是否需要检查304呢？有待斟酌
					 * 因为静态页面都有expires时间，api数据不在这里检查
					 */
					
//                    /**
//                     * 去网络上验证下是否是最新的cache, 包括Data Modified和ETag
//                     */
//                    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:request.URL
//                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                                   timeoutInterval:30.0];
//                    NSMutableDictionary* fields = [NSMutableDictionary dictionaryWithDictionary:[req allHTTPHeaderFields]];
//                    
//                    
//                    NSString* lastModify = [[oldRes allHeaderFields] objectForKey:@"Last-Modified"];
//                    if (lastModify != nil){
//                        [fields setObject:lastModify  forKey:@"If-Modified-Since"];
//                    }
//                    
//                    NSString* etag = [[oldRes allHeaderFields] objectForKey:@"ETag"];
//                    if (etag != nil){
//                        [fields setObject:etag  forKey:@"If-None-Match"];
//                    }
//                    [req setAllHTTPHeaderFields:fields];
					//                    NSHTTPURLResponse* response = nil;
//                    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:NULL];
//                    if (response != nil){
//                        if ([response statusCode] == 304){
//                            // OPTI: Store the response to memory cache for potential future requests
//                            if (self.memoryCapacity > 0.0f){
//                                [super storeCachedResponse:diskResponse forRequest:request];
//                            }
//                        }else{
//                            diskResponse = [[[NSCachedURLResponse alloc] initWithResponse:response data:data] autorelease];
//                            [self storeCachedResponse:diskResponse forRequest:request];
//                        }
//                    }
                    
                }while (NO);

#ifdef ENABLE_TRACE
				if (diskResponse != nil){
					NSLog(@"[WiGame Cache] request.URL=%@. Cache matched", request.URL);
				}else {
					NSLog(@"[WiGame Cache] request.URL=%@. Cache not matched", request.URL);
				}

#endif
				
                return diskResponse;
            }
        }
    }

#ifdef ENABLE_TRACE
    NSLog(@"[WiGame Cache] request.URL=%@. No Cache found", request.URL);
#endif
	
    return nil;
}

#pragma mark -
#pragma mark 清除缓存数据
- (void)removeCachedResponseForRequest:(NSURLRequest *)request{
    if (self.memoryCapacity > 0.0f){
        [super removeCachedResponseForRequest:request];
    }
    
    [self removeCachedResponseForCachedKeys:[NSArray arrayWithObject:[LQURLCache cacheKeyForURL:request.URL]]];
    [self saveCacheInfo];
}

- (void)removeAllCachedResponses{
    if (self.memoryCapacity > 0.0f){
        [super removeAllCachedResponses];
    }
    
    NSArray* cacheFiles = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.diskPath error:NULL];
    for (NSString* file in cacheFiles){
        if (![[file pathExtension] isEqualToString:@"plist"]){
            [[NSFileManager defaultManager] removeItemAtPath:[self.diskPath stringByAppendingPathComponent:file] error:NULL];
        }
    }
}

#pragma mark -
#pragma mark 存盘文件处理
- (NSUInteger)currentDiskUsage{
    return _diskCacheUsed;
}

- (NSMutableDictionary *)staticCacheInfo{
    if (_staticCacheInfo  == nil){
        @synchronized(self){
            // Check again, maybe another thread created it while waiting for the mutex
            if (_staticCacheInfo  == nil){
                if ([[NSFileManager defaultManager] fileExistsAtPath:[self.diskPath stringByAppendingPathComponent:kWiGameURLCacheInfoFileName]]){
                    _staticCacheInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:[self.diskPath stringByAppendingPathComponent:kWiGameURLCacheInfoFileName]];
                }else{
                    _staticCacheInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithUnsignedInt:0], kWiGameURLCacheInfoDiskUsageKey,
                                        [NSMutableDictionary dictionary], kWiGameURLCacheInfoAccessesKey,
                                        [NSMutableDictionary dictionary], kWiGameURLCacheInfoSizesKey,
										[NSMutableDictionary dictionary], kWiGameURLCacheInfoExpirationKey,
                                        nil];
                }
                
                self.cacheInfoDirty = NO;
                
                /**
                 * 设置存盘定期磁盘空间检查
                 */
                _periodicMaintenanceTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                             target:self
                                                                           selector:@selector(periodicMaintenance)
                                                                           userInfo:nil
                                                                            repeats:YES];
            }
        }
    }
    
    return _staticCacheInfo;
}

- (void)saveCacheInfo{
    @synchronized(self.staticCacheInfo){
        [self.staticCacheInfo writeToFile:[self.diskPath stringByAppendingPathComponent:kWiGameURLCacheInfoFileName] 
                               atomically:YES];
        self.cacheInfoDirty = NO;
    }
}

/**
 * 会在线程里跑
 */
- (void)removeCachedResponseForCachedKeys:(NSArray *)cacheKeys{
    @autoreleasepool {
        NSEnumerator *enumerator = [cacheKeys objectEnumerator];
        NSString *cacheKey;
        
        @synchronized(self.staticCacheInfo){
            NSMutableDictionary *accesses = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoAccessesKey];
            NSMutableDictionary *sizes = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoSizesKey];
            NSMutableDictionary* expirations = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoExpirationKey];
            
            while ((cacheKey = [enumerator nextObject])){
                NSUInteger cacheItemSize = [[sizes objectForKey:cacheKey] unsignedIntegerValue];
                [accesses removeObjectForKey:cacheKey];
                [sizes removeObjectForKey:cacheKey];
                [expirations removeObjectForKey:cacheKey];
                [[NSFileManager defaultManager] removeItemAtPath:[self.diskPath stringByAppendingPathComponent:cacheKey] error:NULL];
                _diskCacheUsed -= cacheItemSize;
                [self.staticCacheInfo setObject:[NSNumber numberWithUnsignedInteger:_diskCacheUsed]
                                         forKey:kWiGameURLCacheInfoDiskUsageKey];
            }
        }
    }
}

- (void)balanceDiskUsage{
    if (_diskCacheUsed < self.diskCapacity){
        // Already done
        return;
    }
    
    NSMutableArray *keysToRemove = [NSMutableArray array];
    
    @synchronized(self.staticCacheInfo){
        // Apply LRU cache eviction algorithm while disk usage outreach capacity
        NSDictionary *sizes = [self.staticCacheInfo objectForKey:kWiGameURLCacheInfoSizesKey];
        
        NSInteger capacityToSave = _diskCacheUsed - self.diskCapacity;
        NSArray *sortedKeys = [[self.staticCacheInfo objectForKey:kWiGameURLCacheInfoAccessesKey] 
                               keysSortedByValueUsingSelector:@selector(compare:)];
        NSEnumerator *enumerator = [sortedKeys objectEnumerator];
        NSString *cacheKey;
        
        while (capacityToSave > 0 && (cacheKey = [enumerator nextObject])){
            [keysToRemove addObject:cacheKey];
            capacityToSave -= [(NSNumber *)[sizes objectForKey:cacheKey] unsignedIntegerValue];
        }
    }
    
    [self removeCachedResponseForCachedKeys:keysToRemove];
    [self saveCacheInfo];
}


- (void)storeToDisk:(NSDictionary *)context{
    NSURLRequest *request = [context objectForKey:@"request"];
    NSCachedURLResponse *cachedResponse = [context objectForKey:@"cachedResponse"];
	NSDate* expirationDate = [context objectForKey:@"expirationDate"];
    
    NSString *cacheKey = [LQURLCache cacheKeyForURL:request.URL];
    NSString *cacheFilePath = [self.diskPath stringByAppendingPathComponent:cacheKey];
    
    // Archive the cached response on disk
    if (![NSKeyedArchiver archiveRootObject:cachedResponse toFile:cacheFilePath]){
        // Caching failed for some reason
        return;
    }
    
    // Update disk usage info
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSNumber *cacheItemSize = [[fileManager attributesOfItemAtPath:cacheFilePath error:NULL] objectForKey:NSFileSize];
    _diskCacheUsed += [cacheItemSize unsignedIntegerValue];
    @synchronized(self.staticCacheInfo){
        [self.staticCacheInfo setObject:[NSNumber numberWithUnsignedInteger:_diskCacheUsed]
                                 forKey:kWiGameURLCacheInfoDiskUsageKey];
        
        // Update cache info for the stored item
        [(NSMutableDictionary *)[self.staticCacheInfo  objectForKey:kWiGameURLCacheInfoAccessesKey] setObject:[NSDate date] forKey:cacheKey];
        [(NSMutableDictionary *)[self.staticCacheInfo objectForKey:kWiGameURLCacheInfoSizesKey] setObject:cacheItemSize forKey:cacheKey];
		[(NSMutableDictionary *)[self.staticCacheInfo objectForKey:kWiGameURLCacheInfoExpirationKey] setObject:expirationDate forKey:cacheKey];
    }
    
    [self saveCacheInfo];
}

/**
 * 定期磁盘清理
 */
- (void)periodicMaintenance{
    // If another same maintenance operation is already sceduled, cancel it so this new operation will be executed after other
    // operations of the queue, so we can group more work together
    [_periodicMaintenanceOperation cancel];
    self.periodicMaintenanceOperation = nil;
    
    // If disk usage outrich capacity, run the cache eviction operation and if cacheInfo dictionnary is dirty, save it in an operation
    if (_diskCacheUsed > self.diskCapacity)
    {
        self.periodicMaintenanceOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                  selector:@selector(balanceDiskUsage) 
                                                                                    object:nil] ;
        [self.ioQueue addOperation:self.periodicMaintenanceOperation];
    }else if (self.cacheInfoDirty)
    {
        self.periodicMaintenanceOperation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                                  selector:@selector(saveCacheInfo)
                                                                                    object:nil];
        [self.ioQueue addOperation:self.periodicMaintenanceOperation];
    }
}



@end
