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


#pragma mark - for test
+ (NSString*) restoreAppList;
+ (void) saveAppList:(NSString*) appList;



#pragma mark - for use
+ (NSArray*) restoreSearchHistory;
+ (void) saveSearchHisory:(NSArray*) searchHistory;


+ (NSArray*) restoreUpdateAppList;
+ (void) saveUpdateAppList:(NSArray*) appList;

+ (NSArray*) restoreIgnoreAppList;
+ (void) saveIgnoreAppList:(NSArray*) appList;


@end
