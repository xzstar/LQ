//
//  LQUpdateViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@interface InstalledAppReader

+(NSArray *)installedApp;
+(NSMutableDictionary *)appDescriptionFromDictionary:(NSDictionary *)dictionary;

@end

@interface LQUpdateViewController : LQViewController<UITabBarDelegate>

@end
