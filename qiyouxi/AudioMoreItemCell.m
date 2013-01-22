//
//  AudioMoreItemCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-1.
//  Copyright (c) 2013年 LQ科技有限公司. All rights reserved.
//

#import "AudioMoreItemCell.h"

@implementation AudioMoreItemCell
@synthesize middleButton,leftButton,rightButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setButtonsName:(NSString*)left middle:(NSString*)middle right:(NSString*)right{
    [leftButton setTitle:left forState:UIControlStateNormal];
    leftButton.hidden = (left==nil);
    
    [middleButton setTitle:middle forState:UIControlStateNormal];
    middleButton.hidden = (middle==nil);
    
    [rightButton setTitle:right forState:UIControlStateNormal];
    rightButton.hidden = (right==nil);
    
}
- (void) addLeftButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = tag;
    
}
- (void) addMiddleButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [middleButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    middleButton.tag = tag;  
}
- (void) addRightButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = tag;
}

@end
