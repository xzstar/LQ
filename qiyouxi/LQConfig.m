//
//  LQConfig.m
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQConfig.h"

#define SEARCHHISTORY @"searchHistory.plist"
@implementation LQConfig

+ (NSArray*) restoreSearchHistory{
    // 得到documents directory的路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        // dictionary的保存路径
		NSString  *infoPath = [[paths objectAtIndex:0]
								   stringByAppendingPathComponent:SEARCHHISTORY];
		
		return [NSArray arrayWithContentsOfFile:infoPath];		
	}
	return nil;
}
+ (void) saveSearchHisory:(NSArray*) searchHistory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
        
	if ([paths count] > 0)
	{
		NSString  *infoPath = [[paths objectAtIndex:0]
								   stringByAppendingPathComponent:SEARCHHISTORY];
		
		// 保存 
        [searchHistory writeToFile:infoPath atomically:YES];
       
	}
	else {
		//NSLog(@"error when cache user info schema");
	}
	
}
@end
