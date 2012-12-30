//
//  QYXLaunchViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LQViewController.h"

@interface LQLaunchViewController : LQViewController<LQImageReceiver>
@property (unsafe_unretained) IBOutlet UIImageView* launchImageView;
@end
