//
//  LQGameDetailViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQImageButton.h"
#import "LQAdvertiseView.h"
#import "QYXData.h"
#import "LQCommentTableViewCell.h"
#import "KRShare.h"

@interface LQGameDetailViewController : LQViewController<UITableViewDataSource, UITableViewDelegate,KRShareDelegate,KRShareRequestDelegate>{
    id delegate;
    KRShare* _krShare;
}
@property (assign) int gameId;
@property (strong) LQGameInfo* gameInfo;
@property (strong) id delegate;
@property (unsafe_unretained) IBOutlet UIScrollView* mainScrollView;

@property (unsafe_unretained) IBOutlet UIView* gameBaseInfoPanel;
@property (unsafe_unretained) IBOutlet LQImageButton* gameIconView;
@property (unsafe_unretained) IBOutlet UILabel* gameTitleLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameSize;
@property (unsafe_unretained) IBOutlet UILabel* gameDownloadCount;
@property (unsafe_unretained) IBOutlet UILabel* gameType;
@property (unsafe_unretained) IBOutlet UILabel* gameVersion;
@property (unsafe_unretained) IBOutlet UILabel* gameScore;
@property (unsafe_unretained) IBOutlet UIButton* downloadNowButton;
@property (unsafe_unretained) IBOutlet UIButton* installNowButton;
@property (unsafe_unretained) IBOutlet UILabel* commentLabel;
@property (unsafe_unretained) IBOutlet UIButton* moreDescButton;

@property (unsafe_unretained) IBOutlet UIView* gamePhotoInfoPanel;
@property (unsafe_unretained) IBOutlet LQAdvertiseView* screenShotsView;
@property (unsafe_unretained) IBOutlet UIButton* weiboShareButton;
@property (unsafe_unretained) IBOutlet UIButton* qqShareButton;
@property (unsafe_unretained) IBOutlet UILabel* gameScore2;
@property (unsafe_unretained) IBOutlet UITableView *gameInfoCommentTableView;
@property (unsafe_unretained) IBOutlet UIButton* postCommentButton;
@property (unsafe_unretained) IBOutlet UILabel* gameNoCommentLabel;

@property (strong) LQCommentTableViewCell* dummyCell;
- (void) addSwitchPageWithActionHandler:(void (^)(int))actionHandler;
- (IBAction)onMoreDesc:(id)sender;
- (IBAction)onShowComments:(id)sender;
- (IBAction)onQQWeibo:(id)sender;
- (IBAction)onSinaWeibo:(id)sender;

- (IBAction)onGameDownload:(id)sender;
- (IBAction)onGameDownloadAndInstall:(id)sender;
@end
