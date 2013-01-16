//
//  LQAppsListWrapperViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-16.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTablesController.h"

@interface LQAppsListWrapperViewController : LQTablesController{
NSString* requstUrl;
}

@property (nonatomic, strong) NSString* requestUrl;

@end
