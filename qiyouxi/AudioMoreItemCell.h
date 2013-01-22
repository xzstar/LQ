//
//  AudioMoreItemCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-1.
//  Copyright (c) 2013年 LQ科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioCell.h"
@interface AudioMoreItemCell : AudioCell

@property (unsafe_unretained) IBOutlet UIButton* leftButton;
@property (unsafe_unretained) IBOutlet UIButton* middleButton;
@property (unsafe_unretained) IBOutlet UIButton* rightButton;

- (void) setButtonsName:(NSString*)left middle:(NSString*)middle right:(NSString*)right;

- (void) addLeftButtonTarget:(id)target action:(SEL)action tag:(int)tag;

- (void) addMiddleButtonTarget:(id)target action:(SEL)action tag:(int)tag;

- (void) addRightButtonTarget:(id)target action:(SEL)action tag:(int)tag;

@end
