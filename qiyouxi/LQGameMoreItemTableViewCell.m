//
//  LQGameMoreItemTableViewCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import "LQGameMoreItemTableViewCell.h"

@implementation LQGameMoreItemTableViewCell
@synthesize gameActionView;

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
    [super addInfoButtonsTarget:target
                         action:action
                            tag:tag];
}
@end
