//
//  LQCommonTableViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQCommonTableViewController.h"
#import "LQHistoryTableViewCell.h"
#import "LQDetailTablesController.h"
#import "LQGameMoreItemTableViewCell.h"
#import "SVPullToRefresh.h"
#define NAVIGATIONBAR_HEIGHT 44.0

@interface LQCommonTableViewController (){
}
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UIWindow* shadowView;
@property (nonatomic, strong) NSTimer* animationTimer;
@end

@implementation LQCommonTableViewController
@synthesize errorView;
@synthesize shadowView;
@synthesize animationTimer;
@synthesize nodeId,orderBy,listOperator,keywords;
@synthesize appsList;
@synthesize selectedRow,selectedSection;
@synthesize parent;
@synthesize moreToLoad;
@synthesize moreUrl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        [self loadViews];
//        [self loadData];
        //[self loadCommon];

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         listOperator:(NSString *)aListOperator
             keywords:(NSString*)aKeywords{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;
        listOperator = aListOperator;
        keywords = aKeywords;
        //[self loadCommon];

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         listOperator:(NSString *)aListOperator
               nodeId:(NSString*) aNodeId
              orderBy:(NSString*) aOrderBy
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;
        listOperator = aListOperator;
        nodeId = aNodeId;
        orderBy = aOrderBy;
        //[self loadCommon];
    }
    return self;
}

- (void)loadCommon{
    [self loadViews];
    if (!_dataLoaded) {
        _dataLoaded = YES;
        [self loadData];
    }
    
    __unsafe_unretained LQCommonTableViewController* weakSelf = self;
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [weakSelf loadData];
        });
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [weakSelf loadMoreData];
        });
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadCommon];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_dataLoaded) {
        _dataLoaded = YES;
        [self loadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];

}

- (void)viewDidDisappear:(BOOL)animated{
    [self endLoading];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return appsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    //LQHistoryTableViewCell* cell;
    if(indexPath.section == selectedSection &&
       indexPath.row == selectedRow){
        LQGameMoreItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"moreitem"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQGameMoreItemTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.gameInfo = [appsList objectAtIndex:indexPath.row];
        
        [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:indexPath.row];
        [cell addLeftButtonTarget:self action:@selector(onGameDownloadAndInstall:) tag:indexPath.row];
        [cell addMiddleButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
        [cell addRightButtonTarget:self action:@selector(onGameDetail:) tag:indexPath.row];
        return cell;

    }
    
    else{
        LQHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.gameInfo = [appsList objectAtIndex:indexPath.row];
        
        [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:indexPath.row];
        return cell;

    }
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(selectedRow!= indexPath.row
        /*&& selectedSection!=indexPath.section*/){
        selectedRow = indexPath.row;
        selectedSection = indexPath.section;    
    }
    else {
        selectedRow = -1;
        selectedSection = -1;  
    }
    [self.tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (LQClient*)client{
    if (_client == nil){
        _client = [[LQClient alloc] initWithDelegate:self];
    }
    
    return _client;
}

- (void)loadViews{
//    if(headerView == nil)  
//    {  
//        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];  
//        
//        view.delegate = self;  
//        [self.view addSubview:view];  
//        headerView = view;  
//    }  
//    [headerView refreshLastUpdatedDate]; 
}

- (void)loadData{
    if(appsList==nil)
        appsList = [NSMutableArray array];
    else {
        [appsList removeAllObjects];
    }
    [self startLoading];
    selectedRow = -1;
    selectedSection = -1;
}

- (void)loadMoreData{
    //[self startLoading];
    
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

- (void)handleNetworkOK{
//    [self.errorView removeFromSuperview];
//    self.errorView = nil;
}

- (void)handleNetworkErrorHint{
    [LocalString(@"network.error") showToastAsInfo];
}

- (void)handleNetworkError:(LQClientError*)error{
//    [self.errorView removeFromSuperview];
//    CGRect frame = self.view.bounds;
//    frame.origin.y += NAVIGATIONBAR_HEIGHT;
//    frame.size.height -= NAVIGATIONBAR_HEIGHT;
//    self.errorView = [[UIView alloc] initWithFrame:frame];
//    self.errorView.backgroundColor = [UIColor whiteColor];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"err_network.png"]];
//    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
//    [self.errorView addSubview:imageView];
//    [self.view addSubview:self.errorView];
}

- (void)handleNoNetwork{
//    [self.errorView removeFromSuperview];
//    CGRect frame = self.view.bounds;
//    frame.origin.y += NAVIGATIONBAR_HEIGHT;
//    frame.size.height -= NAVIGATIONBAR_HEIGHT;
//    self.errorView = [[UIView alloc] initWithFrame:frame];
//    self.errorView.backgroundColor = [UIColor whiteColor];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_network.png"]];
//    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
//    [self.errorView addSubview:imageView];
//    [self.view addSubview:self.errorView];
}


- (void)client:(LQClientBase*)client didFailExecution:(LQClientError*)error{
    [self endLoading];
    [self handleNetworkError:error];
}

#pragma mark - load apps 
- (void)loadApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
        
    appsList = items;
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];

}

- (void)loadMoreApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    
    int oldAppsCount = 0;   
    int addAppsCount = apps.count;
    if(appsList ==nil){
        appsList = items;
    }
    else {
        oldAppsCount = appsList.count;
        [appsList addObjectsFromArray:items];
    }
    
    __unsafe_unretained LQCommonTableViewController* weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for(int i=oldAppsCount;i<(oldAppsCount+addAppsCount);i++)
        {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        if(indexPaths.count>0){
            [weakSelf.tableView beginUpdates];
            
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
        }
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
    
}


- (void) onGameDetail:(id)sender{
    UIButton *button = sender;
    int row = button.tag;
    LQGameInfo* gameInfo = [appsList objectAtIndex:row];

   LQDetailTablesController *controller = [[LQDetailTablesController alloc] initWithNibName:@"LQTablesController" bundle:nil];
    controller.gameId = gameInfo.gameId;
    
    if(parent!=nil){
        [parent.navigationController pushViewController:controller animated:YES];
    }
    else
        [self.navigationController pushViewController:controller animated:YES];    
}

- (void) onGameDownloadAndInstall:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* info = [appsList objectAtIndex:row];
    [[LQDownloadManager sharedInstance] commonAction:info installAfterDownloaded:YES];
//    int gameId = info.gameId;
//    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
//    switch (status) {
//        case kQYXDSFailed:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
//            break;
//            //        case kQYXDSCompleted:
//            //        case kQYXDSInstalling:
//            //            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
//            //            break;
//            //        case kQYXDSPaused:
//            //            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
//            //            break;
//            //        case kQYXDSRunning:
//            //            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
//            //            break;
//        case kQYXDSNotFound:
//            if(info!=nil)
//                [[LQDownloadManager sharedInstance] addToDownloadQueue:info installAfterDownloaded:YES];
//            
//            break;
//            //        case kQYXDSInstalled:
//            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
//            //            break;
//        default:
//            break;
//    }
}


- (void) onGameDownload:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* info = [appsList objectAtIndex:row];
    [[LQDownloadManager sharedInstance] commonAction:info installAfterDownloaded:YES];
//    int gameId = info.gameId;
//    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
//    switch (status) {
//        case kQYXDSFailed:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
//            break;
//            //        case kQYXDSCompleted:
//            //        case kQYXDSInstalling:
//            //            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
//            //            break;
//            //        case kQYXDSPaused:
//            //            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
//            //            break;
//            //        case kQYXDSRunning:
//            //            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
//            //            break;
//        case kQYXDSNotFound:
//            if(info!=nil)
//                [[LQDownloadManager sharedInstance] addToDownloadQueue:info installAfterDownloaded:NO];
//            
//            break;
//            //        case kQYXDSInstalled:
//            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
//            //            break;
//        default:
//            break;
//    }
}

//#pragma mark - EGORefreshTableView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
//    if (moreToLoad){
//        [headerView egoRefreshScrollViewDidScroll:scrollView];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (moreToLoad){
//        [headerView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//}
//
//
//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    //[self loadCurrentCategory];
//    [self loadMoreData];
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
//	return _reloading; // should return if data source model is reloading
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
//	return [NSDate date]; // should return date data source was last changed
//}
//
//- (float)egoRefreshTableHeaderTableViewHeight:(EGORefreshTableHeaderView*)view{
//    return self.view.frame.size.height;
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceNeedLoading:(EGORefreshTableHeaderView*)view{
//    return moreToLoad;
//}
@end
