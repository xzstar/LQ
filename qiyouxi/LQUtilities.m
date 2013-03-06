//
//  LQUtilities.m
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQUtilities.h"
#import "LQConfig.h"
#import "UIImage+Scale.h"
#import "LQDownloadManager.h"
#import "LQSMSRingReplaceViewController.h"
#define RINGTONEPATH @"/private/var/mobile/Media/iTunes_Control/Ringtones"

@implementation LQUtilities
+(BOOL) copyFile:(NSString*) srcPath destPath:(NSString*) destPath{
    NSError* error=nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSLog(@"%@文件存在",destPath);
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];//删除不了哦
        if (error!=nil) {
            NSLog(@"%@ error=%@",destPath,[error userInfo]);
            return NO;
        }
        NSLog(@"%@文件删除成功",destPath);

    }
    
    [[NSFileManager defaultManager]copyItemAtPath:srcPath toPath:destPath error:&error ];
    if (error!=nil) {
        //NSLog(@"%@", error);
        NSLog(@"%@ to %@ -- err:%@",srcPath,destPath, [error userInfo]);
        return NO;

    }
    return YES;

}

+(BOOL) removeFile:(NSString*) destPath {
     NSError* error=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSLog(@"%@文件存在",destPath);
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];//删除不了哦
        if (error!=nil) {
            NSLog(@"%@ error=%@",destPath,[error userInfo]);
            return NO;
        }
        NSLog(@"%@文件删除成功",destPath);

    }
    return YES;
}

+ (void)AlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+(NSString *)documentsDirectoryPath
{
    
#ifdef JAILBREAK
    NSString *documentPath =@"/var/mobile/Library/apodang/Documents";
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return documentPath;
#else
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [documentPaths objectAtIndex:0];    
    return path;
#endif
    
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* path = [documentPaths objectAtIndex:0];    
//    
//    if([path isEqualToString:@"/var/mobile/Library"]){
//        //Application is installed in /Applications
//        NSString *documentPath =@"/var/mobile/Library/apodang/Documents";
//        if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
//        {
//            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
//                                      withIntermediateDirectories:NO
//                                                       attributes:nil
//                                                            error:NULL];
//        }
//        return documentPath;
//    }
//    else
//        return path;
}

+(NSString *)cacheDirectoryPath
{
#ifdef JAILBREAK
    NSString *documentPath =@"/var/mobile/Library/apodang/Cache";
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    }
    return documentPath;
#else
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [documentPaths objectAtIndex:0];    
    return path;
#endif
    
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* path = [documentPaths objectAtIndex:0];    
//    
//    if([path isEqualToString:@"/var/mobile/Library"]){
//        //Application is installed in /Applications
//        NSString *documentPath =@"/var/mobile/Library/apodang/Cache";
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
//        {
//            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath
//                                      withIntermediateDirectories:NO
//                                                       attributes:nil
//                                                            error:NULL];
//        }
//        
//        return documentPath;
//        
//    }
//    return path;
}


+(unsigned char *)getImageData:(UIImage*)image
{//此函数是将UIImage的像素点保存在 unsigned char * 里面，不能直观的用.x或者.y读取，可以转换下
    CGImageRef imageref = [image CGImage];
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    
    int width=CGImageGetWidth(imageref);
    int height=CGImageGetHeight(imageref);
    int bytesPerPixel=4;
    int bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent = 8;
    
    unsigned char * imagedata=malloc(width*height*bytesPerPixel);
    
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata,
                                               width,
                                               height,
                                               bitsPerComponent,
                                               bytesPerRow,
                                               colorspace,
                                               kCGImageAlphaPremultipliedFirst);
    //将图像写入一个矩形
    CGRect therect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(cgcnt, therect, imageref);
    
    //  imagedata = CGBitmapContextGetData(cgcnt);//这句不知道要不要，求高手指点
    
    //    释放资源
    CGColorSpaceRelease(colorspace);
    CGContextRelease(cgcnt);    
    
    return imagedata;
    
}

+(NSString*)createcpBitmap:(NSString*)imagePath savedcpbitmapName:(NSString*)savedcpbitmapName{
    //UIImage* sourceImage = image;
    
    UIImage* sourceImage = [UIImage imageWithContentsOfFile:imagePath];
    if(sourceImage == nil)
        return nil;

    CGSize size = [UIScreen mainScreen].bounds.size; 
    float scale = [UIScreen mainScreen].scale;
    size.width*=scale;
    size.height*=scale;
    UIImage* sizedSourceImage =[sourceImage scaleToSize:size];
    
    void* data = [self getImageData:sizedSourceImage];
    
    for (int i=0; i<size.width*size.height; i++) {
        char* ch1 = &((char*)data)[i*4];
        char* ch2 = &((char*)data)[i*4+1];
        char* ch3 = &((char*)data)[i*4+2];
        char* ch4 = &((char*)data)[i*4+3];
        
        char temp = *ch1;
        *ch1 = *ch4;
        *ch4 = temp;
        
        temp = *ch2;
        *ch2 = *ch3;
        *ch3 = temp;
        
    }
    
    
    NSMutableData* imageData = [[NSMutableData alloc] initWithBytes:data length:size.width*size.height*4];
    
    
    
    static unsigned char tailData[] = {
        0x00, 0x00, 0x00, 0x00, 
        0x80, 0x02, 0x00, 0x00, 0xc0, 0x03, 0x00, 0x00,  //0x280 0x3c0
        0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
        0x00, 0x00, 0x91, 0x32, 0xa4, 0xcb,   
    };
    
    // update new width & height
    int* tempTail = (int*) tailData;
    tempTail[1] = size.width;
    tempTail[2] = size.height;
    
    
    //        static unsigned char tailData[] = {
    //            0x62, 0x70, 0x6c, 0x69, 0x73, 0x74, 0x30, 0x30, 0x22, 0x40, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 
    //            0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 
    //            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0d, 0x2e, 0x00, 
    //            0x00, 0x00, 0x80, 0x02, 0x00, 0x00, 0xc0, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
    //            0x00, 0x00, 0x91, 0x32, 0xa4, 0xcb, 0x0a,   
    //        };
    
    NSString  *infoPath =[[self documentsDirectoryPath] stringByAppendingPathComponent:savedcpbitmapName];
    
    [imageData appendBytes:tailData length:24];
    
    [imageData writeToFile:infoPath atomically:YES];
    return infoPath;
}

+(NSString*) stringWithUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}


+(void) installRing:(UIViewController*)parentController gameInfo:(LQGameInfo*) gameInfo{
    if([gameInfo.fileType isEqualToString:@"sms_ring"]){
        LQSMSRingReplaceViewController* controller = [[LQSMSRingReplaceViewController alloc] initWithNibName:@"LQSMSRingReplaceViewController" bundle:nil];
        controller.ringGameInfo = gameInfo;
        [parentController.navigationController pushViewController:controller animated:YES];
    }
    else{
        //NSString* fileName= [obj.filePath lastPathComponent];
        NSString* fileName= [NSString stringWithFormat:@"%@.m4r",gameInfo.name];
        
        NSString* destPath=[RINGTONEPATH stringByAppendingPathComponent:fileName];//这里要特别主意，目标文件路径一定要以文件名结尾，而不要以文件夹结尾
        
        NSArray* destPaths = [NSArray arrayWithObjects:destPath,nil];
        //obj.finalFilePaths = destPaths;
        //obj.installAfterDownloaded = YES;
        [[LQDownloadManager sharedInstance] commonAction:gameInfo installAfterDownloaded:YES installPaths:destPaths];
        //[[LQDownloadManager sharedInstance] installGameBy:obj.gameInfo.gameId];
    }
}

@end

static AppUpdateReader* _intance = nil;

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@implementation AppUpdateReader

@synthesize appsList/*,delegate*/,client;
#pragma mark - Init

+ (AppUpdateReader*)sharedInstance{
    if (_intance == nil){
        _intance = [[AppUpdateReader alloc] init];
    }
    
    return _intance;
}
    
- (id)init{
    self = [super init];
    if (self != nil){
        if (client == nil){
            client = [[LQClient alloc] initWithDelegate:self];
        }
        if(updateListeners == nil){
            updateListeners = [NSMutableArray array];
        }
        
        installedApps = [NSMutableDictionary dictionary];
            
    }
    return self;
}


-(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        NSRange range = [appKey rangeOfString:@"com.apple."];
        if(range.location == 0 && range.length>0)
            continue;
        
        NSDictionary* appDict = [dictionary objectForKey:appKey];
        NSString* appVersion = [appDict objectForKey:@"CFBundleShortVersionString"];
        NSRange dotrange;
        if(appVersion!=nil){
            dotrange= [appVersion rangeOfString:@"."];
        }
        if(appVersion == nil || dotrange.length==0)
            appVersion = [appDict objectForKey:@"CFBundleVersion"];
        NSString* appValue = [NSString stringWithFormat:@"%@,%@",appKey,appVersion];
        [desktopApps addObject:appValue];
        [installedApps setObject:appVersion forKey:appKey];
        
    }
    return desktopApps;
}

-(NSArray *)updateInstalledApps
{    
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir) 
    {
        NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *system = [cacheDict objectForKey: @"System"];
        NSMutableArray *installedApp = [NSMutableArray arrayWithArray:[self desktopAppsFromDictionary:system]];
        
        NSDictionary *user = [cacheDict objectForKey: @"User"]; 
        [installedApp addObjectsFromArray:[self desktopAppsFromDictionary:user]];
        
        return installedApp;
    }
    
    return nil;
}

- (NSString*)currentVersion:(NSString*)package{
//    BOOL isDir = NO;
//    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir) 
//    {
//        NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
//        NSDictionary *system = [cacheDict objectForKey: @"System"];
//        
//        NSDictionary* appDict = [system objectForKey:package];
//        if(appDict!=nil && appDict.count>0)
//            return [appDict objectForKey:@"CFBundleShortVersionString"];
//        
//        
//        NSDictionary *user = [cacheDict objectForKey: @"User"]; 
//        appDict = [user objectForKey:package];
//        if(appDict!=nil && appDict.count>0)
//            return [appDict objectForKey:@"CFBundleShortVersionString"];        
//    }
//    return nil;
    NSString *version = [installedApps objectForKey:package];
    if(version == nil)
        return 0;
    return [installedApps objectForKey:package];
}


- (void)loadApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    
    appsList = items;
}

- (void)loadNeedUpdateApps{
    //已经有了 不需要重新加载
    if(self.appsList!=nil){        
        for (id listener in updateListeners) {
            if([listener respondsToSelector:@selector(didAppUpdateListSuccess:)]){
                [listener didAppUpdateListSuccess:self.appsList];
            } 
        }
//        
//        if([self.delegate respondsToSelector:@selector(didAppUpdateListSuccess:)]) {
//            [self.delegate didAppUpdateListSuccess:self.appsList];
//        } 
        return;
    }

    //读取已经安装的apps 提交后台判断
    NSArray * array = [self updateInstalledApps];
    NSString* appsString = [array componentsJoinedByString:@","];
////    if(appsString == nil)
////        appsString = [LQConfig restoreAppList];
////    else 
////        [LQConfig saveAppList:appsString];
////
   
    if(appsString !=nil && appsString.length>0)
        [self.client loadAppUpdate:appsString];

    
}
- (void)reloadNeedUpdateApps{
    appsList = nil;
    [self loadNeedUpdateApps];
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_GETAPPUPDATE:
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadApps:[result objectForKey:@"apps"]];
                for (id listener in updateListeners) {
                    if([listener respondsToSelector:@selector(didAppUpdateListSuccess:)]){
                        [listener didAppUpdateListSuccess:self.appsList];
                    } 
                }


            }
            break;
        default:
            break;
    }
}

// when command fails
- (void)client:(LQClientBase*)client didFailExecution:(LQClientError*)error{
//    if([self.delegate respondsToSelector:@selector(didAppUpdateListFailed:)]) {
//    [self.delegate didAppUpdateListFailed:error];
//}
    
    for (id listener in updateListeners) {
        if([listener respondsToSelector:@selector(didAppUpdateListFailed:)]){
            [listener didAppUpdateListFailed:error];
        } 
    }
}

- (void)addListener:(id) listener{
    if([updateListeners containsObject:listener] == NO)
        [updateListeners addObject:listener];
}
- (void)removeListener:(id) listener{
    [updateListeners removeObject: listener];
}
@end
