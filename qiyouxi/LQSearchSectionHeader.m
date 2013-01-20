//
//  LQSearchSectionHeader.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-7.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQSearchSectionHeader.h"

@implementation LQSearchSectionHeader
@synthesize leftButton,rightButton,backgroundImageView;
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
        actionButton = rightButton;
    
    [actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    actionButton.tag = tag;

}
- (void) setButtonStatus:(int)index{
    if(index == 0)
    {
        UIImage *image = [UIImage imageNamed:@"search_tab_bg_left.png"];
        backgroundImageView.image = image;
        
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];

        [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];

    }
    else { 
        UIImage *image = [UIImage imageNamed:@"search_tab_bg_right.png"];
        backgroundImageView.image = image;
        
        [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];

        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];

    }
}


@end
