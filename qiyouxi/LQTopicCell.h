//
//  LQTopicCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-8.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQTopicCell : UITableViewCell<LQImageReceiver>

@property (nonatomic, strong) LQGameInfo* gameInfo;
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;

@end

@interface LQTopicCell()
@property (unsafe_unretained) IBOutlet UIImageView* gameIconView;
@property (unsafe_unretained) IBOutlet UILabel* gameTitleLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameDetailLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameComments;
@property (unsafe_unretained) IBOutlet UIButton* topicListButton;

@end
