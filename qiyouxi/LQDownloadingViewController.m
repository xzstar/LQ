//
//  LQDownloadingViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQDownloadingViewController.h"
#import "LQInstaller.h"
#import "LQDownloadTableViewCell.h"
#import "LQInstallTableViewCell.h"
@interface LQDownloadingViewController ()

@end

@implementation LQDownloadingViewController

@synthesize applicaitonView;

- (void)loadViews{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
}

- (void)updateStatus:(NSTimer*)timer{
    [self.applicaitonView reloadData];
}

- (void)loadData{
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//            return LocalString(@"download.section.downloading");
//        case 1:
//            return LocalString(@"download.section.downloaded");
//        case 2:
//            return LocalString(@"download.section.installed");
//        default:
//            break;
//    }
//    
//    return @"";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LQDownloadManager sharedInstance].downloadGames.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQDownloadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"download"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DownloadTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    QYXDownloadObject* obj  = [[LQDownloadManager sharedInstance].downloadGames objectAtIndex:indexPath.row];
    cell.downloadObject = obj;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 90;
        case 1:
            return 60;
        case 2:
            return 60;
        default:
            break;
    }
    
    return 0;
}


@end
