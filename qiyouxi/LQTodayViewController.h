//
//  QYXFirstViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQRecommendButton.h"
#import "LQAdvertiseView.h"

@interface LQTodayViewController : LQViewController{
    NSMutableArray* sortedButtons;
}

@property (unsafe_unretained) IBOutlet UIScrollView* scrollView;

@property (unsafe_unretained) IBOutlet LQAdvertiseView* advView;

@property (unsafe_unretained) IBOutlet UIButton* announceButton;

@property (unsafe_unretained) IBOutlet UIView* boardView;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton1;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton2;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton3;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton4;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton5;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton6;
@property (unsafe_unretained) IBOutlet LQRecommendButton* gameButton7;

@property (unsafe_unretained) IBOutlet UIView* dateView;
@property (unsafe_unretained) IBOutlet UILabel* dayLabel;
@property (unsafe_unretained) IBOutlet UILabel* weekLabel;
@property (unsafe_unretained) IBOutlet UILabel* monthLabel;

@property (unsafe_unretained) IBOutlet UIView* bottomView;


- (IBAction)onReload:(id)sender;

@end
