//
//  KTPhotoView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class KTPhotoScrollViewController;
@class LQImageButton;

@interface KTPhotoView : UIScrollView <UIScrollViewDelegate,LQImageReceiver>
{
    UIImageView *imageView_;
    //LQImageButton *imageButton;
    id parent;
    NSInteger index_;
    UIImageView* _loadingView;
    NSTimer* _animationTimer;
    NSString* imageUrl;
}

@property (nonatomic, strong) id parent;
@property (nonatomic, assign) NSInteger index;

- (void)setImage:(UIImage *)newImage;
- (void)setImageUrl:(NSString *)newImageUrl;
- (void)turnOffZoom;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;


@end
