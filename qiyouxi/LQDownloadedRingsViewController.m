//
//  LQDownloadedRingsViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQDownloadedRingsViewController.h"
#import "LQInstaller.h"
#import "LQDownloadTableViewCell.h"
#import "LQInstallTableViewCell.h"
#import "LQRankSectionHeader.h"
#import "AudioCell.h"
#import "AudioPlayer.h"
#import "AudioMoreItemCell.h"

extern NSString* const kNotificationDownloadComplete;
@interface LQDownloadedRingsViewController ()

@end

@implementation LQDownloadedRingsViewController
@synthesize applicaitonView;
@synthesize selectedRow;

- (void)loadViews{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
    self.selectedRow = -1;

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateStatus:)
												 name:kNotificationDownloadComplete
											   object:nil];
    
    [self updateStatus:nil];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
}
- (void) viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)updateStatus:(NSNotification*)notification{
    if(appsList ==nil)
        appsList = [NSMutableArray array];
    [appsList removeAllObjects];
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        LQGameInfo* info = obj.gameInfo;
        if ([obj.gameInfo.fileType isEqualToString: @"sms_ring"] ||
            [obj.gameInfo.fileType isEqualToString: @"tel_ring"]) {
            [appsList addObject:obj.gameInfo];
        }
        
    }
    
    [self.applicaitonView reloadData];
}
//
//- (void)updateStatus:(NSTimer*)timer{
//    [appsList removeAllObjects];
//    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
//        LQGameInfo* info = obj.gameInfo;
//        if ([obj.gameInfo.fileType isEqualToString: @"sms_ring"] ||
//            [obj.gameInfo.fileType isEqualToString: @"tel_ring"]) {
//            [appsList addObject:obj.gameInfo];
//        }
//        
//    }
//    
//    [self.applicaitonView reloadData];
//}

- (void)loadData{
    selectedRow = -1;
    if(appsList == nil)
        appsList = [NSMutableArray array];
    [self startLoading];
    [self performSelectorInBackground:@selector(loadAppThread) withObject:nil];
}

- (void)loadAppThread{
    NSMutableArray* results = [NSMutableArray array];
    [[LQInstaller defaultInstaller] IPABrowse:results];
    [self performSelectorOnMainThread:@selector(onDoneLoad:) withObject:results waitUntilDone:NO];
}

- (void)onDoneLoad:(NSArray*)results{
    [self endLoading];
    //self.installedApplications = results;
    [self.applicaitonView reloadData];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{    
    return appsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AudioCell *cell;
    
    if(indexPath.row == self.selectedRow){
        AudioMoreItemCell* morecell = [tableView dequeueReusableCellWithIdentifier:@"AudioMoreItemCell"];
        if (morecell == nil){
            morecell = [[[NSBundle mainBundle] loadNibNamed:@"AudioMoreItemCell" owner:self options:nil] objectAtIndex:0];
            [morecell configurePlayerButton];
         
            [morecell setButtonsName:@"立刻安装" middle:nil right:nil];
            
//            [morecell addLeftButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
          
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
    LQGameInfo *item = [appsList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.name;
    cell.artistLabel.text = item.tags;
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    int height = cell.frame.size.height;
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       if(selectedRow!= indexPath.row){
            selectedRow = indexPath.row;
        }
        else {
            selectedRow = -1;
        }
        [self.applicaitonView reloadData];
    
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
