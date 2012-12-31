//
//  LQGameInfoListViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQGameInfoListViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>{
    NSInteger selectedRow;
    NSInteger selectedSection;
}
@property (unsafe_unretained) IBOutlet UITableView* historyView;

- (IBAction)onReload:(id)sender;
- (void) onGameDetail:(id)sender;
@end
