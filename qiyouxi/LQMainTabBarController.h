//
//  QYXMainTabBarController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQUtilities.h"

@interface LQMainTabBarController : UITabBarController<AppUpdateReaderDelegate>{
    UIView* moreBgView;
    NSMutableArray* tabItems;

}

@property (nonatomic,strong) NSMutableArray* tabItems;
- (IBAction)onManage:(id)sender;
- (IBAction)onFeedback:(id)sender;

@end
