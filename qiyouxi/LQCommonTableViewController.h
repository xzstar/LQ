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
#define NODE_ID_SOFT     @"rj"
#define NODE_ID_GAEM     @"yx"

#define ORDER_BY_NEWEST  @"new"
#define ORDER_BY_TUIJIAN @"tuijian"
#define ORDER_BY_WEEK    @"week"
#define ORDER_BY_MONTH   @"month"
#define ORDER_BY_TOTAL   @"total"
@interface LQCommonTableViewController : UITableViewController<LQClientDelegate>{
@private    
    LQClient* _client;
    BOOL _dataLoaded;
    
    NSInteger selectedRow;
    NSInteger selectedSection;
    NSString* nodeId;
    NSString* orderBy;
    NSString* listOperator;
    NSString* keywords;
    NSMutableArray* appsList;
    UIViewController* parent;

}

@property (nonatomic,strong) NSString* listOperator;
@property (nonatomic,strong) NSString* keywords;
@property (nonatomic,strong) NSString* nodeId;
@property (nonatomic,strong) NSString* orderBy;
@property (nonatomic, strong, readonly) LQClient* client;
@property (nonatomic, strong) NSMutableArray* appsList;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) NSInteger selectedSection;
@property (nonatomic, strong) UIViewController* parent;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         listOperator:(NSString *)aListOperator
               nodeId:(NSString *)aNodeId
              orderBy:(NSString *)aOrderBy;

- (void)loadViews;
- (void)loadData;
- (void)loadApps:(NSArray*) apps;
- (void)startLoading;
- (void)endLoading;

- (void)handleNetworkError:(LQClientError*)error;
- (void)handleNoNetwork;
- (void)handleNetworkErrorHint;
- (void)handleNetworkOK;

//- (IBAction)onBack:(id)sender;
- (void) onGameDetail:(id)sender;
- (void) onGameDownload:(id)sender;

@end
