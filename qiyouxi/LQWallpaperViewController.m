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
@synthesize imageUrl,imageView,fullScreenButton,setWallpaperButton,downloadButton,topView,bottomView,title,titleString,gameInfo;
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
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@""
													   delegate:self 
											  cancelButtonTitle:@"取消"
										 destructiveButtonTitle:nil
											  otherButtonTitles:@"设置为桌面壁纸",@"设置为锁屏壁纸",@"两者都设置",
                            nil];
	alert.tag = 0;
	// use the same style as the nav bar
    alert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    [alert showInView:self.view];
}
-(IBAction) onDownloadClick:(id) sender{
    //LQGameInfo* info = [appsList objectAtIndex:row];
    int gameId = gameInfo.gameId;
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
    switch (status) {
        case kQYXDSFailed:
            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
            break;
            //        case kQYXDSCompleted:
            //        case kQYXDSInstalling:
            //            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
            //            break;
            //        case kQYXDSPaused:
            //            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            //            break;
            //        case kQYXDSRunning:
            //            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
            //            break;
        case kQYXDSNotFound:
            if(gameInfo!=nil)
                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo suspended:NO];
            
            break;
            //        case kQYXDSInstalled:
            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            //            break;
        default:
            break;
    }
}

-(IBAction) onSaveWallpaper:(id)sender{

	
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	if (buttonIndex == 1) {
    }
    else if(buttonIndex == 2){
        
    }else {
        
    }
    
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
