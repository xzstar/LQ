//
//  LQIgnoreAppCell.h
//  liqu
//
//  Created by Xie Zhe on 13-1-18.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQIgnoreAppCell : UITableViewCell<LQImageReceiver>{
    LQGameInfo* gameInfo;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView* icon;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel* title;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton* deleteButton;
@property (nonatomic,strong) LQGameInfo* gameInfo;
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
- (void)setGameInfo:(id)aGameInfo;
@end
