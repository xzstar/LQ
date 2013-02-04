//
//  QYXImageButton.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQImageButton.h"

@implementation LQImageButton
@synthesize imageUrl;
@synthesize realImage;
- (void)applyImage:(UIImage*)image{
    if (image != nil){
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
}

- (UIView*)availableImageView{
    return nil;
}

- (UIImage*)availableImage{
    return realImage;
}
- (void)loadImageUrl:(NSString*)url defaultImage:(UIImage*)defaultImage{
    self.imageUrl = url;
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:url context:self];
    if (image != nil){
        [_loadingView removeFromSuperview];
        [_animationTimer invalidate];
        [self applyImage:image];
        self.realImage = image;
    }else{
        [self applyImage:defaultImage];
        
        if (_loadingView == nil){
            _loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_progress.png"]];
            UIView* view = [self availableImageView];
            if (view != nil){
                _loadingView.center = view.center;
            }else{
                _loadingView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            }
            [self addSubview:_loadingView];
            
            [_animationTimer invalidate];
            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onLoading:) userInfo:_loadingView repeats:YES];
        }
    }
}

- (void)onLoading:(NSTimer*)timer{
    UIView* view = timer.userInfo;
    view.transform = CGAffineTransformMakeRotation(view.tag * 2 * 3.1415926535/20);
    view.tag ++;
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)aImageUrl{
    if ([imageUrl isEqualToString:aImageUrl]){
        [_loadingView removeFromSuperview];
        [_animationTimer invalidate];
        self.realImage = image;
        [self applyImage:image];
    }
}


@end
