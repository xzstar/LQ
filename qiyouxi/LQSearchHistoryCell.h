//
//  LQSearchHistoryCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-7.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQSearchHistoryCell : UITableViewCell{
    BOOL hiddenDelButton;
}
@property (nonatomic,assign) BOOL hiddenDelButton;
@property (unsafe_unretained) IBOutlet UILabel* type;
@property (unsafe_unretained) IBOutlet UILabel* name;
@property (unsafe_unretained) IBOutlet UIButton* deleteButton;
@property (unsafe_unretained) IBOutlet UIImageView* cellBg;

- (void) hiddenDelButton:(BOOL)aHiddenDelButton;
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
@end
