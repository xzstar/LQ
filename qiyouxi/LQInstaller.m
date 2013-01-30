//
//  QYXInstaller.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQInstaller.h"
#include <dlfcn.h>
#import "LQUtilities.h"
//#define RINGPATH @"/System/Library/Audio/UISounds/"

#define SPRINGBOARDPLIST @"/var/mobile/Library/Preferences/com.apple.springboard.plist"
#define RINGTONEPLIST @"/private/var/mobile/Media/iTunes_Control/iTunes/Ringtones.plist"
#define HOME_0 @"/private/var/mobile/Library/SpringBoard/HomeBackground.jpg"
#define HOME_1 @"/private/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"
#define HOME_2 @"/private/var/mobile/Library/SpringBoard/HomeBackgroundThumbnail.jpg"


#define LOCK_0 @"/private/var/mobile/Library/SpringBoard/LockBackground.jpg"
#define LOCK_1 @"/private/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"
#define LOCK_2 @"/private/var/mobile/Library/SpringBoard/LockBackgroundThumbnail.jpg"

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

- (BOOL)smsToneInstall:(NSString*)src dest:(NSString*)dest{
//    BOOL result = [LQUtilities copyFile:src destPath:dest];
//    if (result == NO) {
//        return result;
//    }
    BOOL result;
    NSString* command = [NSString stringWithFormat:@". /Applications/liqu.app/SetSMSRing.sh %@ %@",src,dest];
    
    int state = system([command cStringUsingEncoding:NSUTF8StringEncoding]);
    result = state>=0;
    if (result == NO) {
        NSLog(@"SetSMSRing.sh error %d",state);
        return result;
    }
    
    NSMutableDictionary *custDict = [[NSMutableDictionary alloc] initWithContentsOfFile:SPRINGBOARDPLIST];
    NSString* filename = [[dest lastPathComponent] stringByDeletingPathExtension];
    NSString* ringtone = [NSString stringWithFormat:@"texttone:%@",filename];
    [custDict setObject:ringtone forKey:@"sms-sound-identifier"];
    result = [custDict writeToFile:SPRINGBOARDPLIST atomically:YES];
    return result;
}
- (BOOL)ringToneInstall:(NSString*)displayName src:(NSString*)src dest:(NSString*)dest{
    BOOL result =  [LQUtilities copyFile:src destPath:dest];
    
    if (result == NO) {
        return result;
    }
    NSMutableDictionary *custDict = [[NSMutableDictionary alloc] initWithContentsOfFile:RINGTONEPLIST];
    NSString* filename = [dest lastPathComponent];
    NSMutableDictionary *ringtoneDict = [custDict objectForKey:@"Ringtones"];
    
    NSMutableDictionary *ringtoneItemDict = [[NSMutableDictionary alloc]init ];
    [ringtoneItemDict setObject:displayName forKey:@"Name"];
    [ringtoneItemDict setObject:[LQUtilities stringWithUUID] forKey:@"GUID"];
    [ringtoneDict setObject:ringtoneItemDict forKey:filename];
    result = [custDict writeToFile:RINGTONEPLIST atomically:YES];
    return result;
}

- (void)removeWallpaper:(NSString*) dest{
    NSString* filename = [[dest lastPathComponent] stringByDeletingPathExtension];
    
    if([filename hasPrefix:@"HomeBackground"]){
        [LQUtilities removeFile:HOME_0];
        [LQUtilities removeFile:HOME_1];
        [LQUtilities removeFile:HOME_2];
    }
    else{
        [LQUtilities removeFile:LOCK_0];
        [LQUtilities removeFile:LOCK_1];
        [LQUtilities removeFile:LOCK_2];
    }  
    
}

- (BOOL)wallPaperInstall:(NSString*)src dest:(NSString*)dest{
    NSString* filename = [[dest lastPathComponent] stringByDeletingPathExtension];
    
    NSLog(@"install src %@",src);
    
    NSString* cpbitmapPath = [LQUtilities createcpBitmap:src savedcpbitmapName:filename];
    NSString* cpbitmapPathDest;
    if([filename hasPrefix:@"HomeBackground"]){
        cpbitmapPathDest = HOME_1;
    }
    else{
        cpbitmapPathDest = LOCK_1;
    }  
    
    NSLog(@"remove finish");
    
    BOOL result;
    if(cpbitmapPath!=nil)
        result = [LQUtilities copyFile:cpbitmapPath destPath:cpbitmapPathDest]; 
    if(result == YES)
        result = [LQUtilities copyFile:src destPath:dest];
    
    return result;
}

@end





 

