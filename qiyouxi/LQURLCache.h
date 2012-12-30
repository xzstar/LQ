//
//  WiGameURLCache.h
//  WiGame3.0PoC
//
//  Created by Wang Qing on 10-12-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQURLCache : NSURLCache {
@private
    NSMutableDictionary* _staticCacheInfo;
    
    NSUInteger _diskCacheUsed;
    NSTimer *_periodicMaintenanceTimer;
    NSOperation *_periodicMaintenanceOperation;
}

/**
 * 最小Cache时间间隔。即如果文件将在小于该时间间隔过期则不会Cache
 */
@property (nonatomic, assign) NSTimeInterval minCacheInterval;

/**
 * 默认Cache时间间隔
 */
@property (nonatomic, assign) NSTimeInterval defaultCacheInterval;

@end
