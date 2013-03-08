//
//  MGClient.m
//  TicketGo
//
//  Created by maruojie on 09-9-14.
//  Copyright 2009 MobGo. All rights reserved.
//

#import "LQClientBase.h"

#define TIMEOUT 60.0

@interface LQClientBase(Private)
- (NSData*)generateKeyForName:(NSString*)name;
- (NSString*)generateRandomName;
- (BOOL)useTestMode:(int)command;
- (NSString*)multipartContentType;
- (NSData*)testDataWithCommand:(int)command format:(int)format;
@end


@implementation LQClientBase
@synthesize delegate;

- (id)initWithDelegate:(id)clientDelegate {
	if(self = [super init]) {
		self.delegate = clientDelegate;
	}
	return self;
}

//Client Version
- (NSString*)version{
    return MG_CLIENT_VERSION;
}

#pragma mark -
#pragma mark URL process thread
- (NSString*)composeParameterString:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method{
    NSMutableString* parameterString = [NSMutableString string];
    if(parameters != nil) {
        BOOL first = YES;		
        for(NSString* key in [parameters allKeys]) {
            if ([key hasPrefix:P_INTERNAL_PREFIX]){
                //skip parameters for internal only
                continue;
            }
            
            NSString* sep = first ? @"" : @"&";
            NSString* value = [parameters objectForKey:key];
            if(value != nil) {
                if([value isKindOfClass:[NSString class]])
                {
                    [parameterString appendFormat:@"%@%@=%@", sep, key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }else{
                    [parameterString appendFormat:@"%@%@=%d", sep, key, [value intValue]];
                }
                
                first = NO;
            }
        }
    }
    
    return parameterString;
}

- (NSData*)composeMultipartData:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method{
    return nil;
}

- (NSData*)getRequestData:(NSMutableURLRequest*)request returningResponse:(NSURLResponse* __autoreleasing*)response error:(NSError* __autoreleasing *)error{
    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

- (void)commonHttpThreadEntry:(id)param {
	// construct full url
	NSMutableString* buf = nil;
    NSDictionary* dict = (NSDictionary*)param;

	// get basic parameter
	int command = [[dict objectForKey:P_INTERNAL_COMMAND] intValue];
    int dataFormat = F_RAWDATA;
    if ([dict objectForKey:P_FORMAT] != nil){
        dataFormat = [[dict objectForKey:P_FORMAT] intValue];
    }

    id tag = [dict objectForKey:P_INTERNAL_URL_TAG];
    int timeout = [[dict objectForKey:P_INTERNAL_TIMEOUT] intValue];
    if (timeout == 0){
        timeout = TIMEOUT;
    }
    
    BOOL multipart = [[dict objectForKey:P_INTERNAL_MULTIPART] boolValue];
    
    NSString* method = [dict objectForKey:P_INTERNAL_METHOD];
    if (method == nil){
        //default we assume it is a GET method
        method = HTTP_GET;
    }

    buf = [NSMutableString stringWithString:[dict objectForKey:P_INTERNAL_URL]];

    if (buf == nil){
        NSLog(@"ERROR!!Command with nil url is passed in");
    }
    
	NSData* data = nil;
	int statusCode = -1;

    //Test Mode check
    if ([self useTestMode:command]){
        [NSThread sleepForTimeInterval:1.0];
        statusCode = 200;
        data = [self testDataWithCommand:command format:dataFormat];
        if (data == nil){
            statusCode = 404;
            data = [@"No Test Data" dataUsingEncoding:NSUTF8StringEncoding];
        }
    }

    if (statusCode == -1)
    {
        //Compose Url String
        NSString* parameterString = nil;
        
        if (!multipart){
            parameterString = [self composeParameterString:dict url:buf method:method];
            // create url and connection, begin http request
            if ([method isEqualToString:HTTP_GET] ||
                [method isEqualToString:HTTP_DELETE]){
                if (parameterString.length > 0){
                    [buf appendString:@"?"];
                    [buf appendString:parameterString];
                }
            }
        }
        
        NSURL* url = [NSURL URLWithString:buf];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url 
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                             timeoutInterval:timeout];

        if (method != nil){
            [request setHTTPMethod:method];
        }
        
        if (multipart){
            NSString* contentType = [self multipartContentType];
            NSData* body = [self composeMultipartData:dict url:buf method:method];
            if (contentType!=nil){
                [request setValue:contentType forHTTPHeaderField:@"content-type"];
            }
            if (body!=nil){
                [request setHTTPBody:body];
            }
        }else{
            if ([method isEqualToString:HTTP_PUT] ||
                [method isEqualToString:HTTP_POST]){
                if (parameterString.length > 0){
                    [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
        }

        NSHTTPURLResponse* __autoreleasing response = nil;
        NSError* __autoreleasing error = nil;
        
        data = [self getRequestData:request returningResponse:&response error:&error];
        statusCode = response == nil ? 600 : [response statusCode];
    }
        
	// check return data
	if(data == nil ||
       statusCode >= 300) {
		// notify delegate
		LQClientError* error = [[LQClientError alloc] init];
		error.command = command;
		error.statusCode = statusCode;
        error.tagObject = tag;
        if (data != nil){
            error.message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
		[self performSelectorOnMainThread:@selector(notifyDelegateForFailure:) 
							   withObject:error 
							waitUntilDone:NO];
	} else {
		id result = nil;
		SEL sel = nil;
		
		// parse json body
        if (dataFormat == F_JSON)
        {
            NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            body = [body stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
            body = [body stringByReplacingOccurrencesOfString:@"\n"withString:@"\\n"];
            id json = nil;
            //there may be no result for POST or DELETE method
            if (statusCode == 204 ||
                body.length == 0 || [body isEqualToString:@"ok"]){
                json = [NSDictionary dictionary];
            }else{
                json = [body JSONValue];
            }
            
            NSString* errMsg = nil;
            if ([json isKindOfClass:[NSDictionary class]]){
                errMsg = [json objectForKey:TAG_ERROR];
            }
            
            if ([errMsg length] == 0)
            {
                switch (command) {
                    case C_CHECK_UPDATE:
                        result = json;
                        sel = @selector(notifyDelegateForCheckUpdate:);            
                        break;
                    default:
                        result = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithUnsignedInt:dataFormat], P_FORMAT, 
                                  [NSNumber numberWithUnsignedInt:command], P_INTERNAL_COMMAND, 
                                  json, @"data",
                                  tag, P_INTERNAL_URL_TAG, 
                                  nil];
                        sel = @selector(notifyDelegateForCommandResult:);            
                        break;
                }
            }
        }else if (dataFormat == F_RAWDATA)
        {
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithUnsignedInt:dataFormat], P_FORMAT, 
                                      [NSNumber numberWithUnsignedInt:command], P_INTERNAL_COMMAND, 
                                      data, @"data",
                                      tag, P_INTERNAL_URL_TAG, 
                                      nil];
            sel = @selector(notifyDelegateForCommandResult:);            
        }
            
		if(sel != nil && result != nil) {
			[self performSelectorOnMainThread:sel 
								   withObject:result 
								waitUntilDone:NO];	
		} else {
			// notify delegate for failure
			LQClientError* error = [[LQClientError alloc] init];
			error.command = command;
			error.statusCode = statusCode;
            error.tagObject = [dict objectForKey:P_INTERNAL_URL_TAG];
			[self performSelectorOnMainThread:@selector(notifyDelegateForFailure:) 
								   withObject:error 
								waitUntilDone:NO];
		}
	}
	
}

#pragma mark -
#pragma mark Test Data handling
- (BOOL)useTestMode:(int)command{
    //default not use test mode
    return NO;
}

- (NSData*)testDataWithCommand:(int)command format:(int)format{
    return nil;
}

#pragma mark -
#pragma mark Result handling

- (void)notifyDelegateForCheckUpdate:(NSDictionary*)jsonObj{
    NSString* curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    
    NSDictionary* updateObj = [jsonObj valueForKey:@"self_update"];
    
    NSString* ver = [updateObj valueForKey:@"versionName"];
    if ([curVersion compare:ver options:NSNumericSearch] == NSOrderedAscending){
        NSString* link = [updateObj valueForKey:@"downloadUri"];
        NSString* localDescKey = [NSString stringWithFormat:@"%@_%@", @"desc", [[NSLocale currentLocale] localeIdentifier]];
        NSString* desc = [updateObj valueForKey:localDescKey];
        if (desc == nil){
            desc = [updateObj valueForKey:@"Intro"];
        }
        
        if (link == nil){
            link = @"";
        }
        
        if (desc == nil){
            desc = @"";
        }
        
        if([self.delegate respondsToSelector:@selector(client:didNeedUpdate:link:newVersion:)]) {
            [self.delegate client:self didNeedUpdate:desc link:link newVersion:ver];
        }
    }    
    
}

- (void)notifyDelegateForFailure:(LQClientError*)error {
	if([self.delegate respondsToSelector:@selector(client:didFailExecution:)]) {
		[self.delegate client:self didFailExecution:error];
	}
}

- (void)notifyDelegateForCommandResult:(NSDictionary*)result{
    id tag = [result objectForKey:P_INTERNAL_URL_TAG];
    int tagValue = 0;
    if (tag != nil && 
        [tag isKindOfClass:[NSNumber class]]){
        tagValue = [tag intValue];
    }    

    if([self.delegate respondsToSelector:@selector(client:didGetCommandResult:forCommand:format:tagObject:)]) {
        [self.delegate client:self didGetCommandResult:[result objectForKey:@"data"]
               forCommand:[[result objectForKey:P_INTERNAL_COMMAND] intValue]
                   format:[[result objectForKey:P_FORMAT] intValue]
                tagObject:tag];
    }else{
        if([self.delegate respondsToSelector:@selector(client:didGetCommandResult:forCommand:format:tag:)]) {
            [self.delegate client:self didGetCommandResult:[result objectForKey:@"data"]
                   forCommand:[[result objectForKey:P_INTERNAL_COMMAND] intValue]
                       format:[[result objectForKey:P_FORMAT] intValue]
                          tag:tagValue];
        }        
    }
}

#pragma mark -
#pragma mark URL composing
- (NSString*)multipartContentType{
    return nil;
}

- (NSMutableDictionary*)composeParametersForCommand:(int)command withUrl:(NSString*)url ofFormat:(int)format{
    return 	[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:command], P_INTERNAL_COMMAND,
                                           [self version], P_CLIENT_VERSION,
                                           @"Apple", P_BRAND,
                                           [UIDevice currentDevice].model, P_MODEL,
                                           [UIDevice currentDevice].systemName, P_OS,
//                                           [UIDevice currentDevice].uniqueIdentifier, P_USER_ID,
                                           [NSNumber numberWithInt:format], P_FORMAT,
                                           url, P_INTERNAL_URL,
                                           nil];    
}

#pragma mark -
#pragma mark URL encoding composing
- (NSString*)composeEncodedString:(NSDictionary*)params encodeKey:(NSString*)encodeKey{
    NSMutableString* url = [NSMutableString string];
    for (NSString* key in [params keyEnumerator]){
        [url appendString:key];
        [url appendString:@"="];
        [url appendString:[[NSString stringWithFormat:@"%@", [params objectForKey:key]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"&"];
    }
    
    return url;//[url encodeUrlWithKey:[self generateKeyForName:encodeKey]];
}

- (void)addParamsAsEncoded:(NSMutableDictionary*)queryParams params:(NSDictionary*)params{
    NSString* encodedKey = [self generateRandomName];
    NSString* encoded = [self composeEncodedString:params encodeKey:encodedKey];
    [queryParams setObject:encoded forKey:@"encoded"];
    [queryParams setObject:encodedKey forKey:@"sig"];
}

- (NSData*)generateKeyForName:(NSString*)name{
    return [name dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)generateRandomName{
    return [NSString stringWithFormat:@"%.8x", rand()];
}

#pragma mark -
#pragma mark Generatl functions

- (void)processCheckUpdate:(NSString*)url{
	NSMutableDictionary* queryParams = [self composeParametersForCommand:C_CHECK_UPDATE withUrl:url ofFormat:F_JSON]; 
    [queryParams setObject:@"check_update_self" forKey:@"op"];
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processCommand:(NSString*)url command:(UInt32)command{
	NSMutableDictionary* queryParams = [self composeParametersForCommand:command withUrl:url ofFormat:F_JSON]; 
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processCommand:(NSString*)url command:(UInt32)command format:(int)format{
	NSMutableDictionary* queryParams = [self composeParametersForCommand:command withUrl:url ofFormat:format]; 
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processCommand:(NSString*)url command:(UInt32)command format:(int)format parameters:(NSDictionary*)parameters encoding:(BOOL)encoding{
	NSMutableDictionary* queryParams = [self composeParametersForCommand:command withUrl:url ofFormat:format]; 
    if (encoding){
        [self addParamsAsEncoded:queryParams params:parameters];     
    }else{
        [queryParams addEntriesFromDictionary:parameters];
    }
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processCommand:(NSString*)url command:(UInt32)command withTag:(int)tag{
    NSMutableDictionary* queryParams = [self composeParametersForCommand:command withUrl:url ofFormat:F_JSON]; 
    [queryParams setObject:[NSNumber numberWithInt:tag] forKey:P_INTERNAL_URL_TAG];
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processCommand:(NSString*)url command:(UInt32)command withTag:(int)tag parameters:(NSDictionary*)parameters encoding:(BOOL)encoding{
	NSMutableDictionary* queryParams = [self composeParametersForCommand:command withUrl:url ofFormat:F_JSON]; 
    [queryParams setObject:[NSNumber numberWithInt:tag] forKey:P_INTERNAL_URL_TAG];
    if (encoding){
        [self addParamsAsEncoded:queryParams params:parameters];     
    }else{
        [queryParams addEntriesFromDictionary:parameters];
    }
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}


- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command{
    NSMutableDictionary* queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithInt:command], P_INTERNAL_COMMAND,
             url, P_INTERNAL_URL,
             nil];    
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command withTag:(int)tag{
    NSMutableDictionary* queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:command], P_INTERNAL_COMMAND,
                                        [NSNumber numberWithInt:tag], P_INTERNAL_URL_TAG,
                                        url, P_INTERNAL_URL,
                                        nil];    
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command withParameters:(NSDictionary*)parameters{
    NSMutableDictionary* queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:command], P_INTERNAL_COMMAND,
                                        url, P_INTERNAL_URL,
                                        nil];   
    [queryParams addEntriesFromDictionary:parameters];
	[NSThread detachNewThreadSelector:@selector(commonHttpThreadEntry:) toTarget:self withObject:queryParams];
}

@end

@implementation LQClientError

@synthesize command;
@synthesize statusCode;
@synthesize tagObject;
@synthesize message;

- (int)tag{
    if ([self.tagObject isKindOfClass:[NSNumber class]]){
        return [self.tagObject intValue];
    }
    
    return 0;
}

@end
