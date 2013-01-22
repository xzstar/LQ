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
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "LQPostCommentViewController.h"
#import "SVPullToRefresh.h"

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

@synthesize gameVender,gameVersion,gameType,gameScore,gameDownloadCount,gameBaseInfoPanel,gameSize;
@synthesize installNowButton,downloadNowButton;
@synthesize weiboShareButton,qqShareButton;
@synthesize gamePhotoInfoPanel;
@synthesize gameScore2;
@synthesize gameInfoCommentTableView;

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
    self.gameSize.text =  [NSString stringWithFormat:@"大小:%.2fMB",sizeMB];
 
    self.gameVersion.text = [NSString stringWithFormat:@"版本:%@",gameInfo.versionCode];
    self.gameScore.text = [NSString stringWithFormat:@"%@分",gameInfo.rating];
    self.gameType.text = [NSString stringWithFormat:@"分类:%@", gameInfo.tags];
    self.gameVender.text = [NSString stringWithFormat:@"开发商:%@",@""];
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
    self.screenShotsView.needRotate = YES;
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

@end
