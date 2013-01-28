//
//  QYXAPICache.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-8.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQAPICache.h"
#import <CommonCrypto/CommonDigest.h>

static LQAPICache* _instance = nil;

@interface LQAPICache()
@property (nonatomic, strong) NSString* cacheDir;
@property (nonatomic, strong) NSMutableDictionary* memoryCache;
@end

@implementation LQAPICache
@synthesize cacheDir;
@synthesize memoryCache;

+ (LQAPICache*)sharedInstance{
    if (_instance == nil){
        _instance = [[LQAPICache alloc] init];
    }
    
    return _instance;
}

- (id)init{
    self = [super init];
    if (self != nil){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];

//        NSArray* cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        self.cacheDir =  [[cacheDirectories objectAtIndex:0] stringByAppendingPathComponent:[formatter stringFromDate:[NSDate date]]];
        self.cacheDir =  [[LQUtilities cacheDirectoryPath] stringByAppendingPathComponent:[formatter stringFromDate:[NSDate date]]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.cacheDir]){
            [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDir withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        self.memoryCache = [NSMutableDictionary dictionary];

    }
    return self;
}

- (NSString *)cacheKeyForURL:(NSURL *)url{
    //MD5编码
    const char *str = [[url absoluteString] UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

- (NSData*)getAPICache:(NSURLRequest*)request returningResponse:(NSURLResponse* __autoreleasing *)response{
    if (![[request HTTPMethod] isEqualToString:@"GET"]){
        *response = nil;
        return nil;
    }
    
    @synchronized(self){
        NSString* requestFile = [self cacheKeyForURL:[request URL]];
        NSData* data = [self.memoryCache objectForKey:requestFile];
        
        if (data == nil){
            NSString* cacheFilePath = [self.cacheDir stringByAppendingPathComponent:requestFile];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]){
                data = [NSData dataWithContentsOfFile:cacheFilePath];
            }   
        }
        NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        body = [body stringByReplacingOccurrencesOfString:@"\r\n"withString:@""];
        
        NSRange range = [body rangeOfString:@"502 Bad Gateway"];
        if(range.location>0)
            return nil;
        
        if (data != nil){
            NSHTTPURLResponse* rep = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"1.1" headerFields:nil];
            *response = rep;
            return data;
        }
    }
    
    return nil;
}

- (void)saveAPICache:(NSURLRequest*)request response:(NSURLResponse*)response data:(NSData*)data{
    if (![[request HTTPMethod] isEqualToString:@"GET"]){
        return;
    }
    
    NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    body = [body stringByReplacingOccurrencesOfString:@"\r\n"withString:@""];
    
    NSRange range = [body rangeOfString:@"502 Bad Gateway"];
    if(range.location>0)
        return;
    
    
    NSString* path = [[request URL] path];
    if ([path isEqualToString:@"/api/game/comments"]){
        return;
    }
    
    @synchronized(self){
        NSString* requestFile = [self cacheKeyForURL:[request URL]];
        if ([path isEqualToString:@"/api/game/notices"]||
            [path isEqualToString:@"/api/game/home/adv"]){
            [self.memoryCache setObject:data forKey:requestFile];
            return;
        }

        NSString* cacheFilePath = [self.cacheDir stringByAppendingPathComponent:requestFile];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]){
            [data writeToFile:cacheFilePath atomically:YES];
        }   
    }
}

@end
