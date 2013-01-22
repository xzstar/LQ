//
//  LQDownloadedCategoryController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQDownloadedCategoryController.h"
#import "LQDownloadedViewController.h"
#import "LQDownloadedRingsViewController.h"
#import "LQDownloadedWallpaperViewController.h"
@interface LQDownloadedCategoryController ()

@end

@implementation LQDownloadedCategoryController
@synthesize parent;
@synthesize softLabel,gameLabel,ringLabel,wallpaperLabel;
@synthesize softButton,gameButton,ringButton,wallpaperButton;
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


-(IBAction)onSoftClick:(id)sender{
    LQDownloadedViewController *controller = [[LQDownloadedViewController alloc] initWithNibName:@"LQDownloadedViewController" bundle:nil];
    [self.parent.navigationController pushViewController:controller animated:YES];
}
-(IBAction)onGameClick:(id)sender{
    
}
-(IBAction)onRingClick:(id)sender{
    LQDownloadedRingsViewController *controller = [[LQDownloadedRingsViewController alloc] initWithNibName:@"LQDownloadedViewController" bundle:nil];
    [self.parent.navigationController pushViewController:controller animated:YES];

}
-(IBAction)onWallpaerClick:(id)sender{
   LQDownloadedWallpaperViewController *controller = [[LQDownloadedWallpaperViewController alloc] initWithNibName:@"LQDownloadedViewController" bundle:nil];
    [self.parent.navigationController pushViewController:controller animated:YES];

}


@end
