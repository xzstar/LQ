//
//  QYXObjectExtension.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-6.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(LQObjectExtension)
+ (UIColor*)colorWithHexString:(NSString*)hexString;
@end

@interface UILabel(LQObjectExtension)
- (void)autowrap:(CGFloat)maxHeight;
@end

@interface NSString(LQObjectExtension)
- (void)showToastAsInfo;
- (void)showToastAsError;
@end