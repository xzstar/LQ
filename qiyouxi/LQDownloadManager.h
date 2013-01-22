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

#define kQYXDownloadStatusUpdateNotification @"kQYXDownloadStatusUpdateNotification"


@interface LQDownloadManager : NSObject
@property (nonatomic, strong) NSMutableArray* downloadGames;
@property (nonatomic, strong) NSMutableArray* completedGames;
@property (nonatomic, strong) NSMutableArray* installedGames;

+ (LQDownloadManager*)sharedInstance;

- (void)loadIpaInstalled;

- (BOOL)addToDownloadQueue:(LQGameInfo*)gameInfo suspended:(BOOL)suspended;

- (BOOL)isGameInstalled:(NSString*)identifier;

- (void)pauseDownloadById:(int)gameId;
- (void)resumeDownloadById:(int)gameId;
- (QYXDownloadStatus)getStatusById:(int)gameId;
- (void)installGameBy:(int)gameId;
- (void)removeDownloadBy:(int)gameId;

- (void)startGame:(NSString*)identifier;

@end


@interface QYXDownloadObject : NSObject{
    NSMutableData* _data;
}

@property (nonatomic, strong) LQGameInfo* gameInfo;
@property (nonatomic, assign) QYXDownloadStatus status;
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, assign) int dataLength;
@property (nonatomic, assign) int totalLength;
@property (nonatomic, strong) NSFileHandle* fileHandle;
@property (nonatomic, strong) NSString* filePath;
- (void)pause;
- (void)resume;

- (NSString*)totalSizeDesc;
- (int)percent;

@end
