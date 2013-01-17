//
//  LQConfig.h
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQConfig : NSObject

+ (NSArray*) restoreSearchHistory;
+ (void) saveSearchHisory:(NSArray*) searchHistory;

@end
