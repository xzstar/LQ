//
//  LQConfig.h
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQConfig : NSObject

+ (NSArray*) restoreArray:(NSString*) filename;
+ (void) saveArray:(NSString*) filename savedValue:(NSArray*) savedValue;

+ (NSString*) restoreString:(NSString*) filename;
+ (void) saveString:(NSString*) filename savedValue:(NSString*) savedValue;



+ (NSArray*) restoreSearchHistory;
+ (void) saveSearchHisory:(NSArray*) searchHistory;


+ (NSString*) restoreAppList;
+ (void) saveAppList:(NSString*) appList;

+ (NSString*) restoreUpdateAppList;
+ (void) saveUpdateAppList:(NSString*) appList;

+ (NSString*) restoreIgnoreAppList;
+ (void) saveIgnoreAppList:(NSString*) appList;


@end
