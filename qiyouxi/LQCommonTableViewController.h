//
//  LQCommonTableViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQClientBase.h"
#import "LQClient.h"
@interface LQCommonTableViewController : UITableViewController<LQClientDelegate>{
@private    
    LQClient* _client;
    BOOL _dataLoaded;
    
    NSInteger selectedRow;
    NSInteger selectedSection;
}

@property (nonatomic, strong, readonly) LQClient* client;

- (void)loadViews;
- (void)loadData;

- (void)startLoading;
- (void)endLoading;

- (void)handleNetworkError:(LQClientError*)error;
- (void)handleNoNetwork;
- (void)handleNetworkErrorHint;
- (void)handleNetworkOK;

- (IBAction)onBack:(id)sender;
@end
