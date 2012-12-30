//
//  QYXViewControllerViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQClient.h"

@interface LQViewController : UIViewController<LQClientDelegate>{
@private    
    LQClient* _client;
    BOOL _dataLoaded;
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
