//
//  LQUtilities.h
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQUtilities : NSObject

+(BOOL) copyFile:(NSString*) srcPath destPath:(NSString*) destPath;
+(BOOL) removeFile:(NSString*) destPath ;
+(void)AlertWithMessage:(NSString *)message;

@end
