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

@interface InstalledAppReader:NSObject

+(NSArray *)installedApp;
+(NSMutableDictionary *)appDescriptionFromDictionary:(NSDictionary *)dictionary;

@end

@interface LQUpdateViewController : LQViewController<UITabBarDelegate,UITableViewDelegate, UITableViewDataSource>{
    int selectedSection;
    int selectedRow;
    NSMutableArray* appsList;
}

@property (nonatomic,unsafe_unretained) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *appsList;
- (void) saveAppsList;
- (void)loadApps:(NSArray*) apps;
@end
