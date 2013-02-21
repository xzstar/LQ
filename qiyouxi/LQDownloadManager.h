//
//  QYXDownloadManager.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYXData.h"

typedef enum _DOWNLOAD_STATUS{
    kQYXDSRunning,
    kQYXDSPaused,
    kQYXDSCompleted,
    kQYXDSFailed,
    kQYXDSNotFound,
    kQYXDSInstalling,
    kQYXDSInstalled,
} QYXDownloadStatus;

//#define kQYXDownloadStatusUpdateNotification @"kQYXDownloadStatusUpdateNotification"

@class QYXDownloadObject;
@class Reachability;
@interface LQDownloadManager : NSObject{
    Reachability* reachability;
}
@property (nonatomic, strong) NSMutableArray* downloadGames;
@property (nonatomic, strong) NSMutableArray* completedGames;
@property (nonatomic, strong) NSMutableArray* installedGames;
@property (nonatomic, strong) Reachability* reachability;

+ (LQDownloadManager*)sharedInstance;

- (void)loadIpaInstalled;

- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded;
- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded installPaths:(NSArray*) installPaths;
- (BOOL)isGameInstalled:(NSString*)identifier;

- (QYXDownloadObject*)objectWithGameId:(int)gameId;
- (void)pauseDownloadById:(int)gameId;
- (void)resumeDownloadById:(int)gameId;
- (QYXDownloadStatus)getStatusById:(int)gameId;
- (void)installGameBy:(int)gameId;
- (void)installGameBy:(int)gameId force:(BOOL)force;
- (void)removeDownloadBy:(int)gameId;
- (void)startGame:(NSString*)identifier;

- (void)commonAction:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded;
- (void)commonAction:(LQGameInfo*)gameInfo installAfterDownloaded:(BOOL)installAfterDownloaded installPaths:(NSArray*) installPaths;

- (void)restartGames;
@end


@interface QYXDownloadObject : NSObject{
    NSMutableData* _data;
    int lastDataLength;
    double lastTime;
}

@property (nonatomic, strong) LQGameInfo* gameInfo;
@property (nonatomic, assign) QYXDownloadStatus status;
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, assign) int dataLength;
@property (nonatomic, assign) int totalLength;
@property (nonatomic, strong) NSFileHandle* fileHandle;
@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, strong) NSArray* finalFilePaths;  //最后的安装路径 for ring & wallpaper
@property (nonatomic, assign) BOOL installAfterDownloaded;
- (void)pause;
- (void)resume;

- (NSString*)totalSizeDesc;
- (int)percent;
- (float)speed;

@end
