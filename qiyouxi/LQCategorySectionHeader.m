//
//  LQCategorySectionHeader.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQCategorySectionHeader.h"

@implementation LQCategorySectionHeader
@synthesize softButton,gameButton,ringButton,wallpaperButton;
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
        actionButton = softButton;
    else if(tag == 1)
        actionButton = gameButton;
    else if(tag == 2)
        actionButton = ringButton;
    else if(tag == 3)
        actionButton = wallpaperButton;
    
    [actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    actionButton.tag = tag;
}
@end
