//
//  WiImageLoader.h
//  WiYunSample
//
//  Created by Wang Qing on 10-5-10.
//  Copyright 2010 WiYun Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWiImageLoadedNotification @"kWiImageLoadedNotification"

@protocol LQImageReceiver
- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl;
@end


@interface LQImageLoader : NSObject {
    NSMutableDictionary* _cachedSystemImages;
    NSMutableDictionary* _cachedImages;
    NSMutableArray* _requestsQueue;
    BOOL _imageThreadRunning;
}

+(LQImageLoader*)sharedInstance;

- (UIImage*)loadImage:(NSString*)imageUrl context:(id)context;
- (void)clearCacheImages;

+ (UIImage*)loadImageByName:(NSString*)imageName;
+ (UIImage*)loadImage:(NSString*)imageUrl context:(id)context;

+ (void)clearSystemImages;
+ (void)clearCacheImages;

@end
