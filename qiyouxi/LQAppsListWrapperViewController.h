//
//  LQAppsListWrapperViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-16.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTablesController.h"
@class LQRequestListViewController;
@interface LQAppsListWrapperViewController : LQTablesController{
NSString* requstUrl;
}

@property (nonatomic, strong) NSString* requestUrl;
@property (strong) UIViewController* parent;

- (LQRequestListViewController*) getController:(int)page;

@end

@interface LQRingsListWrapperViewController : LQAppsListWrapperViewController

@end

@interface LQWallpaperListWrapperViewController : LQAppsListWrapperViewController

@end