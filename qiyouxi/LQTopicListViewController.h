//
//  LQTopicListViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-15.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTablesController.h"

@interface LQTopicListViewController : LQTablesController{
    NSString* requstUrl;
}

@property (nonatomic, strong) NSString* requestUrl;

@end
