//
//  QYXObjectExtension.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-6.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "QYXObjectExtension.h"
#import "LQToast.h"

@implementation UIColor(LQObjectExtension)
+ (UIColor*)colorWithHexString:(NSString*)hexString{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	CGFloat r, g, b, a;
	a = ((hexNum & 0xFF000000) >> 24) / 255.0f;
	r = ((hexNum & 0x00FF0000) >> 16) / 255.0f;
	g = ((hexNum & 0x0000FF00) >> 8) / 255.0f;
	b = (hexNum & 0x000000FF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end

@implementation UILabel(LQObjectExtension)
- (void)autowrap:(CGFloat)maxHeight{
    CGSize lineSize = self.bounds.size;
    lineSize.height = maxHeight;
    lineSize = [self.text sizeWithFont:self.font constrainedToSize:lineSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize rowSize = [@"Test" sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, 0) lineBreakMode:UILineBreakModeWordWrap];
    self.numberOfLines = (lineSize.height + rowSize.height) / rowSize.height;
    CGRect frame = self.frame;
    frame.size.height = lineSize.height;
    self.frame = frame;
}

@end 


@implementation NSString(LQObjectExtension)
- (void)showToastAsInfo{
    [LQToast show:self length:kQYXToastLengthShort];
}

- (void)showToastAsError{
    [LQToast show:self length:kQYXToastLengthLong];
}
@end