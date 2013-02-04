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
#define WALLPAPER      @"/private/var/mobile/Library/SpringBoard/HomeBackground.jpg"
#define LOCKBACKGROUND @"/private/var/mobile/Library/SpringBoard/LockBackground.jpg"
@interface LQWallpaperViewController ()
@property (nonatomic, strong) UIWindow* shadowView;
@property (nonatomic, strong) NSTimer* animationTimer;
-(void) initScrollView;
@end

@implementation LQWallpaperViewController
@synthesize iconImageUrl,imageUrl,setWallpaperButton,downloadButton,topView,bottomView,title,titleString,gameInfo,appsList;
@synthesize shadowView,animationTimer,currentIndex,moreUrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initScrollView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if(photoView == nil)
//    {
//        photoView = [[KTPhotoView alloc] initWithFrame:self.view.frame];
//    }
//    
//    [self.view insertSubview:photoView atIndex:0];
//
    
    
//    UIImage* image = [[LQImageLoader sharedInstance] loadImage:iconImageUrl context:self];
//    if (image != nil){
//        //[imageView setImage:image];
//        [photoView setImage:image];
//        UIImage* image = [[LQImageLoader sharedInstance] loadImage:imageUrl context:self];
//        if (image != nil){
//            //[imageView setImage:image];
//            [photoView setImage:image];
//        }
//        else {
//            [self startLoading];
//        }
//    }else {
//        [self startLoading];
//    }
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

- (void)viewWillAppear:(BOOL)animated{
    [self updatePageViews:self.appsList.count];
    [self setScrollViewContentSize];
    //[self setScrollViewContentSize];
    [self setCurrentIndex:currentIndex];
    [self scrollToIndex:currentIndex];
    
    [self setTitleWithCurrentPhotoIndex];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initScrollView{
    CGRect scrollFrame = [self frameForPagingScrollView];
    scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [scrollView setDelegate:self];
    
//    UIColor *backgroundColor = [dataSource_ respondsToSelector:@selector(imageBackgroundColor)] ?
//    [dataSource_ imageBackgroundColor] : [UIColor blackColor];  
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    
    [[self view] insertSubview:scrollView atIndex:0];
    
}

//- (void)updateImage:(UIImage*)image forUrl:(NSString*)aImageUrl{
//    if (image != nil) {
//        //[imageView setImage:image];
//        [photoView setImage:image];
//
//        [self endLoading];
//
//        if ([aImageUrl isEqualToString:iconImageUrl]) {
//            UIImage* image = [[LQImageLoader sharedInstance] loadImage:imageUrl context:self];
//            if (image != nil){
//                //[imageView setImage:image];
//                [photoView setImage:image];
//
//            }
//            else {
//                [self startLoading];
//            }
//        }
//        
//    }
//}

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
    NSString* info;
    switch (status) {
        case kQYXDSFailed:
        case kQYXDSPaused:
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
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
            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
            [info showToastAsInfo];
            break;
            //        case kQYXDSInstalled:
            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            //            break;
        default:
            break;
    }
   
}

-(IBAction) onHideToolbarClick:(id) sender{
    [self hideToolBar:0.3f];
}

-(void) hideToolBar:(float) animationSec{
    hidden = !hidden;
    if(dragging ==YES)
        return;
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
    self.shadowView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.shadowView.hidden = NO;
    self.shadowView.windowLevel = UIWindowLevelAlert;
    
    UIImageView* animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_progress.png"]];
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


- (void)scrollToIndex:(NSInteger)index 
{
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * index;
//    frame.origin.y = 0;
    
    KTPhotoView* photo = [photoViews objectAtIndex:index];
    
    [scrollView scrollRectToVisible:photo.frame animated:NO];
}

- (void)setScrollViewContentSize
{
    NSInteger pageCount = appsList.count;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollView.frame.size.width * pageCount, 
                             scrollView.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [scrollView setContentSize:size];
}

- (void)updatePageViews:(int) count {
    if(photoViews==nil)
        photoViews = [[NSMutableArray alloc] init];
    
    for (int i=0; i < count; i++) {
        [photoViews addObject:[NSNull null]];
    }
}

#pragma mark -
#pragma mark Photo (Page) Management

- (void)loadPhoto:(NSInteger)index
{
    if (index < 0 || index >= appsList.count || photoViews == nil) {
        return;
    }
    
    id currentPhotoView = [photoViews objectAtIndex:index];
    if (NO == [currentPhotoView isKindOfClass:[KTPhotoView class]]) {
        // Load the photo view.
        CGRect frame = [self frameForPageAtIndex:index];
        KTPhotoView *tempPhotoView = [[KTPhotoView alloc] initWithFrame:frame];
        [tempPhotoView setParent:self];
        [tempPhotoView setIndex:index];
        [tempPhotoView setBackgroundColor:[UIColor clearColor]];
        
        // Set the photo image.
//        if (dataSource_) {
//            if ([dataSource_ respondsToSelector:@selector(imageAtIndex:photoView:)] == NO) {
//                UIImage *image = [dataSource_ imageAtIndex:index];
//                [photoView setImage:image];
//            } else {
//                [dataSource_ imageAtIndex:index photoView:photoView];
//            }
//        }
        if(appsList!=nil){
            LQGameInfo* info = [appsList objectAtIndex:index];
            [tempPhotoView setImageUrl:info.downloadUrl];
        }
        
        [scrollView addSubview:tempPhotoView];
        [photoViews replaceObjectAtIndex:index withObject:tempPhotoView];
    } else {
        // Turn off zooming.
        [currentPhotoView turnOffZoom];
    }
}

- (void)unloadPhoto:(NSInteger)index
{
    if (index < 0 || index >= appsList.count) {
        return;
    }
    
    id currentPhotoView = [photoViews objectAtIndex:index];
    if ([currentPhotoView isKindOfClass:[KTPhotoView class]]) {
        [currentPhotoView removeFromSuperview];
        [photoViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
    currentIndex = newIndex;
    
    [self loadPhoto:currentIndex];
    [self loadPhoto:currentIndex + 1];
    [self loadPhoto:currentIndex - 1];
    [self unloadPhoto:currentIndex + 2];
    [self unloadPhoto:currentIndex - 2];
    
    [self setTitleWithCurrentPhotoIndex];
    //[self toggleNavButtons];
    if(currentIndex+4>appsList.count)
        [self loadMoreData];

}

#pragma mark -
#pragma mark Frame calculations
#define PADDING  0

- (CGRect)frameForPagingScrollView 
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = [scrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (void)setTitleWithCurrentPhotoIndex 
{
    LQGameInfo* info = [appsList objectAtIndex:currentIndex];
    self.title.text = info.name;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView 
{
    CGFloat pageWidth = aScrollView.frame.size.width;
    float fractionalPage = aScrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
	if (page != currentIndex && page>0 && page<appsList.count) {
		[self setCurrentIndex:page];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    if(hidden==NO)
        [self hideToolBar:0.3];
    dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dragging = NO;
}

#pragma mark -
#pragma mark Load more data
- (void)loadMoreData{
    if(self.moreUrl != nil){
        [self.client loadAppMoreListCommon:self.moreUrl];
    }
}

- (void)loadMoreApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    
    int oldAppsCount = 0;   
    if(self.appsList ==nil){
        self.appsList = items;
    }
    else {
        oldAppsCount = self.appsList.count;
        [self.appsList addObjectsFromArray:items];
    }
    
    [self setScrollViewContentSize];
    [self updatePageViews:items.count];
    
}

- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME_MORE:  
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadMoreApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];
            }
            break;
            
        default:
            break;
    }
    
}

@end
