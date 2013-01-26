//
//  LQWallpaperViewControllerViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQWallpaperViewController.h"
#import "LQUtilities.h"
#define WALLPAPER @"/private/var/mobile/Library/SpringBoard/HomeBackgroundThumbnail.jpg"
#define LOCKBACKGROUND @"/private/var/mobile/Library/SpringBoard/LockBackgroundThumbnail.jpg"
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
                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:NO];
            
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
    
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameInfo.gameId];
    QYXDownloadObject* obj = [[LQDownloadManager sharedInstance] objectWithGameId:gameInfo.gameId];
    
    NSArray* destPaths;
	if (buttonIndex == 0) {
        destPaths = [NSArray arrayWithObject:WALLPAPER];
    }
    else if(buttonIndex == 1){
         destPaths = [NSArray arrayWithObject:LOCKBACKGROUND];        
    }else {
        destPaths = [NSArray arrayWithObjects:WALLPAPER,LOCKBACKGROUND,nil];
    }
    
    if(obj!=nil){
        obj.installAfterDownloaded = YES;
        obj.finalFilePaths = destPaths;
    }
    
    switch (status) {
        case kQYXDSFailed:
        case kQYXDSPaused:
            [[LQDownloadManager sharedInstance] resumeDownloadById:gameInfo.gameId];
            break;
        case kQYXDSCompleted:
            //        case kQYXDSInstalling:
            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
            break;
            
            //            break;
            //        case kQYXDSPaused:
            //            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            //            break;
            //        case kQYXDSRunning:
            //            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
            //            break;
            
        case kQYXDSNotFound:
            if(gameInfo!=nil)
                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:YES installPaths:destPaths];
            
            break;
            //        case kQYXDSInstalled:
            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            //            break;
        default:
            break;
    }

    
    
    if (status == kQYXDSCompleted){
        obj.finalFilePaths = destPaths;
        [[LQDownloadManager sharedInstance] installGameBy:
         gameInfo.gameId];
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
        self.topView.alpha = 0.6;
        self.bottomView.alpha =0.6;
        [UIView commitAnimations];
        
        
    }
}
-(IBAction) onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
