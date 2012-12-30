//
//  QYXPostCommentViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQPostCommentViewController : LQViewController<UITextFieldDelegate>
@property (nonatomic, assign) int gameId;

@property (nonatomic, unsafe_unretained) IBOutlet UITextField* contactField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextView* contentField;

- (IBAction)onSubmit:(id)sender;
@end
