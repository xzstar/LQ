//
//  QYXSecondViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQHistoryViewController.h"
#import "LQHistoryTableViewCell.h"
#import "LQHistoryTableSectionHeader.h"

#import "LQDetailViewController.h"

#import "QYXData.h"

@interface LQHistoryViewController ()
@property (strong) NSMutableArray* histories;

@end

@implementation LQHistoryViewController
@synthesize histories;
@synthesize historyView;

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
    self.historyView.hidden = YES;
    
    //Tricks to add background view for table header
   UIImageView* imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg.jpg"]];
    CGRect frame = self.historyView.bounds;
    frame.origin.y = -frame.size.height;
    frame.origin.x = 0;
    imageView.frame = frame;
    [self.historyView addSubview:imageView];
}

#pragma mark - Data Init
- (void)loadData{
    [super loadData];
    
    self.histories = [NSMutableArray array];
    
    [self startLoading];
    NSDate* today = [[NSDate date] dateByAddingTimeInterval:-3600*24];
    
    [self.client loadHistory:today days:7];
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
    NSDictionary* dayGame = [self.histories objectAtIndex:indexPath.section];
    NSArray* games = [dayGame objectForKey:@"items"];

    [self performSegueWithIdentifier:@"gotoDetail" sender:[games objectAtIndex:indexPath.row]];
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

#pragma mark - segue preparation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoDetail"]){
        //设置对象
        LQDetailViewController* detailController = segue.destinationViewController;
        LQGameInfo* gameInfo = sender;
        detailController.gameId = gameInfo.gameId;
    }
}


#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
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
    [self endLoading];
    if (self.histories.count > 0){
        [super handleNetworkErrorHint];
    }else{
        [super handleNetworkError:error];
    }
}

@end
