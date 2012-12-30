//
//  QYXDownloadManager.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQDownloadManager.h"
#import "LQInstaller.h"

static LQDownloadManager* _intance = nil;

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

+ (LQDownloadManager*)sharedInstance{
    if (_intance == nil){
        _intance = [[LQDownloadManager alloc] init];
    }
    
    return _intance;
}

- (id)init{
    self = [super init];
    if (self != nil){
        NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.infoFilePath =  [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:@"downloads.plist"];

        self.downloadGames = [[NSMutableArray alloc] init];
        self.installedGames = [[NSMutableArray alloc] init];
        self.completedGames = [[NSMutableArray alloc] init];
        self.gameMap = [[NSMutableDictionary alloc] init];
        
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
                gameInfo.category = [dict objectForKey:@"category"];
                gameInfo.downloadUrl = [dict objectForKey:@"url"];
                gameInfo.package = [dict objectForKey:@"package"];
                
                obj.gameInfo = gameInfo;
                
                switch (status) {
                    case kQYXDSNotFound:
                        break;
                    case kQYXDSFailed:
                        [self.downloadGames addObject:obj];
                        break;
                    case kQYXDSCompleted:
                    case kQYXDSInstalling:
                        obj.status = kQYXDSCompleted;
                        [self.completedGames addObject:obj];
                        break;
                    case kQYXDSPaused:
                        [self.downloadGames addObject:obj];
                        break;
                    case kQYXDSRunning:
                        [self.downloadGames addObject:obj];
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
            [game setObject:obj.gameInfo.downloadUrl forKey:@"url"];
            [game setObject:obj.gameInfo.package forKey:@"package"];
            [game setObject:obj.gameInfo.category forKey:@"category"];
            
            [dict setObject:game forKey:@"game"];
            
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
            obj.status = kQYXDSInstalled;
            [self.installedGames addObject:obj];
            [removed addObject:obj];
        }
    }
    
    for (QYXDownloadObject* obj in removed){
        [self.completedGames removeObject:obj];
    }

    removed = [NSMutableArray array];
    for (QYXDownloadObject* obj in self.installedGames){
        if ([installed objectForKey:obj.gameInfo.package]==nil){
            obj.status = kQYXDSCompleted;
            [self.completedGames addObject:obj];
            [removed addObject:obj];
        }
    }
    
    for (QYXDownloadObject* obj in removed){
        [self.installedGames removeObject:obj];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}


- (QYXDownloadObject*)objectWithGameId:(int)gameId{
    return [self.gameMap objectForKey:[NSNumber numberWithInt:gameId]];
}

- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo suspended:(BOOL)suspended{
    QYXDownloadObject* object = [self objectWithGameId:gameInfo.gameId];
    
    if (object == nil){
        object = [[QYXDownloadObject alloc] init];
        object.gameInfo = gameInfo;
        object.status = kQYXDSPaused;
        [self.downloadGames addObject:object];
        
        [self.gameMap setObject:object forKey:[NSNumber numberWithInt:gameInfo.gameId]];
        
        if (!suspended){
            [self resumeDownload:object];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
        [self synchronize];
        
        [[NSString stringWithFormat:LocalString(@"info.download.add"), gameInfo.name] showToastAsInfo];
        
        return YES;
    }
    
    return NO;
}

- (void)pauseDownload:(QYXDownloadObject*)object{
    if (object.status == kQYXDSRunning){
        [object pause];
        [self synchronize];
    }
}

- (void)resumeDownload:(QYXDownloadObject*)object{
    if (object.status == kQYXDSPaused){
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


- (void)installGameBy:(int)gameId{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    if (obj.status == kQYXDSCompleted){
        obj.status = kQYXDSInstalling;
        [self performSelectorInBackground:@selector(installGame:) withObject:obj];
    }
}

- (void)removeDownloadBy:(int)gameId{
    QYXDownloadObject* obj = [self objectWithGameId:gameId];
    [obj pause];
    
    [[NSFileManager defaultManager] removeItemAtPath:obj.filePath error:NULL];
    
    [self.downloadGames removeObject:obj];
    [self.completedGames removeObject:obj];
    [self.installedGames removeObject:obj];
    
    [self.gameMap removeObjectForKey:[NSNumber numberWithInt:gameId]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.remove"), obj.gameInfo.name] showToastAsInfo];
    [self synchronize];
}

- (BOOL)isGameInstalled:(NSString*)identifier{
    return [self.ipaInstalled objectForKey:identifier] != nil;
}

- (void)updateDownloadObject:(QYXDownloadObject*)obj{
    id temp = obj;
    [self.downloadGames removeObject:obj];
    [self.completedGames addObject:temp];
    [self synchronize];
    obj.status = kQYXDSInstalling;
    [self performSelectorInBackground:@selector(installGame:) withObject:obj];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}

- (void)installGame:(QYXDownloadObject*)obj{
    @autoreleasepool {
        [[NSString stringWithFormat:LocalString(@"info.download.install"), obj.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];

        BOOL success = IPAResultSuccess == [[LQInstaller defaultInstaller] IPAInstall:obj.filePath];
        
        if (success){
            [self performSelectorOnMainThread:@selector(doneInstallGame:) withObject:obj waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(failInstallGame:) withObject:obj waitUntilDone:NO];
        }
    }
    
}

- (void)doneInstallGame:(QYXDownloadObject*)obj{
    obj.status = kQYXDSInstalled;
    id tmp = obj;
    [self.completedGames removeObject:obj];
    [self.installedGames addObject:tmp];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.install.success"), obj.gameInfo.name] showToastAsInfo];
    [self synchronize];
}

- (void)failInstallGame:(QYXDownloadObject*)obj{
    obj.status = kQYXDSCompleted;
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.install.fail"), obj.gameInfo.name] showToastAsInfo];
    [self synchronize];
}

- (void)startGame:(NSString*)identifier{
    [[LQInstaller defaultInstaller] launchApp:identifier];
}

@end

@implementation QYXDownloadObject
@synthesize gameInfo, status;
@synthesize connection;

@synthesize dataLength;
@synthesize totalLength;

@synthesize fileHandle;
@synthesize filePath;

- (void)setGameInfo:(LQGameInfo *)aGameInfo{
    gameInfo = aGameInfo;
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.filePath =  [[documentDirectories objectAtIndex:0] stringByAppendingPathComponent:[self.gameInfo.downloadUrl lastPathComponent]];

    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]){
        [[NSFileManager defaultManager] createFileAtPath:self.filePath 
                                                contents:[NSData data]
                                              attributes:nil];
    }
    
    self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    self.dataLength = [self.fileHandle seekToEndOfFile];
}

- (void)pause{
    @synchronized(self){
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    
    [self.connection cancel];
    self.connection = nil;
    self.status = kQYXDSPaused;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}

- (void)resume{
    @synchronized(self){
        self.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
        self.dataLength = [self.fileHandle seekToEndOfFile];
    }

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.gameInfo.downloadUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    self.status = kQYXDSRunning;
    
    if (self.dataLength > 0 && 
        self.totalLength > 0){
        [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithFormat:@"bytes=%d-%d", self.dataLength, self.totalLength], @"Range",
                                         nil]];
    }else{
        self.dataLength = 0;
        self.totalLength = 0;
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
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

- (int)percent{
    if (self.totalLength == 0){
        return 0;
    }else {
        return 100 * (float) self.dataLength/(float) self.totalLength;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* hr = (NSHTTPURLResponse*) response;
    if (self.totalLength == 0){
        self.totalLength = self.dataLength + [[hr.allHeaderFields objectForKey:@"Content-Length"] intValue];
        [[LQDownloadManager sharedInstance] synchronize];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
    @synchronized(self){
        [self.fileHandle writeData:data];
        self.dataLength += data.length;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.status = kQYXDSCompleted;
    self.connection = nil;
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    [[LQDownloadManager sharedInstance] updateDownloadObject:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.status = kQYXDSFailed;
    self.connection = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYXDownloadStatusUpdateNotification object:self];
    [[NSString stringWithFormat:LocalString(@"info.download.fail"), self.gameInfo.name] performSelectorOnMainThread:@selector(showToastAsInfo) withObject:nil waitUntilDone:NO];
}

@end


