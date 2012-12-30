//
//  QYXDownloadManageViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQDownloadManageViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained) IBOutlet UITableView* applicaitonView;

- (IBAction)onBack:(id)sender;

@end
