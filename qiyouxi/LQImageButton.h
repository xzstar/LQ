//
//  QYXImageButton.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQImageButton : UIButton<LQImageReceiver>{
@private    
    UIImageView* _loadingView;
    NSTimer* _animationTimer;
}

@property (nonatomic, strong) NSString* imageUrl;

- (void)loadImageUrl:(NSString*)url defaultImage:(UIImage*)defaultImage;
- (UIView*)availableImageView;

@end
