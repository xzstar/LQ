//
//  LQDownloadViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQDownloadViewController  : LQViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained) IBOutlet UITableView* applicaitonView;

//- (IBAction)onBack:(id)sender;
@end
