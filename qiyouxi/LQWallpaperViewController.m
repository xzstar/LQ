//
//  LQWallpaperViewControllerViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQWallpaperViewController.h"

@interface LQWallpaperViewController ()

@end

@implementation LQWallpaperViewController
@synthesize imageUrl,imageView,fullScreenButton,setWallpaperButton,downloadButton,topView,bottomView,title,titleString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:imageUrl context:self];
    if (image != nil){
        [imageView setImage:image];
    }else {
        
    }
    self.title.text = titleString;
    [self hideToolBar:3.0f];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if (image != nil) {
        [imageView setImage:image];
    }
}

-(void) onSetWallpaperClick:(id) sender{
    
}
-(IBAction) onDownloadClick:(id) sender{
    
}

-(IBAction) onHideToolbarClick:(id) sender{
    [self hideToolBar:0.5f];
}

-(void) hideToolBar:(float) animationSec{
    hidden = !hidden;
    if(hidden){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationSec];
        self.topView.alpha = 0.0;
        self.bottomView.alpha =0.0;
        [UIView commitAnimations];
        
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationSec];
        self.topView.alpha = 1.0;
        self.bottomView.alpha =0.2;
        [UIView commitAnimations];
        
        
    }
}
-(IBAction) onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end