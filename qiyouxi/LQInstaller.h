//
//  QYXInstaller.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _IPAResult {
    IPAResultSuccess,
    IPAResultFileNotFound,
    IPAResultNoFunction
} IPAResult;

@interface LQInstaller : NSObject
+ (LQInstaller*)defaultInstaller;

- (IPAResult) IPAInstall:(NSString *)path;
- (IPAResult) IPABrowse:(NSMutableArray*) results;
- (BOOL)launchApp:(NSString*)identifier;
@end



