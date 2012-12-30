//
//  QYXSecondViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQHistoryViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained) IBOutlet UITableView* historyView;
@end