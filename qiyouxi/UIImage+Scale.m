//
//  UIImage+Scale.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-13.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "UIImage+Scale.h"
@implementation UIImage (scale) 
-(UIImage*)scaleToSize:(CGSize)size 
{ 
    // 创建一个bitmap的context 
    // 并把它设置成为当前正在使用的context 
    UIGraphicsBeginImageContext(size); 
    // 绘制改变大小的图片 
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)]; 
    // 从当前context中创建一个改变大小后的图片 
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    // 使当前的context出堆栈 
    UIGraphicsEndImageContext(); 
    // 返回新的改变大小后的图片 
    return scaledImage; 
} 
-(BOOL)writeImage:(NSString*)aPath{
    if ((aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try    
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(self);            
        }
        
        else
        {
            // the rest, we write to jpeg
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(self, 0);    
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];      
        return YES;
    }    
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;

}
@end