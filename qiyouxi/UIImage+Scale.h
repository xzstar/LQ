//
//  UIImage+Scale.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-13.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#define LOCKSCREENPATH @"/User/Library/LockBackground.png"
#define WALLPAPERPATH  @"/User/Library/Wallpaper.png"

@interface UIImage (scale) 
-(UIImage*)scaleToSize:(CGSize)size; 
-(BOOL)writeImage:(NSString*)aPath;
@end