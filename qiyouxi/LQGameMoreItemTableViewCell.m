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
@synthesize gameDownloadButton,gameInstallNowButton,gameDetailButton;
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
    [gameInstallNowButton setTitle:left forState:UIControlStateNormal];
    gameInstallNowButton.hidden = (left==nil);
    
    [gameDownloadButton setTitle:middle forState:UIControlStateNormal];
    gameDownloadButton.hidden = (middle==nil);
    
    [gameDetailButton setTitle:right forState:UIControlStateNormal];
    gameDetailButton.hidden = (right==nil);
    
}
- (void) addLeftButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [gameInstallNowButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    gameInstallNowButton.tag = tag;

}
- (void) addMiddleButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [gameDownloadButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    gameDownloadButton.tag = tag;  
}
- (void) addRightButtonTarget:(id)target action:(SEL)action tag:(int)tag{
    [gameDetailButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    gameDetailButton.tag = tag;
}

@end
