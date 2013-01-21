//
//  LQRankSectionHeader.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQRankSectionHeader : UIView


@property (unsafe_unretained) IBOutlet UIButton* leftButton;
@property (unsafe_unretained) IBOutlet UIButton* middleButton;
@property (unsafe_unretained) IBOutlet UIButton* rightButton;

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;

- (void) setButtonStatus:(int) index;

@end
