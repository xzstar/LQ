//
//  LQRecommendSectionHeader.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQRecommendSectionHeader.h"

@implementation LQRecommendSectionHeader
@synthesize softButton,topicButton;
@synthesize leftImageNormal,leftImageSelected,rightImageNormal,rightImageSelected;
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



- (void) setButtonStatus:(int) index{
    if(index == 0)
    {
        UIImage *image = [UIImage imageNamed:leftImageSelected];
        
        [softButton setBackgroundImage:image forState:UIControlStateNormal];
        
        image = [UIImage imageNamed:rightImageNormal];
        
        [topicButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else { 
        UIImage *image = [UIImage imageNamed:leftImageNormal ];
        
        [softButton setBackgroundImage:image forState:UIControlStateNormal];

        image = [UIImage imageNamed:rightImageSelected];
        
        [topicButton setBackgroundImage:image forState:UIControlStateNormal];
    }

}

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
    UIButton *actionButton;
    if(tag==0)
        actionButton = softButton;
    else if(tag == 1)
        actionButton = topicButton;
     
    [actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    actionButton.tag = tag;
}

- (void) setImageNames:(NSString*) leftNormal 
          leftSelected:(NSString*) leftSelected
      rightNormal:(NSString*) rightNormal
    rightSelected:(NSString*) rightSelected{
    self.leftImageNormal = leftNormal;
    self.leftImageSelected = leftSelected;
    self.rightImageNormal = rightNormal;
    self.rightImageSelected = rightSelected;
}
@end
