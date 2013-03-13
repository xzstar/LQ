//
//  QYXDownloadManager.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQDownloadManager.h"
#import "LQInstaller.h"
#import "LQUtilities.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
//#import "ASINetworkQueue.h"
static LQDownloadManager* _intance = nil;

NSString* const kNotificationStatusChanged    = @"NotificationStatusChanged";
NSString* const kNotificationWallpaperRefresh    = @"NotificationWallpaperRefresh";

//NSString* const kNotificationInstalledComplete    = @"NotificationInstalledComplete";

@interface LQDownloadManager()
@property (nonatomic, strong) NSDictionary* ipaInstalled;
@property (nonatomic, strong) NSMutableDictionary* gameMap;
@property (nonatomic, strong) NSString* infoFilePath;

- (void)updateDownloadObject:(QYXDownloadObject*)obj;
- (void)synchronize;

@end

@implementation LQDownloadManager
@synthesize downloadGames;
@synthesize installedGames;
@synthesize completedGames;

@synthesize gameMap;

@synthesize ipaInstalled;
@synthesize infoFilePath;
//@synthesize reachability;
//@synthesize downloadingQueue;

+ (LQDownloadManager*)sharedInstance{
    if (_intance == nil){
        _intance = [[LQDownloadManager alloc] init];
    }
    
    return _intance;
}

- (id)init{
    self = [super init];
    if (self != nil){
//        NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        self.infoFilePath =  [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:@"downloads.plist"];
        
//        reachability = [[Reachability alloc]init];
//        downloadingQueue = [[ASINetworkQueue alloc] init];
//        downloadingQueue.maxConcurrentOperationCount = 2;
//        [downloadingQueue setShouldCancelAllRequestsOnFailure:NO];
        self.infoFilePath =  [[LQUtilities documentsDirectoryPath]stringByAppendingPathComponent:@"downloads.plist"];
        self.downloadGames = [[NSMutableArray alloc] init];
        self.installedGames = [[NSMutableArray alloc] init];
        self.completedGames = [[NSMutableArray alloc] init];
        self.gameMap = [[NSMutableDictionary alloc] init];
        
        NSMutableArray* restartGames = [[NSMutableArray alloc] init];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.infoFilePath]){
            NSArray* items = [NSArray arrayWithContentsOfFile:self.infoFilePath];
            for (NSDictionary* item in items){
                QYXDownloadObject* obj = [[QYXDownloadObject alloc] init];
                int status = [[item objectForKey:@"status"] intValue];
                obj.status = status;
                obj.totalLength = [[item objectForKey:@"size"] intValue];
                
                LQGameInfo* gameInfo = [[LQGameInfo alloc] init];
                
                NSDictionary* dict = [item objectForKey:@"game"];
                
                gameInfo.gameId = [[dict objectForKey:@"id"] intValue];
                gameInfo.icon = [dict objectForKey:@"icon"];
                gameInfo.name = [dict objectForKey:@"name"];
                gameInfo.tags = [dict objectForKey:@"category"];
                gameInfo.downloadUrl = [dict objectForKey:@"downloadUri"];
                gameInfo.package = [dict objectForKey:@"package"];
                gameInfo.fileType = [dict objectForKey:@"fileType"]; 
                if([dict objectForKey:@"version"]!=nil)
                    gameInfo.versionCode = [dict objectForKey:@"version"];
                else {
                    gameInfo.versionCode = @"1.0";
                }
                
                obj.gameInfo = gameInfo;
                obj.finalFilePaths = [dict objectForKey:@"finalFilePaths"];
                switch (status) {
                    case kQYXDSNotFound:
                        break;
                    case kQYXDSFailed:
                        [self.downloadGames addObject:obj];
                        break;
                    case kQYXDSCompleted:
                    case kQYXDSInstalling:
                        [self.completedGames addObject:obj];
                        obj.status = kQYXDSCompleted;
                        break;
                    case kQYXDSPaused:
                        [self.downloadGames addObject:obj];
                        break;
                    case kQYXDSRunning:
                        [self.downloadGames addObject:obj];
                        [restartGames addObject:obj];
                        obj.status = kQYXDSPaused;
                        break;
                    case kQYXDSInstalled:
                        [self.installedGames addObject:obj];
                        break;
                    default:
                        break;
                }
                
                [self.gameMap setObject:obj forKey:[NSNumber numberWithInt:obj.gameInfo.gameId]];
            }
        }
        for(QYXDownloadObject* obj in restartGames){
            [self resumeDownload:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:obj];
        }
        
        
    }
    
  
    
    return self;
}

- (void)synchronize{
    @synchronized(self){
        NSMutableArray* items = [NSMutableArray array];
        for (QYXDownloadObject* obj in [self.gameMap allValues]){
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:obj.status] forKey:@"status"];
            [dict setObject:[NSNumber numberWithInt:obj.totalLength] forKey:@"size"];
            NSMutableDictionary* game = [NSMutableDictionary dictionary];
            [game setObject:[NSNumber numberWithInt:obj.gameInfo.gameId] forKey:@"id"];
            [game setObject:obj.gameInfo.name forKey:@"name"];
            [game setObject:obj.gameInfo.icon forKey:@"icon"];
            [game setObject:obj.gameInfo.downloadUrl forKey:@"downloadUri"];
            [game setObject:obj.gameInfo.package forKey:@"package"];
            [game setObject:obj.gameInfo.tags forKey:@"category"];
            if(obj.gameInfo.versionCode != nil)
                [game setObject:obj.gameInfo.versionCode forKey:@"version"];
            else {
                [game setObject:@"1.0" forKey:@"version"];
            }
            if(obj.gameInfo.fileType!=nil)
            [game setObject:obj.gameInfo.fileType forKey:@"fileType"];
            else {
                [game setObject:@"soft" forKey:@"fileType"];
            }
            [dict setObject:game forKey:@"game"];
            if(obj.finalFilePaths!=nil)
                [dict setObject:obj.finalFilePaths forKey:@"finalFilePaths"];
            
            [items addObject:dict];
        }
        
        [items writeToFile:self.infoFilePath atomically:YES];
    }
}

- (void)loadIpaInstalled{
    [self performSelectorInBackground:@selector(loadAppThread) withObject:nil];
}

- (void)loadAppThread{
    NSMutableArray* results = [NSMutableArray array];
    [[LQInstaller defaultInstaller] IPABrowse:results];
    [self performSelectorOnMainThread:@selector(onDoneLoad:) withObject:results waitUntilDone:NO];
}

- (void)onDoneLoad:(NSArray*)results{
    NSMutableDictionary* installed = [NSMutableDictionary dictionary];
    for (NSDictionary* plist in results){
        [installed setObject:plist forKey:[plist objectForKey:@"CFBundleIdentifier"]];
    }
    
    self.ipaInstalled = installed;
    
//    NSLog(@"ipaInstalled = %@", self.ipaInstalled);
    
    NSMutableArray* removed = [NSMutableArray array];
    for (QYXDownloadObject* obj in self.completedGames){
        if ([installed objectForKey:obj.gameInfo.package]!=nil){
            [self.installedGames addObject:obj];
            [removed addObject:obj];
            obj.status = kQYXDSInstalled;
        }
    }
    
    for (QYXDownloadObject* obj in removed){
        [self.completedGames removeObject:obj];
    }

    removed = [NSMutableArray array];
    for (QYXDownloadObject* obj in self.installedGames){
        if ([installed objectForKey:obj.gameInfo.package]==nil){
            [self.completedGames addObject:obj];
            [removed addObject:obj];
            obj.status = kQYXDSCompleted;

        }
    }
    
    for (QYXDownloadObject* obj in removed){
        [self.installedGames removeObject:obj];
    }

//    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}


- (QYXDownloadObject*)objectWithGameId:(int)gameId{
    return [self.gameMap objectForKey:[NSNumber numberWithInt:gameId]];
}

- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded installPaths:(NSArray*) installPaths{
    QYXDownloadObject* object = [self objectWithGameId:gameInfo.gameId];
    
    if (object == nil){
        object = [[QYXDownloadObject alloc] init];
        object.gameInfo = gameInfo;
        object.status = kQYXDSPaused;
        object.installAfterDownloaded = installAfterDownloaded;
        object.finalFilePaths = installPaths;
        [self.downloadGames addObject:object];
        
        [self.gameMap setObject:object forKey:[NSNumber numberWithInt:gameInfo.gameId]];
        [self resumeDownload:object];
        //        if (!suspended){
        //            [self resumeDownload:object];
        //        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
        //[self synchronize];
        
        [[NSString stringWithFormat:LocalString(@"info.download.add"), gameInfo.name] showToastAsInfo];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded{
    return [self addToDownloadQueue:gameInfo
             installAfterDownloaded:installAfterDownloaded 
                       installPaths:nil];
//    QYXDownloadObject* object = [self objectWithGameId:gameInfo.gameId];
//    
//    if (object == nil){
//        object = [[QYXDownloadObject alloc] init];
//        object.gameInfo = gameInfo;
//        object.status = kQYXDSPaused;
//        object.installAfterDownloaded = installAfterDownloaded;
//        [self.downloadGames addObject:object];
//        
//        [self.gameMap setObject:object forKey:[NSNumber numberWithInt:gameInfo.gameId]];
//        
////        if (!suspended){
////            [self resumeDownload:object];
////        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
//        [self synchronize];
//        
//        [[NSString stringWithFormat:LocalString(@"info.download.add"), gameInfo.name] showToastAsInfo];
//        
//        return YES;
//    }
//    
//    return NO;
}

- (void)pauseDownload:(QYXDownloadObject*)object{
    if (object.status == kQYXDSRunning){
        [object pause];
        [self synchronize];
    }
}

- (void)resumeDownload:(QYXDownloadObject*)object{
    if (object.status == kQYXDSPaused || object.status == kQYXDSFailed){
        [object resume];
        [self synchronize];
    }
}

- (void)pauseDownloadById:(int)gameId{
    [self pauseDownload:[self objectWithGameId:gameId]];
}

- (void)resumeDownloadById:(int)gameId{
    [self resumeDownload:[self objectWithGameId:gameId]];
}

- (QYXDownloadStatus)getStatusById:(int)gameId{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    if (obj == nil){
        return kQYXDSNotFound;
    }
    
    return obj.status;
}

- (void)installGameBy:(int)gameId force:(BOOL)force{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    obj.installAfterDownloaded = force;
    [self installGameBy:gameId];
}

- (void)installGameBy:(int)gameId{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    
    // 下载完成 或者已经安装要重装的
    if ((obj.status == kQYXDSCompleted  && obj.installAfterDownloaded == YES)|| obj.status == kQYXDSInstalled){
        
        //软件和游戏变更状态，铃声壁纸保持completed
        if([obj.gameInfo.fileType isEqualToString:@"soft"] ||
           [obj.gameInfo.fileType isEqualToString:@"game"] )
            obj.status = kQYXDSInstalling;
        
        [self performSelectorInBackground:@selector(installGame:) withObject:obj];
    }
}

- (void)removeDownloadBy:(int)gameId silentRemove:(BOOL) silentRemove{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    [obj pause];
    
    [[NSFileManager defaultManager] removeItemAtPath:obj.filePath error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", obj.filePath,@".download"] error:NULL];
    
    NSString* toastMsg = LocalString(@"info.download.delete");
    if([self.downloadGames containsObject:obj] == YES){
        toastMsg = LocalString(@"info.download.remove");
    }
    
    
    [self.downloadGames removeObject:obj];
    [self.completedGames removeObject:obj];
    [self.installedGames removeObject:obj];
    
    [self.gameMap removeObjectForKey:[NSNumber numberWithInt:gameId]];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:obj];
    if(silentRemove == NO)
        [[NSString stringWithFormat:toastMsg, obj.gameInfo.name] showToastAsInfo];
    [self synchronize];
}


- (void)removeDownloadBy:(int)gameId{
    [self removeDownloadBy:gameId silentRemove:NO];
}

- (void)removeDownloadWallpaperBy:(NSArray*)gameIds{
    
    for (NSNumber* number in gameIds) {
        int gameId = [number intValue];
        QYXDownloadObject* obj = [self objectWithGameId:gameId];
        //[obj pause];
        
        [[NSFileManager defaultManager] removeItemAtPath:obj.filePath error:NULL];
                
        [self.downloadGames removeObject:obj];
        [self.completedGames removeObject:obj];
        [self.installedGames removeObject:obj];
        
        [self.gameMap removeObjectForKey:[NSNumber numberWithInt:gameId]];
 
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:obj];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWallpaperRefresh object:self];

    [self synchronize];
}
- (BOOL)isGameInstalled:(NSString*)identifier{
    NSDictionary* dict = [self.ipaInstalled objectForKey:identifier];
    NSString* version = [dict objectForKey:@"CFBundleShortVersionString"];
    if(dict!=nil)
        NSLog(@"identifier %@ %@",identifier,version);
    BOOL rtn = dict!=nil;
    return rtn;
    //return [self.ipaInstalled objectForKey:identifier] != nil;
}

- (void)updateDownloadObject:(QYXDownloadObject*)obj{
    id temp = obj;
    [self.downloadGames removeObject:obj];
    [self.completedGames addObject:temp];
    [self synchronize];
    
//    NSLog(@"donwload completed src %@:%@",obj.filePath,obj.gameInfo.name);

//    obj.status = kQYXDSInstalling;
//    [self performSelectorInBackground:@selector(installGame:) withObject:obj];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [self installGameBy:obj.gameInfo.gameId];
}


- (void)installGame:(QYXDownloadObject*)obj{
    @autoreleasepool {
        
        if([obj.gameInfo.package isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]]){
            
            BOOL success = [[LQInstaller defaultInstaller] selfUpdateInstall:obj.filePath dest:@"/var/root/Media/Cydia/AutoInstall/"];
            
//            if (result == NO) {
//                [self performSelectorOnMainThread:@selector(failInstallGame:) withObject:obj waitUntilDone:NO];
//                return ;
//            }

            [LQUtilities AlertWithMessage:LocalString(@"info.install.rebootupgrade")];
            if (success){
                [self performSelectorOnMainThread:@selector(doneInstallGame:) withObject:obj waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(failInstallGame:) withObject:obj waitUntilDone:NO];
            }
            return;
        }
        
        
        
        [[NSString stringWithFormat:LocalString(@"info.download.install"), obj.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];

        if([obj.gameInfo.fileType isEqualToString:@"soft"] ||
           [obj.gameInfo.fileType isEqualToString:@"game"] ){
            BOOL success = IPAResultSuccess == [[LQInstaller defaultInstaller] IPAInstall:obj.filePath];
            
            if (success){
                [self performSelectorOnMainThread:@selector(doneInstallGame:) withObject:obj waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(failInstallGame:) withObject:obj waitUntilDone:NO];
            }
        }
        else if([obj.gameInfo.fileType isEqualToString:@"wallpaper"]){
            BOOL success;
            for(NSString* finalPath in obj.finalFilePaths){
                [[LQInstaller defaultInstaller] removeWallpaper:finalPath];
                success =[[LQInstaller defaultInstaller] wallPaperInstall:obj.filePath dest:finalPath];
                if(success == NO)
                    break;
            }
            
            if (success){
                [self performSelectorOnMainThread:@selector(doneInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(failInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }

        }
        else if([obj.gameInfo.fileType isEqualToString:@"tel_ring"]){
            BOOL success;

            for(NSString* finalPath in obj.finalFilePaths){
                success =[[LQInstaller defaultInstaller] ringToneInstall:obj.gameInfo.name
                                                            src:obj.filePath 
                                                           dest:finalPath];
            }
            
            if (success){
                [self performSelectorOnMainThread:@selector(doneInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(failInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }

        }
        else {
            BOOL success ;
            for(NSString* finalPath in obj.finalFilePaths){
                success =[[LQInstaller defaultInstaller] smsToneInstall:obj.filePath dest:finalPath];
            }
            
            if (success){
                [self performSelectorOnMainThread:@selector(doneInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(failInstallWallpaperOrRing:) withObject:obj waitUntilDone:NO];
            }


        }
    }                      
    
}

- (void)doneInstallWallpaperOrRing:(QYXDownloadObject*)obj{
    
    [[NSString stringWithFormat:LocalString(@"info.download.install.success"), obj.gameInfo.name] showToastAsInfo];
    [LQUtilities AlertWithMessage:LocalString(@"info.download.install.needLogoff")];
}
- (void)failInstallWallpaperOrRing:(QYXDownloadObject*)obj{
    [[NSString stringWithFormat:LocalString(@"info.download.install.fail"), obj.gameInfo.name] showToastAsInfo];
}
- (void)doneInstallGame:(QYXDownloadObject*)obj{
    id tmp = obj;
    [self.completedGames removeObject:obj];
    
    if([self.installedGames containsObject:tmp] == NO)
        [self.installedGames addObject:tmp];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.install.success"), obj.gameInfo.name] showToastAsInfo];
    [[AppUpdateReader sharedInstance] updateInstalledApps]; 
    
    obj.status = kQYXDSInstalled;
    [self synchronize];
}

- (void)failInstallGame:(QYXDownloadObject*)obj{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.install.fail"), obj.gameInfo.name] showToastAsInfo];
    obj.status = kQYXDSCompleted;
    [self synchronize];
}

- (void)startGame:(NSString*)identifier{
    [[LQInstaller defaultInstaller] launchApp:identifier];
}

- (void)commonAction:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded{
    [self commonAction:gameInfo installAfterDownloaded:installAfterDownloaded installPaths:nil];
}

- (void)commonAction:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded installPaths:(NSArray*) installPaths{
    QYXDownloadStatus status = [self getStatusById:gameInfo.gameId];
    NSString* info;
    
    QYXDownloadObject* obj = [self objectWithGameId:gameInfo.gameId];
    if(obj!=nil){
        obj.installAfterDownloaded = installAfterDownloaded;
        if(installPaths !=nil)
            obj.finalFilePaths = installPaths;
    }
    
    switch (status) {
        case kQYXDSFailed:
        case kQYXDSPaused:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            [[LQDownloadManager sharedInstance] resumeDownload:obj];
            break;
        case kQYXDSCompleted:
            info = [NSString stringWithFormat:LocalString(@"info.download.downloaded"),gameInfo.name];
            [info showToastAsInfo];
            [self installGameBy:gameInfo.gameId];
            break;
        case kQYXDSInstalling:
            info = [NSString stringWithFormat:LocalString(@"info.download.install"),gameInfo.name];
            [info showToastAsInfo];
            break;
        case kQYXDSRunning:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            break;
        case kQYXDSNotFound:
            if(gameInfo!=nil)
                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:installAfterDownloaded installPaths:installPaths];
            break;
        case kQYXDSInstalled:
            info = [NSString stringWithFormat:LocalString(@"info.download.install.success"),gameInfo.name];
            [info showToastAsInfo];
            break;
        default:
            break;
    }
    
}
- (void)restartGames{
    for (QYXDownloadObject* obj in [self.gameMap allValues]){
        if(obj.status == kQYXDSFailed)
            [self resumeDownload:obj];
    }
}
@end

@implementation QYXDownloadObject
@synthesize gameInfo, status;
@synthesize connection;

@synthesize dataLength;
@synthesize totalLength;

@synthesize fileHandle;
@synthesize tempfileHandle;
@synthesize filePath;
@synthesize finalFilePaths; 
@synthesize installAfterDownloaded;

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    request = nil;
}
- (void)setGameInfo:(LQGameInfo *)aGameInfo{
    gameInfo = aGameInfo;
//    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    if([aGameInfo.fileType isEqualToString:@"soft"] ||
       [aGameInfo.fileType isEqualToString:@"game"])
        //        self.filePath =  [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",aGameInfo.package,@"ipa"]];
        self.filePath =  [[LQUtilities documentsDirectoryPath]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",aGameInfo.package,@"ipa"]];
    
    else
        //    self.filePath =  [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:[self.gameInfo.downloadUrl lastPathComponent]];
        self.filePath =  [[LQUtilities documentsDirectoryPath]
                          stringByAppendingPathComponent:[self.gameInfo.downloadUrl lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]){
        [[NSFileManager defaultManager] createFileAtPath:self.filePath 
                                                contents:[NSData data]
                                              attributes:nil];
    }
    
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    self.tempfileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[NSString stringWithFormat:@"%@%@",self.filePath,@".download"]];
    self.dataLength = [self.fileHandle seekToEndOfFile];
    if(self.dataLength ==0)
        self.dataLength = [self.tempfileHandle seekToEndOfFile];
    
    if(self.totalLength!=0)
        percent = (double)self.dataLength/(double)self.totalLength;
}

- (void)setStatus:(QYXDownloadStatus) aStatus{
    if(aStatus != status)
    {
        status =aStatus;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];
    }
}
- (void)pause{
    @synchronized(self){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
        [self.tempfileHandle closeFile];
        self.tempfileHandle = nil;
    }
    
    //[self.connection cancel];
    //self.connection = nil;
    [request clearDelegatesAndCancel];
    request = nil;
    self.status = kQYXDSPaused;
//    NSLog(@"operations: %d",[LQDownloadManager sharedInstance].downloadingQueue.operations.count);
//    
//    NSArray *queueArray = [LQDownloadManager sharedInstance].downloadingQueue.operations;
//    for (ASIHTTPRequest *request in queueArray) {
//        NSString *objid = [request.userInfo objectForKey:@"path"];
//        NSLog(@"%@",objid);
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}

- (void)resume{
    @synchronized(self){
        self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
        self.tempfileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[NSString stringWithFormat:@"%@%@",self.filePath,@".download"]];

        self.dataLength = [self.tempfileHandle seekToEndOfFile];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict  setObject:self.filePath forKey:@"path"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:gameInfo.downloadUrl]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    //request.numberOfTimesToRetryOnTimeout = 3;
    [request setShowAccurateProgress:YES];
    [request setDownloadDestinationPath:self.filePath];
    [request setTemporaryFileDownloadPath:
     [NSString stringWithFormat:@"%@%@",self.filePath,@".download"]];
    [request setAllowResumeForFileDownloads:YES];
    request.userInfo = dict;

//    [[LQDownloadManager sharedInstance].downloadingQueue setShowAccurateProgress:YES];
//    [[LQDownloadManager sharedInstance].downloadingQueue addOperation:request];

    self.status = kQYXDSRunning;
    request.shouldContinueWhenAppEntersBackground=YES; 
    [request startAsynchronous];
//    if([[LQDownloadManager sharedInstance].downloadingQueue isSuspended] == YES){
//        [[LQDownloadManager sharedInstance].downloadingQueue go];
//    }
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.gameInfo.downloadUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
//    self.status = kQYXDSRunning;
//    
//    if (self.dataLength > 0 && 
//        self.totalLength > 0){
//        [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSString stringWithFormat:@"bytes=%d-%d", self.dataLength, self.totalLength], @"Range",
//                                         nil]];
//    }else{
//        self.dataLength = 0;
//        self.totalLength = 0;
//    }
//    
//    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}


- (NSString*)totalSizeDesc{
    if (self.totalLength == 0){
        return @"0";
    }else if (self.totalLength < 1000){
        return [NSString stringWithFormat:@"%dB", self.totalLength];
    }else if (self.totalLength < 1000000){
        return [NSString stringWithFormat:@"%.1fKB", (float)self.totalLength/1000];
    }else{
        return [NSString stringWithFormat:@"%.1fMB", (float)self.totalLength/1000000];
    }
    
    return @"";
}

- (double)percent{
    return 100*percent;
}

- (float)speed{
    NSDate *date = [NSDate date];
    double nowTime = [date timeIntervalSince1970];
    if(status != kQYXDSRunning)
        return 0;
    
    if (lastTime == 0 || oldpercent ==0) {
        oldpercent = percent;
        lastTime = nowTime;
        return 0;
    }
    else {
        
        if(nowTime>lastTime && percent>oldpercent){
            NSLog(@"%f %f %d %f",percent,oldpercent,self.totalLength,(nowTime-lastTime)*1000);
            int value = (float)(percent-oldpercent)*self.totalLength/(float)((nowTime-lastTime)*1000);
            oldpercent = percent;
            lastTime = nowTime;
            return value;
        }
        else {
            oldpercent = percent;
            lastTime = nowTime;
            return 0;
        }
        
    }
    
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSHTTPURLResponse* hr = (NSHTTPURLResponse*) response;
//    if (self.totalLength == 0){
//        self.totalLength = self.dataLength + [[hr.allHeaderFields objectForKey:@"Content-Length"] intValue];
//        [[LQDownloadManager sharedInstance] synchronize];
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    [_data appendData:data];
//    @synchronized(self){
//        [self.fileHandle writeData:data];
//        self.dataLength += data.length;
//    }
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    self.connection = nil;
//    [self.fileHandle closeFile];
//    self.fileHandle = nil;
//    //self.status = kQYXDSCompleted;
//    if(self.totalLength == self.dataLength)
//    {
//        self.status = kQYXDSCompleted;
//    }
//    else {
//        self.status = kQYXDSFailed;
//    }
//    [[LQDownloadManager sharedInstance] updateDownloadObject:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
//
////    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];
//
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    self.connection = nil;
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
//    
//    if([[LQDownloadManager sharedInstance].reachability isReachable] == NO){
//        self.status = kQYXDSPaused;
//    }
//    else{    
//        [[NSString stringWithFormat:LocalString(@"info.download.fail"), self.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];
//        self.status = kQYXDSFailed;
//    }
//
//}


- (void)setProgress:(float)newProgress{
    //NSLog(@"percent %f",newProgress);
    //oldpercent = percent;
    percent = newProgress;
}

//- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
//    if(self.totalLength == 0)
//        self.totalLength = request.contentLength;
//    self.dataLength += bytes;
//    
//    NSLog(@"%@ %d %d",request.url, self.totalLength,self.dataLength);
//
//}

//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//    //[_data appendData:data];
//    @synchronized(self){
//        //[self.fileHandle writeData:data];
//        //self.dataLength += data.length;
//    }
//}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    @synchronized(self){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
        [self.tempfileHandle closeFile];
        self.tempfileHandle =nil;
    }
    self.status = kQYXDSCompleted;
//    if(self.totalLength == self.dataLength)
//    {
//        self.status = kQYXDSCompleted;
//    }
//    else {
//        self.status = kQYXDSFailed;
//    }
    NSString* info = [NSString stringWithFormat:LocalString(@"info.download.downloaded"),gameInfo.name];
    [info showToastAsInfo];
    [[LQDownloadManager sharedInstance] updateDownloadObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    @synchronized(self){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
        [self.tempfileHandle closeFile];
        self.tempfileHandle =nil;
    }

    //NSError *error = [request error];
    //NSLog(@"%d %@",error.code, error.userInfo);
    
    if(self.status == kQYXDSPaused)
        return;
    
   // self.connection = nil;
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    BOOL reachable = [[Reachability reachabilityForInternetConnection] isReachable];
    
    if(reachable == NO){
        [[NSString stringWithFormat:LocalString(@"info.download.nonetwork"), self.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];    }
    else{
        //NSLog(@"%d %@",error.code, error.userInfo);
        [[NSString stringWithFormat:LocalString(@"info.download.fail"), self.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];
    }
    self.status = kQYXDSFailed;

}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSMutableDictionary *)newResponseHeaders{
    if (self.totalLength == 0){
        NSLog(@"get HeadLength");
        self.totalLength = self.dataLength + [[newResponseHeaders objectForKey:@"Content-Length"] intValue];
        [[LQDownloadManager sharedInstance] synchronize];
    }
}

- (void)request:(ASIHTTPRequest *)orig willRedirectToURL:(NSURL *)newURL {
    [request setDownloadDestinationPath:self.filePath];
    [request setTemporaryFileDownloadPath:
     [NSString stringWithFormat:@"%@%@",self.filePath,@".download"]];
    [request redirectToURL:newURL];
}

@end


