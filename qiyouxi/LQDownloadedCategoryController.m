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

extern NSString* const kNotificationDownloadComplete;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateStatus:)
												 name:kNotificationDownloadComplete
											   object:nil];
    
    [self updateStatus:nil];

}

- (void)updateStatus:(NSNotification*)notification{
    int softCompleted=0;
    int softInstalled=0;
    int gameCompleted=0;
    int gameInstalled=0;
    int ringCompleted=0;
    int wallpaperCompleted=0;
    
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"soft"]) {
            softCompleted++;
        }else if([obj.gameInfo.fileType isEqualToString: @"game"]){
            gameCompleted++;
        }else if([obj.gameInfo.fileType isEqualToString: @"wallpaper"]){
            wallpaperCompleted++;
        }else{
            ringCompleted++;
        }
        
    }
    
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].installedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"soft"]) {
            softInstalled++;
        }else if([obj.gameInfo.fileType isEqualToString: @"game"]){
            gameInstalled++;
        }
        
    }
    
    softLabel.text = [NSString stringWithFormat:@"未安装%d个,已安装%d个",softCompleted,softInstalled];
    gameLabel.text = [NSString stringWithFormat:@"未安装%d个,已安装%d个",gameCompleted,gameInstalled];
    ringLabel.text = [NSString stringWithFormat:@"已下载%d个",ringCompleted];
    wallpaperLabel.text = [NSString stringWithFormat:@"已下载%d个",wallpaperCompleted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

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
