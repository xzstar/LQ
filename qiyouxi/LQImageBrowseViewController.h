//
//  QYXImageBrowseViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQAdvertiseView.h"

@interface LQImageBrowseViewController : UIViewController
@property (unsafe_unretained) IBOutlet UIView* titleView;
@property (unsafe_unretained) IBOutlet LQAdvertiseView* imagesView;
@property (strong) NSArray* imageUrls;
@property (assign) int selectedPage;
@property (assign) BOOL needRotation;

- (IBAction)onBack:(id)sender;
@end
