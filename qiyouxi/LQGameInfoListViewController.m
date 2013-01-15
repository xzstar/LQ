//
//  LQGameInfoListViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ科技有限公司. All rights reserved.
//

#import "LQGameInfoListViewController.h"
#import "LQGameDetailViewController.h"
#import "LQWallpaperCell.h"
#import "SVPullToRefresh.h"
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

@implementation LQRingListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
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
        
        _audioPlayer.button = button; 
        _audioPlayer.url = [NSURL URLWithString:item.downloadUrl];
        
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"AudioMoreItemCell"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioMoreItemCell" owner:self options:nil] objectAtIndex:0];
            [cell configurePlayerButton];
            
        }
        
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

@implementation LQWallpaperListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.selectedRow = -1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (self.appsList.count%4)==0?
    self.appsList.count/4:((self.appsList.count/4)+1);
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
    
    int startIndex = indexPath.row * 4;
    // Configure the cell..
    NSMutableArray *itemList = [NSMutableArray array];
    for(int i=startIndex;i<self.appsList.count&&i<(4+startIndex);i++){
        LQGameInfo *item = [self.appsList objectAtIndex:i];
        [itemList addObject:item];
    }
    [cell setButtonInfo:itemList];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}





@end
