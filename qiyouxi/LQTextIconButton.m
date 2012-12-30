//
//  QYXTextIconButton.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQTextIconButton.h"

@implementation LQTextIconButton

- (void)awakeFromNib{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setTitle:@"无" forState:UIControlStateNormal];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    UIImage* image = [UIImage imageNamed:@"icon_small.png"];
    CGRect rect;
    rect.size = image.size;
    rect.origin.x = (contentRect.size.width - rect.size.width)/2;
    rect.origin.y = 5.0;
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect =  self.imageView.bounds;
    rect.size.width = contentRect.size.width;
    rect.origin.x = 0;
    rect.origin.y = rect.size.height + 10.0f;
    rect.size.height = 15;
    return rect;
}

- (void)applyImage:(UIImage*)image{
    if (image != nil){
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateHighlighted];
    }
}

- (UIView*)availableImageView{
    return self.imageView;
}

@end
