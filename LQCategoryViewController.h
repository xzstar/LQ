//
//  QYXCategoryViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "EGORefreshTableFooterView.h"

@interface LQCategoryViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>
@property (unsafe_unretained) IBOutlet UITableView* categoriesView;
@property (unsafe_unretained) IBOutlet UITableView* gamesView;

@end
