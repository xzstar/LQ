//
//  QYXInstaller.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define HOME_0 @"/private/var/mobile/Library/SpringBoard/HomeBackground.jpg"
//#define HOME_1 @"/private/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"
//#define HOME_2 @"/private/var/mobile/Library/SpringBoard/HomeBackgroundThumbnail.jpg"
//
//
//#define LOCK_0 @"/private/var/mobile/Library/SpringBoard/LockBackground.jpg"
//#define LOCK_1 @"/private/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"
//#define LOCK_2 @"/private/var/mobile/Library/SpringBoard/HomeBackgroundThumbnail.jpg"

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

- (BOOL)smsToneInstall:(NSString*)src dest:(NSString*)dest;
- (BOOL)ringToneInstall:(NSString*)displayName src:(NSString*)src dest:(NSString*)dest;
- (BOOL)wallPaperInstall:(NSString*)src dest:(NSString*)dest;
@end



