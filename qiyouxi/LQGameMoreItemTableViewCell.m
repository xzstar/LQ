//
//  LQGameMoreItemTableViewCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQGameMoreItemTableViewCell.h"

@implementation LQGameMoreItemTableViewCell
@synthesize gameActionView;
@synthesize middleButton,leftButton,rightButton;
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
//- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
//    [super addInfoButtonsTarget:target
//                         action:action
//                            tag:tag];
//    [gameDetailButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    gameDetailButton.tag = tag;
//    
//}

//- (void) addDownloadButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
//    [gameInstallNowButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [gameDownloadButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    gameInstallNowButton.tag = tag;
//    gameDownloadButton.tag = tag;    
//}

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
