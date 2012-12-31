//
//  LQRecommendSectionHeader.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQRecommendSectionHeader : UIView
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
@end
@interface LQRecommendSectionHeader()
@property (unsafe_unretained) IBOutlet UIButton* softButton;
@property (unsafe_unretained) IBOutlet UIButton* topicButton;
@end
