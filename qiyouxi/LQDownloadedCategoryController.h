//
//  LQDownloadedCategoryController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQDownloadedCategoryController : UIViewController

@property (strong) UIViewController* parent;
@property (unsafe_unretained) IBOutlet UIButton* softButton;
@property (unsafe_unretained) IBOutlet UIButton* gameButton;
@property (unsafe_unretained) IBOutlet UIButton* ringButton;
@property (unsafe_unretained) IBOutlet UIButton* wallpaperButton;
@property (unsafe_unretained) IBOutlet UILabel* softLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameLabel;
@property (unsafe_unretained) IBOutlet UILabel* ringLabel;
@property (unsafe_unretained) IBOutlet UILabel* wallpaperLabel;

-(IBAction)onSoftClick:(id)sender;
-(IBAction)onGameClick:(id)sender;
-(IBAction)onRingClick:(id)sender;
-(IBAction)onWallpaerClick:(id)sender;

@end
