//
//  QYXAPICache.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-8.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQAPICache : NSObject
+ (LQAPICache*)sharedInstance;
- (NSData*)getAPICache:(NSURLRequest*)request returningResponse:(NSURLResponse* __autoreleasing *)response;
- (void)saveAPICache:(NSURLRequest*)request response:(NSURLResponse*)response data:(NSData*)data;

@end
