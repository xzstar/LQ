//
//  LQRankSectionHeader.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQRankSectionHeader.h"

@implementation LQRankSectionHeader
@synthesize leftButton,middleButton,rightButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
    UIButton *actionButton;
    if(tag==0)
        actionButton = leftButton;
    else if(tag == 1)
        actionButton = middleButton;
    else 
        actionButton = rightButton;
    
    
    [actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    actionButton.tag = tag;
}

@end
