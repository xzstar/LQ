//
//  LQGameInfoListViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ科技有限公司. All rights reserved.
//

#import "LQGameInfoListViewController.h"
#import "LQDetailTablesController.h"
#import "LQWallpaperCell.h"
#import "SVPullToRefresh.h"
#import "LQWallpaperViewController.h"
#import "LQTopicSectionHeader.h"
#import "AudioMoreItemCell.h"
#pragma mark -- LQGameInfoListViewController --

@interface LQGameInfoListViewController ()
@end

@implementation LQGameInfoListViewController
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;

    }
    return self;
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



#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
}

#pragma mark - Data Init

- (void)loadData{
    [super loadData];
    if (self.listOperator == @"app_list" ||
        self.listOperator == @"ls_list"  ||
        self.listOperator == @"wallpaper_list"
        ) {
        if(self.orderBy == nil || self.nodeId == nil){
            [self endLoading];
            return;
        }
        [self.client loadAppListCommon:self.listOperator nodeid:self.nodeId orderby:self.orderBy];
        
    }
    else if(self.listOperator == @"app_search"){
        if(self.keywords == nil){
            [self endLoading];
            return;
        }
        [self.client searchAppListCommon:self.listOperator keywords:self.keywords];
            
    }
    else {
        [self endLoading];
        [self.tableView.pullToRefreshView stopAnimating];
        return;
    }
        
}
- (void)loadMoreData{
    //[self startLoading];
    [super loadMoreData];
    if (self.listOperator == @"app_list" ||
        self.listOperator == @"ls_list"  ||
        self.listOperator == @"wallpaper_list"
        ) {
        if(self.moreUrl == nil){
            return;
        }
        [self.client loadAppMoreListCommon:self.moreUrl];
        
    }
    else if(self.listOperator == @"app_search"){
//        if(self.keywords == nil){
//            [self endLoading];
//            return;
//        }
        if(self.moreUrl == nil){
            return;
        }
        [self.client searchAppMoreListCommon:self.moreUrl];
        
    }
    else {
        //[self endLoading];
        [self.tableView.pullToRefreshView stopAnimating];
        return;
    }

}
#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME:
        case C_COMMAND_SEARCH:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];
            }
            break;
        case C_COMMAND_GETAPPLISTSOFTGAME_MORE:  
        case C_COMMAND_SEARCH_MORE:
            //[self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadMoreApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];
            }
            break;

        default:
            break;
    }
    //[self.tableView.pullToRefreshView stopAnimating];

}


@end

#pragma mark -- LQRingListViewController --

@implementation LQRingListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
}

-(void) viewDidUnload{
    [super viewDidUnload];
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
    }
}
- (void)playAudio:(AudioButton *)button
{    
    NSInteger index = button.tag;
    LQGameInfo *item = [self.appsList objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        NSURL* url=[NSURL URLWithString:item.downloadUrl];
        url = [[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"mp3"];;

        _audioPlayer.button = button; 
        _audioPlayer.url = [NSURL URLWithString:url.absoluteString];
        
        [_audioPlayer play];
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 70.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"AudioCell";
    
    AudioCell *cell;
    
    if(indexPath.row == self.selectedRow){
        AudioMoreItemCell* morecell = [tableView dequeueReusableCellWithIdentifier:@"AudioMoreItemCell"];
        if (morecell == nil){
            morecell = [[[NSBundle mainBundle] loadNibNamed:@"AudioMoreItemCell" owner:self options:nil] objectAtIndex:0];
            [morecell configurePlayerButton];
            
            [morecell setButtonsName:@"设置" middle:@"下载" right:nil];
            
            [morecell addLeftButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
            [morecell addMiddleButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
        }
        cell = morecell;
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCell"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioCell" owner:self options:nil] objectAtIndex:0];
            [cell configurePlayerButton];
        }
    }
    
    
    
    // Configure the cell..
    LQGameInfo *item = [self.appsList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.name;
    cell.artistLabel.text = item.tags;
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectedRow!= indexPath.row
       ){
        self.selectedRow = indexPath.row;
    }
    else {
        self.selectedRow = -1;
    }
    [self.tableView reloadData];
    
}



@end

#pragma mark -- LQWallpaperListViewController --

#define WALLPAPER_COUNT_PERLINE 3
@implementation LQWallpaperListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
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
    
    __unsafe_unretained LQCommonTableViewController* weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        int oldRows = [weakSelf.tableView numberOfRowsInSection:0];
        int newRows = (self.appsList.count%3 == 0)? self.appsList.count/3: (self.appsList.count/3) +1;
        
        for(int i=oldRows;i<newRows;i++)
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (self.appsList.count%WALLPAPER_COUNT_PERLINE)==0?
    self.appsList.count/WALLPAPER_COUNT_PERLINE:((self.appsList.count/WALLPAPER_COUNT_PERLINE)+1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 70.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LQWallpaperCell *cell;
 
    cell = [tableView dequeueReusableCellWithIdentifier:@"wallpaper"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LQWallpaperCell" owner:self options:nil] objectAtIndex:0];
    }
    
    int startIndex = indexPath.row * WALLPAPER_COUNT_PERLINE;
    // Configure the cell..
    NSMutableArray *itemList = [NSMutableArray array];
    for(int i=startIndex;i<self.appsList.count&&i<(WALLPAPER_COUNT_PERLINE+startIndex);i++){
        LQGameInfo *item = [self.appsList objectAtIndex:i];
        [itemList addObject:item];
    }
    [cell setButtonInfo:itemList];
    [cell addInfoButtonsTarget:self action:@selector(onWallpaperClicked:) tag:indexPath.row*WALLPAPER_COUNT_PERLINE];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}


- (void) onWallpaperClicked:(id) sender{
    UIButton* button = (UIButton*)sender;
    int tag = button.tag;
    LQWallpaperViewController* controller = [[LQWallpaperViewController alloc]initWithNibName:@"LQWallpaperViewController" bundle:nil];
    LQGameInfo *item = [self.appsList objectAtIndex:tag];

    controller.imageUrl = item.downloadUrl;
    controller.titleString = item.name;
    controller.gameInfo = item;
    [self.parent.parentViewController.navigationController pushViewController:controller animated:YES];
}
@end


@implementation LQRequestListViewController 
@synthesize requestUrl;
@synthesize backButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
           requestUrl:(NSString*) aRequestUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;
        requestUrl = aRequestUrl;
    }
    return self;
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



#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
}

#pragma mark - Data Init

- (void)loadData{
    [super loadData];
    if (self.requestUrl!=nil){
        [self.client loadRequstList:requestUrl];
    }
    else {
        [self endLoading];
        [self.tableView.pullToRefreshView stopAnimating];
        return;
    }
    
}
- (void)loadMoreData{
    //[self startLoading];
    [super loadMoreData];
    if(self.moreUrl != nil){
        [self.client loadAppMoreListCommon:self.moreUrl];
    }
    else {
        //[self endLoading];
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    
}



- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end


@implementation LQTopicDetailViewController
@synthesize iconUrl;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 100.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        LQTopicSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQTopicSectionHeader" owner:self options:nil]objectAtIndex:0];
        [header setTopicHeaderInfo:iconUrl name:name desc:desc];
        return header;
    }
   
    return nil;
}

- (void) loadTopic:(NSDictionary*) topicInfo{
    [self loadApps:[topicInfo objectForKey:@"relate_apps"]];
    NSString* tempIcon = [topicInfo objectForKey:@"icon"];
    
    if(tempIcon != nil && tempIcon.length >0)
        iconUrl = tempIcon;
    name = [topicInfo objectForKey:@"name"];
    desc = [topicInfo objectForKey:@"Intro"];
    
}
#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadTopic:[result objectForKey:@"zhuantiinfo"]];
                self.moreUrl = [result objectForKey:@"more_url"];
            }
            break;
//        case C_COMMAND_GETAPPLISTSOFTGAME_MORE:  
//            if ([result isKindOfClass:[NSDictionary class]]){
//                [self loadMoreApps:[result objectForKey:@"relate_apps"]];
//                self.moreUrl = [result objectForKey:@"more_url"];
//            }
//            break;
            
        default:
            break;
    }
    
}

@end

#pragma mark -- LQAppsListViewController --

@implementation LQAppsListViewController

- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];
            }
            break;
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



@implementation LQRingListWithReqUrlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
}

-(void) viewDidUnload{
    [super viewDidUnload];
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
    }
}

- (void)playAudio:(AudioButton *)button
{    
    NSInteger index = button.tag;
    LQGameInfo *item = [self.appsList objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        NSURL* url=[NSURL URLWithString:item.downloadUrl];
        url = [[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"mp3"];;

        _audioPlayer.button = button; 
        _audioPlayer.url = [NSURL URLWithString:url.absoluteString];
        
        [_audioPlayer play];
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 70.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"AudioCell";
    
    AudioCell *cell;
    
    if(indexPath.row == self.selectedRow){
        AudioMoreItemCell* morecell = [tableView dequeueReusableCellWithIdentifier:@"AudioMoreItemCell"];
        if (morecell == nil){
            morecell = [[[NSBundle mainBundle] loadNibNamed:@"AudioMoreItemCell" owner:self options:nil] objectAtIndex:0];
            [morecell configurePlayerButton];
            
            [morecell setButtonsName:@"设置" middle:@"下载" right:nil];
            
            [morecell addLeftButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
            [morecell addMiddleButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
        }
        cell = morecell;
        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCell"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioCell" owner:self options:nil] objectAtIndex:0];
            [cell configurePlayerButton];
        }
    }
    
    
    
    // Configure the cell..
    LQGameInfo *item = [self.appsList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.name;
    cell.artistLabel.text = item.tags;
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectedRow!= indexPath.row
       ){
        self.selectedRow = indexPath.row;
    }
    else {
        self.selectedRow = -1;
    }
    [self.tableView reloadData];
    
}


@end


@implementation LQWallpaperListWithReqUrlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
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
    
    __unsafe_unretained LQCommonTableViewController* weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        int oldRows = [weakSelf.tableView numberOfRowsInSection:0];
        int newRows = (self.appsList.count%3 == 0)? self.appsList.count/3: (self.appsList.count/3) +1;
        
        for(int i=oldRows;i<newRows;i++)
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (self.appsList.count%WALLPAPER_COUNT_PERLINE)==0?
    self.appsList.count/WALLPAPER_COUNT_PERLINE:((self.appsList.count/WALLPAPER_COUNT_PERLINE)+1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 70.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LQWallpaperCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"wallpaper"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LQWallpaperCell" owner:self options:nil] objectAtIndex:0];
    }
    
    int startIndex = indexPath.row * WALLPAPER_COUNT_PERLINE;
    // Configure the cell..
    NSMutableArray *itemList = [NSMutableArray array];
    for(int i=startIndex;i<self.appsList.count&&i<(WALLPAPER_COUNT_PERLINE+startIndex);i++){
        LQGameInfo *item = [self.appsList objectAtIndex:i];
        [itemList addObject:item];
    }
    [cell setButtonInfo:itemList];
    [cell addInfoButtonsTarget:self action:@selector(onWallpaperClicked:) tag:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}


- (void) onWallpaperClicked:(id) sender{
    UIButton* button = (UIButton*)sender;
    int tag = button.tag;
    LQWallpaperViewController* controller = [[LQWallpaperViewController alloc]initWithNibName:@"LQWallpaperViewController" bundle:nil];
    LQGameInfo *item = [self.appsList objectAtIndex:tag];
    
    controller.imageUrl = item.downloadUrl;
    controller.titleString = item.name;
    controller.gameInfo = item;
    [self.parent.parentViewController.navigationController pushViewController:controller animated:YES];
}

@end