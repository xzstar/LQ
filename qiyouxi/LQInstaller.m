//
//  QYXInstaller.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQInstaller.h"
#include <dlfcn.h>

static LQInstaller* _instance = nil;

typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);
typedef int (*MobileInstallationBrowse)(NSDictionary *options, int (*callback)(NSDictionary *dict, id value), id value);

@interface UIApplication()
- (void)launchApplicationWithIdentifier:(NSString*)identifier suspended:(BOOL)suspended;
@end


static int callback(NSDictionary *dict, id result) { 
    NSArray *currentlist = [dict objectForKey:@"CurrentList"]; 
    if (currentlist){ 
        for (NSDictionary *appinfo in currentlist) { 
            [(NSMutableArray*)result addObject:[appinfo copy]]; 
        } 
    } 
    return 0; 
}

@implementation LQInstaller
+ (LQInstaller*)defaultInstaller{
    if (_instance == nil){
        _instance = [[LQInstaller alloc] init];
    }
    
    return _instance;
}

- (IPAResult) IPAInstall:(NSString *)path{
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib)
    {
        MobileInstallationInstall pMobileInstallationInstall = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        if (pMobileInstallationInstall)
        {
            NSString *name = [@"Install_" stringByAppendingString:path.lastPathComponent];
            NSString* temp = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
            if (![[NSFileManager defaultManager] copyItemAtPath:path toPath:temp error:nil])
                return IPAResultFileNotFound;
            
            int ret = (IPAResult) pMobileInstallationInstall(temp, 
                                                             [NSDictionary dictionaryWithObject:
                                                              @"User" forKey:@"ApplicationType"], 0, path);
            [[NSFileManager defaultManager] removeItemAtPath:temp error:nil];
            return ret;
        }
    }
    
    return IPAResultNoFunction;
}

- (IPAResult)IPABrowse:(NSMutableArray*) results{
    void *lib = dlopen("/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation", RTLD_LAZY);
    if (lib){
        MobileInstallationBrowse pMobileInstallationBrowse = (MobileInstallationBrowse)dlsym(lib, "MobileInstallationBrowse");
        if (pMobileInstallationBrowse){
            NSDictionary* options = [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"];
            //Any 代表所有程序，这里可以用 “System” “User”来区分系统和普通软件
            pMobileInstallationBrowse(options, &callback, results);
        }
    }
    
    return IPAResultNoFunction;
    
}

- (BOOL)launchApp:(NSString *)identifier{
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:identifier suspended:NO];
    return YES;
}

@end





 

