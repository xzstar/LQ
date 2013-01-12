//
//  LQSearchViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
@class LQGameInfoListViewController;
@interface LQSearchViewController : LQViewController<UISearchDisplayDelegate, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>
{
    int currentRecommendIndex;
    NSMutableArray* searchHistoryItems;
    LQGameInfoListViewController* listController;
}
@property(unsafe_unretained) IBOutlet UISearchBar* searchBar;
@property(unsafe_unretained) IBOutlet UIView* searchResultTable;
@property(unsafe_unretained) IBOutlet UISearchDisplayController *searchBarController;
@property(unsafe_unretained) IBOutlet UIScrollView* scrollView;
@property(unsafe_unretained) IBOutlet UIView* searchHistoryView;
@property(unsafe_unretained) IBOutlet UITableView* searchHistoryTable;

- (void)onSwitchRecommendSection:(id)sender;
- (void)onDeleteSearchItem:(id)sender;
@end
