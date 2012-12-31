//
//  LQCategorySectionHeader.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQCategorySectionHeader : UIView
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
@end
@interface LQCategorySectionHeader()
@property (unsafe_unretained) IBOutlet UIButton* softButton;
@property (unsafe_unretained) IBOutlet UIButton* gameButton;
@property (unsafe_unretained) IBOutlet UIButton* ringButton;
@property (unsafe_unretained) IBOutlet UIButton* wallpaperButton;

@end
