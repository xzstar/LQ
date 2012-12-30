//
//  QYXToast.m
//  TicketGo
//
//  Created by maruojie on 09-10-12.
//  Copyright 2009 MobGo. All rights reserved.
//

#import "LQToast.h"

#define MARGIN 40
#define PI 3.1415926

@interface LQToast(Private)
// called when a toast is showed
- (void)showToastAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

// called when a toast is hided
- (void)hideToastAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

// called when timer is triggered
- (void)onToastTimeUp:(NSTimer*)timer;
@end


@implementation LQToast

@synthesize label = _label;
@synthesize toastLength;

+ (void)show:(NSString*)text length:(NSTimeInterval)length inView:(UIView*)applicationView{
	LQToast* toast = [[LQToast alloc] init];
	[toast show:text length:length inView:applicationView];
}

+ (void)show:(NSString*)text length:(NSTimeInterval)length {
	NSArray* windows = [UIApplication sharedApplication].windows;
	UIView* applicationView = [windows lastObject];
    [LQToast show:text length:length inView:applicationView];
}

- (void)show:(NSString*)text length:(NSTimeInterval)length{
	NSArray* windows = [UIApplication sharedApplication].windows;
	UIView* applicationView = [windows lastObject];
    [self show:text length:length inView:applicationView];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		// create bg view
		UIImage* bg = [[UIImage imageNamed:@"toast_bg.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:24];
		_bgView = [[UIImageView alloc] initWithImage:bg];
		
		// create label view
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = [UIColor clearColor];
		_label.numberOfLines = 0;
		_label.textColor = [UIColor whiteColor];
		[_bgView addSubview:_label];
	}
	return self;
}

- (void)show:(NSString*)text length:(NSTimeInterval)length inView:(UIView*)applicationView{
    self.toastLength = length;
    
	// set text
	_label.text = text;
    
    CGRect screenBound = applicationView.bounds;
	
    if ([applicationView isKindOfClass:[UIWindow class]]){
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                break;
            case UIInterfaceOrientationLandscapeLeft:
                screenBound.size.width = applicationView.bounds.size.height;
                screenBound.size.height = applicationView.bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeRight:
                screenBound.size.width = applicationView.bounds.size.height;
                screenBound.size.height = applicationView.bounds.size.width;
                break;
            default:
                break;
        }
    }
    
    
	// use a default frame for bg view first
	CGRect frame = CGRectMake(0, 0, screenBound.size.width - MARGIN, screenBound.size.height);
	_bgView.frame = frame;
	
	// found the best size of label
	CGRect bestLabelBound = CGRectMake(12, 12, frame.size.width - 24, screenBound.size.height);
	bestLabelBound = [_label textRectForBounds:bestLabelBound limitedToNumberOfLines:0];
	frame.size.width = bestLabelBound.size.width + 60;
	frame.size.height = bestLabelBound.size.height + 30;
	frame.origin.x = (screenBound.size.width - frame.size.width) / 2;
	frame.origin.y = screenBound.size.height - (screenBound.size.height / 10 + frame.size.height);
	_bgView.frame = frame;
	
	// place label in center
	_label.frame = CGRectMake((frame.size.width - bestLabelBound.size.width) / 2, 
							  (frame.size.height - bestLabelBound.size.height) / 2, 
							  bestLabelBound.size.width, 
							  bestLabelBound.size.height);
    
    //转换
    if ([applicationView isKindOfClass:[UIWindow class]]){
        
        CGFloat radian = 0;
        CGFloat cx = screenBound.size.width/2;
        CGFloat cy = screenBound.size.height/2;
        CGPoint center = _bgView.center;
        CGPoint offset = CGPointMake(center.x - cx, cy - center.y);
        
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                radian = PI;
                offset = CGPointMake( - offset.x, - offset.y);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                radian = -PI/2;
                offset = CGPointMake( - offset.y, offset.x);
                cx = screenBound.size.height/2;
                cy = screenBound.size.width/2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                radian = PI/2;
                offset = CGPointMake( offset.y, -offset.x);
                cx = screenBound.size.height/2;
                cy = screenBound.size.width/2;
                break;
            default:
                break;
        }
        
        //在做transform之前设置中心点，如果放在后面做会被transform掉
        center = CGPointMake(offset.x + cx, cy - offset.y);
        _bgView.center = center;
        
        //设置transform变量，以当前view的center为中心
        CGAffineTransform transform = CGAffineTransformMakeRotation(radian);
        _bgView.transform = transform;
    }
    
	[applicationView addSubview:_bgView];
	[applicationView bringSubviewToFront:_bgView];
	
	// fade in
	_bgView.alpha = 0.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showToastAnimationDidStop:finished:context:)];
	_bgView.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)onToastTimeUp:(NSTimer*)timer {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideToastAnimationDidStop:finished:context:)];
	_bgView.alpha = 0.0;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark animation delegate

- (void)showToastAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView setAnimationDelegate:nil];
	[UIView setAnimationDidStopSelector:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:self.toastLength
									 target:self
								   selector:@selector(onToastTimeUp:)
								   userInfo:nil
									repeats:NO];
}

- (void)hideToastAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView setAnimationDelegate:nil];
	[UIView setAnimationDidStopSelector:nil];
	
	[_bgView removeFromSuperview];
}

@end
