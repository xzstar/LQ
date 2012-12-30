//
//  LQDownloadViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import "LQDownloadViewController.h"
#import "LQInstaller.h"
#import "LQDownloadTableViewCell.h"
#import "LQInstallTableViewCell.h"

@interface LQDownloadViewController ()
@property (strong) NSArray* installedApplications;

@end

@implementation LQDownloadViewController

@synthesize installedApplications;
@synthesize applicaitonView;

- (void)loadViews{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
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
    self.installedApplications = results;
    [self.applicaitonView reloadData];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return LocalString(@"download.section.downloading");
        case 1:
            return LocalString(@"download.section.downloaded");
        case 2:
            return LocalString(@"download.section.installed");
        default:
            break;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [LQDownloadManager sharedInstance].downloadGames.count;
        case 1:
            return [LQDownloadManager sharedInstance].completedGames.count;
        case 2:
            return [LQDownloadManager sharedInstance].installedGames.count;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            LQDownloadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"download"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DownloadTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            QYXDownloadObject* obj  = [[LQDownloadManager sharedInstance].downloadGames objectAtIndex:indexPath.row];
            cell.downloadObject = obj;
            
            return cell;
        }
        case 1:
        {
            LQInstallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"install"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InstallTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            QYXDownloadObject* obj  = [[LQDownloadManager sharedInstance].completedGames objectAtIndex:indexPath.row];
            cell.downloadObject = obj;
            
            return cell;
        }
            break;
        case 2:
        {
            LQInstallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"install"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InstallTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            QYXDownloadObject* obj  = [[LQDownloadManager sharedInstance].installedGames objectAtIndex:indexPath.row];
            cell.downloadObject = obj;
            
            return cell;
        }
        default:
            break;
    }
    
    return nil;
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

//- (IBAction)onBack:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}
@end
