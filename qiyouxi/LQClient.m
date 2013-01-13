//
//  LQClient.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQClient.h"
#import "LQAPICache.h"

#define QYX_API_SERVER @"http://www.7youxi.cn/api"
#define LQ_API_SERVER  @"http://appserver.liqucn.com/ios"
#define LQ_API_REQUEST @"/request.php"

@implementation LQClient
#pragma mark - Override
- (NSMutableDictionary*)composeParametersForCommand:(int)command withUrl:(NSString*)url ofFormat:(int)format{
    NSString* countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString* locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    
    return 	[NSMutableDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithInt:command], P_INTERNAL_COMMAND,
             [NSNumber numberWithInt:30.0f], P_INTERNAL_TIMEOUT,
             [NSNumber numberWithInt:format], P_FORMAT,
             url, P_INTERNAL_URL,
             @"iphone", @"platform",
//             [self version], @"sdkv",
//             WIGAME_API_VERSION, @"apiv",
//             [WiGameSession currentSession].platform, @"platform",
//             [WiGameSession currentSession].appVersion, @"appv",
             countryCode, @"country",
             locale, @"language",
             nil];    
}

//- (NSString*)composeParameterString:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method{
//    NSDictionary* parameterToSend = [self generateFormToSend:parameters url:url method:method];
//    
//    NSMutableString* parameterString = [NSMutableString string];
//    BOOL first = YES;
//    for(NSString* key in [parameterToSend allKeys]) {
//        NSString* sep = first ? @"" : @"&";
//        id value = [parameterToSend objectForKey:key];
//        if (![value isKindOfClass:[WiGameFileData class]]){
//            [parameterString appendFormat:@"%@%@=%@", sep, key, [value stringByAddUrlPercentEscapes]];
//        }
//        first = NO;
//    }
//    
//    return parameterString;
//}

//- (NSString*)multipartContentType{
//    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", WYCLOUD_FORM_BOUNDARY];
//}

//- (NSData*)composeMultipartData:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method{
//    NSDictionary* parameterToSend = [self generateFormToSend:parameters url:url method:method];
//    
//    NSMutableData* body = [NSMutableData data];
//    BOOL valueIsData= NO;
//    int count = parameterToSend.count;
//    int index = 0;
//    for(NSString* key in [parameterToSend allKeys]) {
//        id value = [parameterToSend objectForKey:key];
//        if ([value isKindOfClass:[WiGameFileData class]]){
//            valueIsData = YES;
//        }else{
//            valueIsData = NO;
//        }
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", WYCLOUD_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        if (valueIsData){
//            WiGameFileData* fileData = (WiGameFileData*)value;
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n", key, fileData.name] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileData.fileType] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:fileData.data];
//        }else{
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Type: text/plain; charset=utf-8\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: 8bit\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        index++;
//        if (index == count){
//            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", WYCLOUD_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//    }
//    
//    return body;
//}

- (NSString*) getUrl:(NSString*) path{
    NSURL* url =[[NSURL alloc]initWithString:path];
    return url.path;
}

- (NSDictionary*) getParameter:(NSString*) path{
    NSURL* url =[[NSURL alloc]initWithString:path];
    NSString* parameterString = url.parameterString;
    NSArray* items = [parameterString componentsSeparatedByString:@"&"];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    for (NSString* item in items){
        NSArray* keyvalue = [item componentsSeparatedByString:@"="];
        if (keyvalue.count == 2){
            NSString* key = [keyvalue objectAtIndex:0];
            NSString* value = [keyvalue objectAtIndex:1];
            [parameters setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];            
        }
    }
    [parameters setObject:HTTP_GET forKey:P_INTERNAL_METHOD];
    return parameters;

}
- (NSData*)getRequestData:(NSMutableURLRequest*)request returningResponse:(NSURLResponse* __autoreleasing *)response error:(NSError* __autoreleasing*)error{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval duration = 0.5;
    NSData* data = [[LQAPICache sharedInstance] getAPICache:request returningResponse:response];
    if (*response == nil){
        data = [super getRequestData:request returningResponse:response error:error];
        
        if (data != nil){
            [[LQAPICache sharedInstance] saveAPICache:request response:*response data:data];
        }

        duration = [[NSDate date] timeIntervalSince1970] - start;
    }

    if (duration < 0.5){
        [NSThread sleepForTimeInterval:0.5-duration];
    }
    
    return data;
}

- (void)notifyDelegateForFailure:(LQClientError*)error{
//    if (error.statusCode >= 600){
//        error.message = WiGameLocalized(@"error.nonetwork");        
//    }else if (error.statusCode >= 500){
//        if ([WiGameSession currentSession].useSandbox){
//            if (error.message.length  == 0){
//                error.message = WiGameLocalized(@"error.server.busy");        
//            }else{
//                if ([error.message hasPrefix:@"{"]){
//                    id json = [error.message parseAsJson];
//                    error.message = [json objectForKey:@"msg"];
//                }
//            }
//        }else{
//            error.message = WiGameLocalized(@"error.server.busy");        
//        }
//    }else{
//        if ([error.message hasPrefix:@"{"]){
//            id json = [error.message parseAsJson];
//            error.message = [json objectForKey:@"msg"];
//        }
//    }
    [super notifyDelegateForFailure:error];
}

- (void)notifyDelegateForCommandResult:(NSDictionary*)result{
    [super notifyDelegateForCommandResult:result];
}


- (NSString*)version{
    return @"1.0";
}

#pragma mark - API
- (void)loadRecommendation{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                @"jPoHFsMC5a33cPTRNJTPxw", @"api_key",
                                @"5d881200fb9da931009e9080b87d9df99c6aa320",@"nonce",
                                @"1285553664174",@"timestamp",
                                @"66cbf30b84b2b7a63f790b058a088945",@"api_sig",
                                @"homepage",@"op",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", @"http://appserver.liqucn.com/ios", @"/request.php"]
                 command:C_COMMAND_GETRECOMMENDATION
                  format:F_JSON
              parameters:parameters
                encoding:NO];

    
}

- (void)loadSoftNewest{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                @"app_list",@"op",
                                @"new",@"orderby",
                                @"rj",@"nodeid",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", @"http://appserver.liqucn.com/ios", @"/request.php"]
                 command:C_COMMAND_GETAPPLISTSOFTGAME
                  format:F_JSON
              parameters:parameters
                encoding:NO];

}


- (void) loadAppLisCommon:(NSString *)listOperator 
                   nodeid:(NSString *)nodeid 
                  orderby:(NSString *)orderby{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                listOperator,@"op",
                                orderby,@"orderby",
                                nodeid,@"nodeid",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", @"http://appserver.liqucn.com/ios", @"/request.php"]
                 command:C_COMMAND_GETAPPLISTSOFTGAME
                  format:F_JSON
              parameters:parameters
                encoding:NO];
    

}

- (void) searchAppLisCommon:(NSString *)listOperator 
                   keywords:(NSString *)keywords 
{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                listOperator,@"op",
                                keywords,@"keywords",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", LQ_API_SERVER, LQ_API_REQUEST]
                 command:C_COMMAND_SEARCH
                  format:F_JSON
              parameters:parameters
                encoding:NO];
    
    
}

- (void) loadCategory:(NSString*) category{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                category,@"op",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", @"http://appserver.liqucn.com/ios", @"/request.php"]
                 command:C_COMMAND_GETCATEGORY
                  format:F_JSON
              parameters:parameters
                encoding:NO]; 
}

- (void)loadTodayRecommendation:(NSDate*)date{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSString* dateValue = [format stringFromDate:date];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                dateValue, @"show_date",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/games"]
                 command:C_COMMAND_GETRECOMMENDATION
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadTodayAdvs{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/home/adv"]
                 command:C_COMMAND_GETTODAYADVS
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadAnnouncement{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                @"1", @"count",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/notices"]
                 command:C_COMMAND_GETANNOUNCEMENT
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadHistory:(NSDate*)startDate days:(int)days{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate* endDate = [startDate dateByAddingTimeInterval:-3600*24*(days-1)];
    NSString* startDateValue = [format stringFromDate:startDate];
    NSString* endDateValue = [format stringFromDate:endDate];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                endDateValue, @"start_int_date",
                                startDateValue, @"end_int_date",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/history"]
                 command:C_COMMAND_GETHISTORY
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadCategories{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/category"]
                 command:C_COMMAND_GETCATEGORIES
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadGameOfCategory:(int)categoryId start:(int)start count:(int)count{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                [NSNumber numberWithInt:start], @"start",
                                [NSNumber numberWithInt:count], @"count",
                                [NSNumber numberWithInt:categoryId], @"category_id",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/categorys"]
                 command:C_COMMAND_GETGAMEOFCATEGORY
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadGameInfo:(int)gameId{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                @"app_info",@"op",
                                [NSNumber numberWithInt:gameId], @"game_id",
                                [NSNumber numberWithInt:gameId], @"index_id",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", LQ_API_SERVER, LQ_API_REQUEST]
                 command:C_COMMAND_GETGAMEINFO
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)loadUserComments:(int)gameId{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                @"app_comments",@"op",
                                [NSNumber numberWithInt:gameId],@"index_id",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", LQ_API_SERVER, LQ_API_REQUEST]
                 command:C_COMMAND_GETUSERCOMMENTS
                  format:F_JSON
              parameters:parameters
                encoding:NO];

}

- (void)loadUserMoreComments:(NSString*) moreUrl{
    //NSString* url = [self getUrl:moreUrl];
    NSDictionary* parameters = [self getParameter:moreUrl];

    [self processCommand:[NSString stringWithFormat:@"%@%@", LQ_API_SERVER, LQ_API_REQUEST]
                 command:C_COMMAND_GETUSERCOMMENTS
                  format:F_JSON
              parameters:parameters
                encoding:NO];
    
}

- (void)loadUserComments:(int)gameId start:(int)start count:(int)count{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                [NSNumber numberWithInt:start], @"start",
                                [NSNumber numberWithInt:count], @"count",
                                [NSNumber numberWithInt:gameId], @"game_id",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/comments"]
                 command:C_COMMAND_GETUSERCOMMENTS
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

- (void)submitComment:(int)gameId comment:(NSString*)comment nick:(NSString*)nick{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_POST, P_INTERNAL_METHOD,
                                [NSNumber numberWithInt:gameId], @"game_id",
                                [UIDevice currentDevice].model, @"device",
                                comment, @"comment",
                                nick, @"nick",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/comment"]
                 command:C_COMMAND_SUBMITCOMMENT
                  format:F_RAWDATA
              parameters:parameters
                encoding:NO];
}

- (void)submitFeedback:(NSString*)feedback contact:(NSString*)contact{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_POST, P_INTERNAL_METHOD,
                                feedback, @"feedback",
                                contact, @"contact",
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/feedback"]
                 command:C_COMMAND_SUBMITFEEDBACK
                  format:F_RAWDATA
              parameters:parameters
                encoding:NO];
}

- (void)loadLaunchImage{
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                HTTP_GET, P_INTERNAL_METHOD,
                                nil];
    [self processCommand:[NSString stringWithFormat:@"%@%@", QYX_API_SERVER, @"/game/simage"]
                 command:C_COMMAND_GETLAUNCHIMAGE
                  format:F_JSON
              parameters:parameters
                encoding:NO];
}

@end
