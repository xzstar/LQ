//
//  LQUtilities.h
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQClient.h"
@interface LQUtilities : NSObject

+(BOOL) copyFile:(NSString*) srcPath destPath:(NSString*) destPath;
+(BOOL) removeFile:(NSString*) destPath ;
+(void) AlertWithMessage:(NSString *)message;
+(NSString *)documentsDirectoryPath;
+(NSString *)cacheDirectoryPath;
+(unsigned char *)getImageData:(UIImage*)image;
+(NSString*)createcpBitmap:(NSString*)imagePath savedcpbitmapName:(NSString*)savedcpbitmapName;
+(NSString*) stringWithUUID;
@end

@interface AppUpdateReader:NSObject <LQClientDelegate>{
    LQClient* client;
    NSArray* appsList;
    NSMutableArray* updateListeners;
}
@property (nonatomic,readonly) NSArray* appsList;
//@property (nonatomic,unsafe_unretained) id delegate;
@property (nonatomic,strong) LQClient* client;
+ (AppUpdateReader*)sharedInstance;
-(NSArray *)installedApp;
//-(NSMutableDictionary *)appDescriptionFromDictionary:(NSDictionary *)dictionary;
- (void)loadApps:(NSArray*) apps;
- (void)loadNeedUpdateApps;
- (void)reloadNeedUpdateApps;
- (void)addListener:(id) listener;
- (void)removeListener:(id) listener;
@end

@protocol AppUpdateReaderDelegate

@optional
//成功获得appList
-(void) didAppUpdateListSuccess:(NSArray*) appsList;
//获得appList失败
-(void) didAppUpdateListFailed:(LQClientError*)error;

@end
