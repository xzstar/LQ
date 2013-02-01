//
//  LQWallpaperViewControllerViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQWallpaperViewController.h"
#import "LQUtilities.h"
#import "UIImage+Scale.h"
#define WALLPAPER @"/private/var/mobile/Library/SpringBoard/HomeBackground.jpg"
#define LOCKBACKGROUND @"/private/var/mobile/Library/SpringBoard/LockBackground.jpg"
@interface LQWallpaperViewController ()
@property (nonatomic, strong) UIWindow* shadowView;
@property (nonatomic, strong) NSTimer* animationTimer;

@end

@implementation LQWallpaperViewController
@synthesize iconImageUrl,imageUrl,imageView,fullScreenButton,setWallpaperButton,downloadButton,topView,bottomView,title,titleString,gameInfo;
@synthesize shadowView,animationTimer;
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
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:iconImageUrl context:self];
    if (image != nil){
        [imageView setImage:image];
        UIImage* image = [[LQImageLoader sharedInstance] loadImage:imageUrl context:self];
        if (image != nil){
            [imageView setImage:image];
        }
        else {
            [self startLoading];
        }
    }else {
        [self startLoading];
    }
    self.title.text = titleString;
    hidden = YES;
    //[self hideToolBar:3.0f];
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

- (void)updateImage:(UIImage*)image forUrl:(NSString*)aImageUrl{
    if (image != nil) {
        [imageView setImage:image];
        [self endLoading];

        if ([aImageUrl isEqualToString:iconImageUrl]) {
            UIImage* image = [[LQImageLoader sharedInstance] loadImage:imageUrl context:self];
            if (image != nil){
                [imageView setImage:image];
            }
            else {
                [self startLoading];
            }
        }
        
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
    NSString* info;
    switch (status) {
        case kQYXDSFailed:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
            break;
        case kQYXDSCompleted:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            break;
            //        case kQYXDSInstalling:
            //            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
            //            break;
        case kQYXDSPaused:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            break;
        case kQYXDSRunning:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            break;
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
    
    if (buttonIndex>=3) {
        return;
    }
    
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameInfo.gameId];
    QYXDownloadObject* obj = [[LQDownloadManager sharedInstance] objectWithGameId:gameInfo.gameId];
    
    
//    UIImage* sourceImage = imageView.image;
//    CGSize size = [UIScreen mainScreen].bounds.size; 
//    UIImage* sizedSourceImage =[sourceImage scaleToSize:size];
//    
//    void* data = [LQUtilities getImageData:sizedSourceImage];
//    
//    NSMutableData* imageData = [[NSMutableData alloc] initWithBytes:data length:size.width*size.height*4];
//    
//    static unsigned char tailData[] = {
//        0x62, 0x70, 0x6c, 0x69, 0x73, 0x74, 0x30, 0x30, 0x22, 0x40, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 
//        0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 
//        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0d, 0x2e, 0x00, 
//        0x00, 0x00, 0x80, 0x02, 0x00, 0x00, 0xc0, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
//        0x00, 0x00, 0x91, 0x32, 0xa4, 0xcb, 0x0a,   
//    };
//    
//    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:@"LockBackground.cpbitmap"];
//
//    [imageData appendBytes:tailData length:71];
//    
//    [imageData writeToFile:infoPath atomically:YES];
    
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

@end
