//
//  LQUtilities.m
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQUtilities.h"

@implementation LQUtilities
+(BOOL) copyFile:(NSString*) srcPath destPath:(NSString*) destPath{
    NSError* error=nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSLog(@"文件存在");
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];//删除不了哦
        if (error!=nil) {
            NSLog(@"error=%@",error);
            return NO;
        }
    }
    
    [[NSFileManager defaultManager]copyItemAtPath:srcPath toPath:destPath error:&error ];
    if (error!=nil) {
        return NO;
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
    }
    return YES;

}

+(BOOL) removeFile:(NSString*) destPath {
     NSError* error=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSLog(@"文件存在");
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];//删除不了哦
        if (error!=nil) {
            NSLog(@"error=%@",error);
            return NO;
        }
    }
    return YES;
}

+ (void)AlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
