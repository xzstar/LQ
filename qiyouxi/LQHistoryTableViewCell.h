//
//  QYXHistoryTableViewCellCell.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQHistoryTableViewCell : UITableViewCell<LQImageReceiver>
@property (nonatomic, strong) LQGameInfo* gameInfo;

- (IBAction)onActionButton:(id)sender;
- (IBAction)onDetailButton:(id)sender;

//- (void) onSelected:(bool) selected;
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;

@end

@interface LQHistoryTableViewCell()
@property (unsafe_unretained) IBOutlet UIImageView* gameIconView;
@property (unsafe_unretained) IBOutlet UILabel* gameTitleLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameDetailLabel;
@property (unsafe_unretained) IBOutlet UIButton* actionButton;
@property (unsafe_unretained) IBOutlet UIView* gameActionView;
@property (unsafe_unretained) IBOutlet UIView* gameInfoView;

@end

