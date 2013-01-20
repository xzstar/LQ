//
//  LQSearchSectionHeader.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-7.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQRecommendSectionHeader.h"

@interface LQSearchSectionHeader : UIView

@property(nonatomic,unsafe_unretained) IBOutlet UIButton* leftButton;
@property(nonatomic,unsafe_unretained) IBOutlet UIButton* rightButton;
@property(nonatomic,unsafe_unretained) IBOutlet UIImageView* backgroundImageView;
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
- (void) setButtonStatus:(int)index;

@end
