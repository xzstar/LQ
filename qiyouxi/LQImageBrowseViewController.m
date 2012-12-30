//
//  QYXImageBrowseViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQImageBrowseViewController.h"

@interface LQImageBrowseViewController ()
@property (nonatomic, assign) int hideTag;
@end

@implementation LQImageBrowseViewController
@synthesize titleView;
@synthesize imagesView;
@synthesize needRotation;
@synthesize imageUrls;
@synthesize hideTag;
@synthesize selectedPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleView.hidden = NO;
    self.titleView.alpha = 0.0;
    self.imagesView.delegate = self;
    self.imagesView.selectPage = self.selectedPage;
    self.imagesView.imageUrls = self.imageUrls;
    
    self.hideTag = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)QYXAdvertiseView:(LQAdvertiseView*)advertiseView selectPage:(int)page{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.titleView.alpha = 1.0;
    [UIView commitAnimations];
    
    self.hideTag ++;
    [self performSelector:@selector(hideTitleView:) withObject:[NSNumber numberWithInt:self.hideTag] afterDelay:2.0];
}

- (void)hideTitleView:(NSNumber*)value{
    if ([value intValue] == self.hideTag){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.titleView.alpha = 0.0;
        [UIView commitAnimations];
    }
}

@end
