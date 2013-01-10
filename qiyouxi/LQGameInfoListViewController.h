//
//  LQGameInfoListViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQCommonTableViewController.h"

#define NODE_ID_SOFT     @"rj"
#define NODE_ID_GAEM     @"yx"

#define ORDER_BY_NEWEST  @"new"
#define ORDER_BY_TUIJIAN @"tuijian"
#define ORDER_BY_WEEk    @"week"
#define ORDER_BY_MONTH   @"month"
#define ORDER_BY_TOTAL   @"total"

@interface LQGameInfoListViewController : LQCommonTableViewController{
    NSString* nodeId;
    NSString* orderBy;
}

@property (nonatomic,strong) NSString* nodeId;
@property (nonatomic,strong) NSString* orderBy;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               nodeId:(NSString*) aNodeId
              orderBy:(NSString*) aOrderBy;
@end
