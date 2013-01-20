//
//  LQGameMoreItemTableViewCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQHistoryTableViewCell.h"

@interface LQGameMoreItemTableViewCell : LQHistoryTableViewCell
@property (unsafe_unretained) IBOutlet UIView* gameActionView;
@property (unsafe_unretained) IBOutlet UIButton* leftButton;
@property (unsafe_unretained) IBOutlet UIButton* middleButton;
@property (unsafe_unretained) IBOutlet UIButton* rightButton;

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
//- (void) addDownloadButtonsTarget:(id)target action:(SEL)action tag:(int)tag;

- (void) setButtonsName:(NSString*)left middle:(NSString*)middle right:(NSString*)right;

- (void) addLeftButtonTarget:(id)target action:(SEL)action tag:(int)tag;

- (void) addMiddleButtonTarget:(id)target action:(SEL)action tag:(int)tag;
        
- (void) addRightButtonTarget:(id)target action:(SEL)action tag:(int)tag;

@end
