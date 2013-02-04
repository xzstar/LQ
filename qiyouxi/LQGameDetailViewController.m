//
//  LQGameDetailViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQGameDetailViewController.h"
#import "LQCommentTableViewCell.h"
#import "LQImageBrowseViewController.h"
#import "LQPostCommentViewController.h"
#import "SVPullToRefresh.h"
#import "LQUtilities.h"
@interface LQGameDetailViewController (){
    NSString* moreUrl;
}
@property (strong) NSMutableArray* gameInfoUserComments; //在详情页显示评论
@property (strong) NSString* moreUrl;
@property (nonatomic, copy) void (^switchPageActionHandler)(int);

@end

@implementation LQGameDetailViewController
@synthesize delegate;
@synthesize gameId;
@synthesize gameInfo;
@synthesize gameInfoUserComments;
@synthesize mainScrollView;

@synthesize gameVersion,gameType,gameScore,gameDownloadCount,gameBaseInfoPanel,gameSize;
@synthesize installNowButton,downloadNowButton;
@synthesize weiboShareButton,qqShareButton;
@synthesize gamePhotoInfoPanel;
@synthesize gameScore2;
@synthesize gameInfoCommentTableView;
@synthesize postCommentButton;

@synthesize gameIconView, gameTitleLabel;
@synthesize commentLabel;
@synthesize screenShotsView;

@synthesize dummyCell;
@synthesize moreUrl;
@synthesize switchPageActionHandler;

#pragma mark - View Init
- (void)loadViews{
    
}

- (void)viewDidLoad{
    // a page is the width of the scroll view
    mainScrollView.pagingEnabled = NO;
    //mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, 1000);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = YES;
    mainScrollView.scrollsToTop = NO;
    
    [gameBaseInfoPanel removeFromSuperview];
    int height = 0;
    CGRect frame = gameBaseInfoPanel.frame;
    height+=frame.size.height;    
    [mainScrollView addSubview:gameBaseInfoPanel];
    
    [gamePhotoInfoPanel removeFromSuperview];
    frame = gamePhotoInfoPanel.frame;
    frame.origin.y= height+frame.origin.y;
    height+=frame.size.height;
    gamePhotoInfoPanel.frame = frame;
    [mainScrollView addSubview:gamePhotoInfoPanel];
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, height);
    [mainScrollView layoutIfNeeded];
    
    self.gameInfoUserComments = [[NSMutableArray alloc]init];
    [self loadData];

}
-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //[self.userCommentsView reloadData];
}

#pragma mark - Data Init
- (void)loadData{
    [super loadData];
    [self startLoading];
    [self.client loadGameInfo:self.gameId];
}


- (void)loadMoreData{
    
    if(self.moreUrl != nil){
        [self.client loadAppMoreListCommon:self.moreUrl];
    }
    else {
        //[self endLoading];
        [self.gameInfoCommentTableView.infiniteScrollingView stopAnimating];
        return;
    }
    

}
- (void)loadGameBaseInfo{
    self.gameTitleLabel.text = self.gameInfo.name;
    
    int size= [self.gameInfo.size intValue];
    float sizeMB= (float)size/(1024*1024);
    [self.gameIconView loadImageUrl:self.gameInfo.icon defaultImage:DEFAULT_GAME_ICON];

    self.gameSize.text =  [NSString stringWithFormat:@"大小:%.2fMB",sizeMB];
 
    self.gameVersion.text = [NSString stringWithFormat:@"版本:%@",gameInfo.versionCode];
    self.gameScore.text = [NSString stringWithFormat:@"%@分",gameInfo.rating];
    self.gameType.text = [NSString stringWithFormat:@"标签:%@", gameInfo.tags];
    self.gameDownloadCount.text = [NSString stringWithFormat:@"下载:%@", gameInfo.downloadNumber];
    self.commentLabel.text = gameInfo.intro;
    //文字居中显示  
    commentLabel.textAlignment = UITextAlignmentLeft;  
    //自动折行设置  
    commentLabel.lineBreakMode = UILineBreakModeWordWrap;  
    commentLabel.numberOfLines = 0;  
    //[self.commentLabel autowrap:self.commentLabelMaxHeight];

}

- (void)loadGamePhotoInfo{
    self.screenShotsView.delegate = self;
    self.screenShotsView.needRotate = NO;
    self.screenShotsView.imageUrls = self.gameInfo.screenShotsSmall;
    self.gameScore2.text = [NSString stringWithFormat:@"%@分",gameInfo.rating];
    
}
- (void)loadGameInfo:(NSDictionary*)result{
    self.gameInfo = [[LQGameInfo alloc] initWithAPIResult:result];
    
    [self loadGameBaseInfo];
    [self loadGamePhotoInfo];   
    [self loadGameInfoComments:[result objectForKey:@"arr_comment"]];
    moreUrl = [result objectForKey:@"more_comment"];  
}

- (void)loadGameInfoComments:(NSArray*) result{
    [self.gameInfoUserComments removeAllObjects];
    [self.gameInfoUserComments addObjectsFromArray: result];
    [self.gameInfoCommentTableView reloadData];
    
    if(self.gameInfoUserComments.count == 0){
        self.gameInfoCommentTableView.hidden = YES;
        self.postCommentButton.hidden = YES;
        CGSize size = mainScrollView.contentSize;
        size.height -= 2*gameInfoCommentTableView.frame.size.height/3;
        mainScrollView.contentSize = size;
        [mainScrollView layoutIfNeeded];

    }
    else{
        self.gameInfoCommentTableView.hidden = NO;
        self.postCommentButton.hidden = NO;

    }
}


- (IBAction)onQQWeibo:(id)sender{
    _krShare  = [KRShare sharedInstanceWithTarget:KRShareTargetTencentblog];
    _krShare.delegate = self;
    [_krShare logIn];
    
}

- (IBAction)onSinaWeibo:(id)sender{
    _krShare  = [KRShare sharedInstanceWithTarget:KRShareTargetSinablog];
    _krShare.delegate = self;
    [_krShare logIn];
    
}

#pragma mark - Actions

- (void) addSwitchPageWithActionHandler:(void (^)(int))actionHandler{
    self.switchPageActionHandler = actionHandler;
}
//- (IBAction)onShowDetail:(id)sender{
//    [self.commentsPanel removeFromSuperview];
//    [self.contentView addSubview:self.gameInfoPanel];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    CGPoint center = self.buttonUnderline.center;
//    center.x = self.detailButton.center.x;
//    self.buttonUnderline.center = center;
//    [UIView commitAnimations];
//}

- (IBAction)onShowComments:(id)sender{
//    if (self.switchPageActionHandler) {
//        self.switchPageActionHandler(1);
//    }
    if(delegate)
    if([delegate respondsToSelector:@selector(switchToCommentPage)]){
        [delegate performSelectorOnMainThread:@selector(switchToCommentPage) 
                                withObject:nil
                                waitUntilDone:NO];
    }
}

- (IBAction)onGameDownload:(id)sender{
    //int gameId = gameInfo.gameId;
    
    [[LQDownloadManager sharedInstance] commonAction:gameInfo installAfterDownloaded:NO];
    
//    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
//    switch (status) {
//        case kQYXDSFailed:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
//            break;
//        case kQYXDSCompleted:
//        case kQYXDSInstalling:           
//            [[NSString stringWithFormat:LocalString(@"info.download.downloaded"), gameInfo.name] showToastAsInfo];
//            break;
//        case kQYXDSPaused:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
//            break;
//        case kQYXDSRunning:
//            [[NSString stringWithFormat:LocalString(@"info.download.running"), gameInfo.name] showToastAsInfo];
//            break;
//        case kQYXDSNotFound:
//            if(gameInfo!=nil)
//                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:NO];
//            
//            break;
//            //        case kQYXDSInstalled:
//            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
//            //            break;
//        default:
//            break;
//    }
}
- (IBAction)onGameDownloadAndInstall:(id)sender{
    [[LQDownloadManager sharedInstance] commonAction:gameInfo installAfterDownloaded:YES];
    //int gameId = gameInfo.gameId;
//    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
//    QYXDownloadObject* obj =[[LQDownloadManager sharedInstance] objectWithGameId:gameId];
//    if(obj!=nil)           
//        obj.installAfterDownloaded = YES;
//
//    switch (status) {
//        case kQYXDSFailed:
//            obj.installAfterDownloaded = YES;
//            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
//            break;
//        case kQYXDSCompleted:
//        case kQYXDSInstalling:
//            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
//            break;
//        case kQYXDSPaused:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
//            break;
//        case kQYXDSRunning:
//             [[NSString stringWithFormat:LocalString(@"info.download.running"), gameInfo.name] showToastAsInfo];            break;
//        case kQYXDSNotFound:
//            if(gameInfo!=nil)
//                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:YES];
//            
//            break;
//            //        case kQYXDSInstalled:
//            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
//            //            break;
//        default:
//            break;
//    }

}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_GETGAMEINFO:
            [self endLoading];
            [self loadGameInfo:[result objectForKey:@"appinfo"]];
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    switch (error.command) {
        case C_COMMAND_GETGAMEINFO:
            [self endLoading];
            [super handleNetworkError:error];
            break;
        case C_COMMAND_GETUSERCOMMENTS:
            [self endLoading];
            [super handleNetworkErrorHint];
        default:
            break;
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameInfoUserComments.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    
    NSDictionary* item = [self.gameInfoUserComments objectAtIndex:indexPath.row];
    cell.comment = item;
    
       
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    if (self.dummyCell == nil){
//        self.dummyCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] objectAtIndex:0];
//        
//    }
//    
//    NSDictionary* item = [self.userComments objectAtIndex:indexPath.row];
//    self.dummyCell.comment = item;
//    
//    [self.dummyCell layoutSubviews];
//    
//    CGSize rowSize = [self.dummyCell sizeThatFits:CGSizeZero];
//    return rowSize.height;    
}



#pragma mark - 
- (void)QYXAdvertiseView:(LQAdvertiseView*)advertiseView selectPage:(int)page{
//    [self performSegueWithIdentifier:@"gotoBrowse" sender:[NSNumber numberWithInt:page]];
}

#pragma mark - SinaWeibo Delegate
- (void)removeAuthData
{
    if(_krShare.shareTarget == KRShareTargetSinablog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Sina"];
    }
    else if(_krShare.shareTarget == KRShareTargetTencentblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Tencent"];
    }
//    else if(_krShare.shareTarget == KRShareTargetDoubanblog)
//    {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Douban"];
//    }
//    else if(_krShare.shareTarget == KRShareTargetRenrenblog)
//    {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Renren"];
//    }
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _krShare.currentInfo.accessToken, @"AccessTokenKey",
                              _krShare.currentInfo.expirationDate, @"ExpirationDateKey",
                              _krShare.currentInfo.userID, @"UserIDKey",
                              _krShare.currentInfo.refreshToken, @"refresh_token", nil];
    
    if(_krShare.shareTarget == KRShareTargetSinablog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Sina"];
    }
    else if(_krShare.shareTarget == KRShareTargetTencentblog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Tencent"];
    }
//    else if(_krShare.shareTarget == KRShareTargetDoubanblog)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Douban"];
//    }
//    else if(_krShare.shareTarget == KRShareTargetRenrenblog)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Renren"];
//    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)KRShareDidLogIn:(KRShare *)krShare
{
    [self storeAuthData];
    
    NSString* shareText = [NSString stringWithFormat:@"%@可以从%@下载，点开链接后再点下载按钮就可以啦", gameInfo.name, gameInfo.shareUri];
    
    UIImage* image = gameIconView.realImage;
    if(image == nil)
        image =[UIImage imageNamed:@"icon.png"];
    
    if(krShare.shareTarget == KRShareTargetSinablog)
    {
                [_krShare requestWithURL:@"statuses/upload.json"
                                  params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          shareText, @"status",
                                          image, @"pic", nil]
                              httpMethod:@"POST"
                                delegate:self];
        
//        [_krShare requestWithURL:@"statuses/update.json"
//                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                  @"test 这是我分享", @"status",
//                                  nil]
//                      httpMethod:@"POST"
//                        delegate:self];
    }
    
    if(krShare.shareTarget == KRShareTargetTencentblog)
    {
                [krShare requestWithURL:@"t/add_pic"
                                 params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         shareText, @"content",
                                         @"json",@"format",
                                         //@"221.232.172.30",@"clientip",
                                         @"all",@"scope",
                                         krShare.currentInfo.userID,@"openid",
                                         @"ios-sdk-2.0-publish",@"appfrom",
                                         @"0",@"compatibleflag",
                                         @"2.a",@"oauth_version",
                                         kTencentWeiboAppKey,@"oauth_consumer_key",
                                         image, @"pic", nil]
                             httpMethod:@"POST"
                               delegate:self];
//        [krShare requestWithURL:@"t/add"
//                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"这是我的分享", @"content",
//                                 @"json",@"format",
//                                 @"",@"clientip",
//                                 @"all",@"scope",
//                                 krShare.userID,@"openid",
//                                 @"ios-sdk-2.0-publish",@"appfrom",
//                                 @"0",@"compatibleflag",
//                                 @"2.a",@"oauth_version",
//                                 kTencentWeiboAppKey,@"oauth_consumer_key",
//                                 nil]
//                     httpMethod:@"POST"
//                       delegate:self];    
    }
//    if(krShare.shareTarget == KRShareTargetDoubanblog)
//    {
//        [krShare requestWithURL:@"shuo/v2/statuses"
//                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"这是我分享的图片", @"text",
//                                 kDoubanBroadAppKey,@"source",
//                                 [UIImage imageNamed:@"Default.png"], @"image", nil]
//                     httpMethod:@"POST"
//                       delegate:self];
//    }
//    if(krShare.shareTarget == KRShareTargetRenrenblog)
//    {
//        [krShare requestWithURL:@"restserver.do"
//                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"1.0",@"v",
//                                 @"这是我分享的图片", @"caption",
//                                 @"json",@"format",
//                                 @"method",@"photos.upload",
//                                 @"file",@"upload",
//                                 kRenrenBroadAppKey,@"api_key",
//                                 [UIImage imageNamed:@"Default.png"], @"image", nil]
//                     httpMethod:@"POST"
//                       delegate:self];
//    }
    
}

- (void)KRShareDidLogOut:(KRShare *)sinaweibo
{
    [self removeAuthData];
}

- (void)KRShareLogInDidCancel:(KRShare *)sinaweibo
{
}

- (void)krShare:(KRShare *)krShare logInDidFailWithError:(NSError *)error
{
}

- (void)krShare:(KRShare *)krShare accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
}

- (void)KRShareWillBeginRequest:(KRShareRequest *)request
{
    //_loadingView.hidden = NO;
}

-(void)request:(KRShareRequest *)request didFailWithError:(NSError *)error
{
    //_loadingView.hidden = YES;
    
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [LQUtilities AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        [LQUtilities AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        [LQUtilities AlertWithMessage:@"发表人人网相片失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
}


- (void)request:(KRShareRequest *)request didFinishLoadingWithResult:(id)result
{
    //_loadingView.hidden = YES;
    
    //新浪微博响应
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        if([[result objectForKey:@"error_code"] intValue]==20019)
        {
            [LQUtilities AlertWithMessage:@"发送频率过高，请您过会再发"];
        }
        else if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发送微博成功"];
        }
        else{
            [LQUtilities AlertWithMessage:[NSString stringWithFormat:@"sina code %@",
             [result objectForKey:@"error"]]];
        }
    }
    //腾讯微博响应
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        if([[result objectForKey:@"errcode"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表微博成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表微博失败"];
        }
    }
    //豆瓣说响应
    else if ([request.url hasSuffix:@"shuo/v2/statuses"])
    {
        if([[result objectForKey:@"code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表豆瓣说成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表豆瓣说失败"];
        }
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表人人网相片成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表人人网相片失败"];
        }
    }
}
@end
