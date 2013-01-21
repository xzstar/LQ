//
//  QYXPostCommentViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"

@interface LQPostCommentViewController : LQViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) int gameId;
@property (nonatomic, strong) NSString* scoreString;
@property (nonatomic, assign) IBOutlet UILabel* gameScore;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField* contactField;
@property (nonatomic, unsafe_unretained) IBOutlet UITextView* contentField;

@property (nonatomic,unsafe_unretained) IBOutlet UITableView* commentsTableView;
@property (nonatomic,unsafe_unretained)IBOutlet UIButton* starButton1;
@property (nonatomic,unsafe_unretained)IBOutlet UIButton* starButton2;
@property (nonatomic,unsafe_unretained)IBOutlet UIButton* starButton3;
@property (nonatomic,unsafe_unretained)IBOutlet UIButton* starButton4;
@property (nonatomic,unsafe_unretained)IBOutlet UIButton* starButton5;

- (IBAction)onSubmit:(id)sender;
- (IBAction)onStarButtonClicked:(id)sender;
@end
