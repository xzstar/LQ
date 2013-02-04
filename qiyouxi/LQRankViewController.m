//
//  LQRankViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQRankViewController.h"
#import "LQRankSectionHeader.h"
#import "LQWallpaperCell.h"
#import "AudioCell.h"
#import "AudioPlayer.h"
#import "AudioMoreItemCell.h"
#import "SVPullToRefresh.h"
#import "LQWallpaperViewController.h"
@interface LQRankViewController ()

@end

@implementation LQRankViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    if(self.orderBy == nil || self.nodeId == nil){
        [self.tableView.pullToRefreshView stopAnimating];
        [self endLoading];
        return;
    }
    else
        self.appsList = nil;
    //[self startLoading];    
    [self.client loadAppListCommon:self.listOperator nodeid:self.nodeId orderby:self.orderBy];
}

- (void)loadMoreData{
    if(self.moreUrl != nil){
        [self.client loadAppMoreListCommon:self.moreUrl];
    }
    else {
        //[self endLoading];
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];  

            }
            break;
        case C_COMMAND_GETAPPLISTSOFTGAME_MORE:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadMoreApps:[result objectForKey:@"apps"]];
                self.moreUrl = [result objectForKey:@"more_url"];  
                
            }
            break;
        default:
            break;
    }
}
#pragma mark - TableView Data Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    UIView * view = [self tableView:tableView
//             viewForHeaderInSection:section];
//    
//    return view.frame.size.height;
    return 30.0f;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LQRankSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQRankSectionHeader" owner:self options:nil]objectAtIndex:0];
    
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:0];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:1];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:2];
   
    int selectedIndex = 0;
    if(self.orderBy == ORDER_BY_WEEK)
        selectedIndex = 0;
    else if (self.orderBy == ORDER_BY_MONTH)
        selectedIndex = 1;
    else 
        selectedIndex = 2;
    
    [header setButtonStatus:selectedIndex];
    return header;
    
}
-(void) onChangeRank:(id)sender{
    UIButton* button = (UIButton*) sender;
    int tag = button.tag;
    
    if(tag == 0){
        self.orderBy = ORDER_BY_WEEK;
    }
    else if(tag == 1){
        self.orderBy = ORDER_BY_MONTH;
    }
    else {
        self.orderBy = ORDER_BY_TOTAL;
    }
    [self loadData];
}

@end

@implementation LQRingRankViewController
@synthesize curUrl;
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

-(void) viewDidUnload{
    [super viewDidUnload];
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
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
   // static NSString *CellIdentifier = @"AudioCell";
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LQRankSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQRankSectionHeader" owner:self options:nil]objectAtIndex:0];
    
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:0];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:1];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:2];
    
    int selectedIndex = 0;
    if(self.orderBy == ORDER_BY_NEWEST)
        selectedIndex = 0;
    else if (self.orderBy == ORDER_BY_TUIJIAN)
        selectedIndex = 1;
    else 
        selectedIndex = 2;
    
    [header.leftButton setTitle:@"最新" forState:UIControlStateNormal];
    [header.middleButton setTitle:@"推荐" forState:UIControlStateNormal];
    [header.rightButton setTitle:@"排行" forState:UIControlStateNormal];

    [header setButtonStatus:selectedIndex];
    return header;
    
}

-(void) onChangeRank:(id)sender{
    UIButton* button = (UIButton*) sender;
    int tag = button.tag;
    
    if(tag == 0){
        self.orderBy = ORDER_BY_NEWEST;
    }
    else if(tag == 1){
        self.orderBy = ORDER_BY_TUIJIAN;
    }
    else {
        self.orderBy = ORDER_BY_TOTAL;
    }
    [self loadData];
}

@end

@implementation LQWallpaperRankViewController

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}


- (void) onWallpaperClicked:(id) sender{
    UIButton* button = (UIButton*)sender;
    int tag = button.tag;
    LQWallpaperViewController* controller = [[LQWallpaperViewController alloc]initWithNibName:@"LQWallpaperViewController" bundle:nil];
    LQGameInfo *item = [self.appsList objectAtIndex:tag];
    controller.iconImageUrl = item.icon;
    controller.imageUrl = item.downloadUrl;
    controller.titleString = item.name;
    controller.gameInfo = item;
    controller.appsList = self.appsList;
    controller.currentIndex = tag;
    controller.moreUrl = self.moreUrl;
    [self.parent.parentViewController.navigationController pushViewController:controller animated:YES];
}

@end
