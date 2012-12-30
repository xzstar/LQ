//
//  QYXRecommendButton.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQRecommendButton.h"

@interface LQRecommendButton()

@end

@implementation LQRecommendButton

- (void)awakeFromNib{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitle:@"加载中..." forState:UIControlStateNormal];
    self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.47];
}

- (CGRect)contentRectForBounds:(CGRect)bounds{
    CGRect rect = bounds;
    rect.origin.y = bounds.size.height - 20;
    rect.size.height = 20;
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return contentRect;
}

- (void)applyImage:(UIImage*)image{
    if (image != nil){
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

@end
