//
//  QYXViewControllerViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQViewController.h"
#import <QuartzCore/QuartzCore.h>

#define NAVIGATIONBAR_HEIGHT 44.0

@interface LQViewController ()
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UIWindow* shadowView;
@property (nonatomic, strong) NSTimer* animationTimer;

@end

@implementation LQViewController
@synthesize errorView;

@synthesize shadowView;
@synthesize animationTimer;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadViews];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (!_dataLoaded) {
        _dataLoaded = YES;
        [self loadData];
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self endLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (LQClient*)client{
    if (_client == nil){
        _client = [[LQClient alloc] initWithDelegate:self];
    }
    
    return _client;
}

- (void)loadViews{
    
}

- (void)loadData{
    
}

- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startLoading{
    self.shadowView = [[UIWindow alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.shadowView.hidden = NO;
    self.shadowView.windowLevel = UIWindowLevelAlert;
    
    UIImageView* animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_loading.png"]];
    animationView.center = CGPointMake(self.shadowView.bounds.size.width/2, self.shadowView.bounds.size.height/2);
    [self.shadowView addSubview:animationView];

//    UIImageView* centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_center.png"]];
//    centerView.center = animationView.center;
//    [self.shadowView addSubview:centerView];

    [self.animationTimer invalidate];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onLoading:) userInfo:animationView repeats:YES];
}

- (void)onLoading:(NSTimer*)timer{
    UIView* view = timer.userInfo;
    view.transform = CGAffineTransformMakeRotation(view.tag * 2 * 3.1415926535/20);
    view.tag ++;
}

- (void)endLoading{
    [self.animationTimer invalidate];
    self.shadowView.hidden = YES;
    self.shadowView = nil;
    self.animationTimer = nil;
}

- (void)handleNetworkOK{
    [self.errorView removeFromSuperview];
    self.errorView = nil;
}

- (void)handleNetworkErrorHint{
    [LocalString(@"network.error") showToastAsInfo];
}

- (void)handleNetworkError:(LQClientError*)error{
//    [self.errorView removeFromSuperview];
//    CGRect frame = self.view.bounds;
//    frame.origin.y += NAVIGATIONBAR_HEIGHT;
//    frame.size.height -= NAVIGATIONBAR_HEIGHT;
//    self.errorView = [[UIView alloc] initWithFrame:frame];
//    self.errorView.backgroundColor = [UIColor whiteColor];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"err_network.png"]];
//    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
//    [self.errorView addSubview:imageView];
//    [self.view addSubview:self.errorView];
}

- (void)handleNoNetwork{
//    [self.errorView removeFromSuperview];
//    CGRect frame = self.view.bounds;
//    frame.origin.y += NAVIGATIONBAR_HEIGHT;
//    frame.size.height -= NAVIGATIONBAR_HEIGHT;
//    self.errorView = [[UIView alloc] initWithFrame:frame];
//    self.errorView.backgroundColor = [UIColor whiteColor];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_network.png"]];
//    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
//    [self.errorView addSubview:imageView];
//    [self.view addSubview:self.errorView];
}

- (void)client:(LQClientBase*)client didFailExecution:(LQClientError*)error{
    [self handleNetworkError:error];
}

@end
