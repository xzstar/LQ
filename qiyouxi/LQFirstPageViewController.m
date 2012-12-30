//
//  LQFirstPageViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import "LQFirstPageViewController.h"
#import "LQHistoryTableViewCell.h"
#import "LQHistoryTableSectionHeader.h"
#import "LQGameDetailViewController.h"
@interface LQFirstPageViewController ()
@property (nonatomic, strong) NSDictionary* announcement;
@property (nonatomic, strong) NSArray* advertisements;
@property (nonatomic, strong) NSMutableArray* histories;

- (void)loadData;
@end

@implementation LQFirstPageViewController
@synthesize announcement;
@synthesize advertisements;

@synthesize scrollView;
@synthesize advView;
@synthesize histories;
@synthesize historyView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedIndex = -1;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateDownloadStatus:) name:kQYXDownloadStatusUpdateNotification object:nil];
    
    [self.historyView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQYXDownloadStatusUpdateNotification object:nil];
}

- (void)onUpdateDownloadStatus:(NSNotification*)notification{
    [self performSelectorOnMainThread:@selector(updateDownloadStatus) withObject:nil waitUntilDone:NO];
}

- (void)updateDownloadStatus{
    [self.historyView reloadData];
}


#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
    
    self.advView.delegate = self;
    
    
}

#pragma mark - Data Init
- (void)loadRecommends{
    [self startLoading];
    [self.client loadTodayRecommendation:[NSDate date]];
}

- (void)loadData{
    [super loadData];
    

    [self.client loadTodayAdvs];
    
//    [self loadRecommends];
    
    self.histories = [NSMutableArray array];
    
    [self startLoading];
    NSDate* today = [[NSDate date] dateByAddingTimeInterval:-3600*24];
    
    [self.client loadHistory:today days:7];
    
}

//- (void)loadTodayGames:(NSArray*)games{
//    int index = 0;
//    for (NSDictionary * game in games){
//        LQRecommendButton* button = [sortedButtons objectAtIndex:index];
//        [button setTitle:[game objectForKey:@"name"] forState:UIControlStateNormal];
//        NSDictionary* images = [game objectForKey:@"pic"];
//        NSString* largeImage = [images objectForKey:@"big"];
//        NSString* smallImage = [images objectForKey:@"small"];
//        if (button == self.gameButton1 ||
//            button == self.gameButton5){
//            [button loadImageUrl:largeImage defaultImage:nil];
//        }else{
//            [button loadImageUrl:smallImage defaultImage:nil];
//        }
//        button.tag = [[game objectForKey:@"id"] intValue];
//        index++;
//    }
//}

- (void)loadTodayAdvs:(NSArray*)advs{
    self.advertisements = advs;
    
    NSMutableArray* imageUrls = [NSMutableArray arrayWithCapacity:advs.count];
    for (NSDictionary* adv in advs){
        [imageUrls addObject:[adv objectForKey:@"adv_icon"]];
    }
    
    self.advView.imageUrls = imageUrls;
}
- (void)loadHistoryGames:(NSDictionary*)result{
    self.historyView.hidden = NO;
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    
    NSMutableArray* items = nil;
    int currentDate = 0;
    
    for (NSDictionary* game in [result objectForKey:@"items"]){
        int date = [[game objectForKey:@"idate"] intValue];
        if (date != currentDate){
            if (items != nil){
                [self.histories addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [format dateFromString:[NSString stringWithFormat:@"%.8d", currentDate]], @"date",
                                           items, @"items",
                                           nil]];
            }
            
            currentDate = date;
            items = [NSMutableArray array];
        }
        
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    
    if (items != nil){
        [self.histories addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [format dateFromString:[NSString stringWithFormat:@"%.8d", currentDate]], @"date",
                                   items, @"items",
                                   nil]];
    }
    
    
    [self.historyView reloadData];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.histories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary* dayGame = [self.histories objectAtIndex:section];
    NSArray* games = [dayGame objectForKey:@"items"];
    return games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary* dayGame = [self.histories objectAtIndex:indexPath.section];
    NSArray* games = [dayGame objectForKey:@"items"];
    cell.gameInfo = [games objectAtIndex:indexPath.row];
    [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:0];
    return cell;
}

#pragma mark - TableView Data Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary* dayGame = [self.histories objectAtIndex:section];
    
    LQHistoryTableSectionHeader* header = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableSectionHeader" owner:self options:nil] objectAtIndex:0];
    [header setDate:[dayGame objectForKey:@"date"]];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    [self.historyView reloadData];
    
//    NSDictionary* dayGame = [self.histories objectAtIndex:indexPath.section];
//    NSArray* games = [dayGame objectForKey:@"items"];
    
//    [self performSegueWithIdentifier:@"gotoDetail" sender:[games objectAtIndex:indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [super handleNetworkOK];
    switch (command) {
//        case C_COMMAND_GETRECOMMENDATION:
//            [self endLoading];
//            if ([result isKindOfClass:[NSArray class]]){
//                [self loadTodayGames:result];
//            }
//            break;
        case C_COMMAND_GETTODAYADVS:
            if ([result isKindOfClass:[NSArray class]]){
                [self loadTodayAdvs:result];
            }
            break;
        case C_COMMAND_GETHISTORY:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadHistoryGames:result];
            }
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
//    switch (error.command) {
//        case C_COMMAND_GETRECOMMENDATION:
//            [self endLoading];
//            if (self.advertisements.count > 0){
//                [super handleNetworkErrorHint];
//            }else{
//                [super handleNetworkError:error];
//            }
//            break;
//        case C_COMMAND_GETTODAYADVS:
//        case C_COMMAND_GETANNOUNCEMENT:
//        default:
//            break;
//    }
    [self endLoading];
    if (self.histories.count > 0){
        [super handleNetworkErrorHint];
    }else{
        [super handleNetworkError:error];
    }
}

#pragma mark - Actions


- (IBAction)onReload:(id)sender{
    [self loadRecommends];
    
    if (self.advertisements == nil){
        [self.client loadTodayAdvs];
    }
    
    if (self.announcement == nil){
        [self.client loadAnnouncement];
    }
}

- (void) onGameDetail:(id)sender{
    UIButton *button = sender;
    int tag = button.tag;
    LQGameDetailViewController *controller = [[LQGameDetailViewController alloc] init];
    controller.gameId = tag;
    [self.navigationController pushViewController:controller animated:YES];
    
    

}
@end
