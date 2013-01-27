//
//  LQUpdateViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQUtilities.h"

@interface InstalledAppReader:NSObject

+(NSArray *)installedApp;
+(void) getRings;
@end

@interface LQUpdateViewController : LQViewController<UITabBarDelegate,UITableViewDelegate, UITableViewDataSource,AppUpdateReaderDelegate>{
    int selectedSection;
    int selectedRow;
    NSMutableArray* appsList;
    NSMutableArray* updateAppsList;
    NSMutableArray* ignoreAppsList;

}

@property (nonatomic,unsafe_unretained) IBOutlet UITableView *tableView;
@property (nonatomic,unsafe_unretained) IBOutlet UIButton* openIgnoreView;
@property (nonatomic,unsafe_unretained) IBOutlet UIButton* updateAllButton;
@property (nonatomic,strong) IBOutlet UIView* ignoreView;
@property (nonatomic,unsafe_unretained) IBOutlet UITableView *ignoreTableView;
@property (nonatomic,unsafe_unretained) IBOutlet UIButton *closeIgnoreView;

@property (nonatomic,strong) NSMutableArray *appsList;
- (void) saveAppsList;
- (void)loadApps:(NSArray*) apps;
- (IBAction) onUpdateAll:(id)sender;
@end
