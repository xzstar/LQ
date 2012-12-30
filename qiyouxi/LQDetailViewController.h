//
//  QYXDetailViewController.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQImageButton.h"
#import "LQAdvertiseView.h"
#import "QYXData.h"
#import "LQCommentTableViewCell.h"

@interface LQDetailViewController : LQViewController<UITableViewDataSource, UITableViewDelegate>{
}
@property (assign) int gameId;
@property (strong) LQGameInfo* gameInfo;

@property (unsafe_unretained) IBOutlet UIView* contentView;

@property (strong) IBOutlet UIView* gameInfoPanel;
@property (unsafe_unretained) IBOutlet LQImageButton* gameIconView;
@property (unsafe_unretained) IBOutlet UILabel* gameTitleLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameDetailLabel;

@property (unsafe_unretained) IBOutlet UILabel* commentLabel;
@property (unsafe_unretained) IBOutlet LQImageButton* commentGirlView;
@property (unsafe_unretained) IBOutlet UILabel* commentGirlNameLabel;

@property (unsafe_unretained) IBOutlet LQAdvertiseView* screenShotsView;

@property (strong) IBOutlet UIView* commentsPanel;
@property (unsafe_unretained) IBOutlet UITableView* userCommentsView;

@property (unsafe_unretained) IBOutlet UIButton* detailButton;
@property (unsafe_unretained) IBOutlet UIButton* commentsButton;
@property (unsafe_unretained) IBOutlet UIView* buttonUnderline;

@property (strong) LQCommentTableViewCell* dummyCell;

- (IBAction)onShowDetail:(id)sender;
- (IBAction)onShowComments:(id)sender;

@end
