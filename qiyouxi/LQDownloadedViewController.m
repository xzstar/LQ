//
//  LQDownloadedViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQDownloadedViewController.h"
#import "LQInstaller.h"
#import "LQDownloadTableViewCell.h"
#import "LQInstallTableViewCell.h"
extern NSString* const kNotificationDownloadComplete;

@interface LQDownloadedViewController ()

@end

@implementation LQDownloadedViewController


@synthesize applicaitonView;

- (void)loadViews{
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
    
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
    if(completedList == nil)
        completedList = [NSMutableArray array];
    if(installedList == nil)
        installedList = [NSMutableArray array];

    [completedList removeAllObjects];
    [installedList removeAllObjects];
    
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"soft"]) {
            [completedList addObject:obj];
        }
        
    }
    
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].installedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"soft"]) {
            [installedList addObject:obj];
        }
        
    }
    
    [self.applicaitonView reloadData];
}



#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return LocalString(@"download.section.downloaded");
        case 1:
            return LocalString(@"download.section.installed");
        default:
            break;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {   
        case 0:
            return completedList.count;
        case 1:
            return installedList.count;
        default:
            break;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            LQInstallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"install"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InstallTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            QYXDownloadObject* obj  = [completedList objectAtIndex:indexPath.row];
            cell.downloadObject = obj;
            
            return cell;
        }
            break;
        case 1:
        {
            LQInstallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"install"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InstallTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            QYXDownloadObject* obj  = [installedList objectAtIndex:indexPath.row];
            cell.downloadObject = obj;
            
            return cell;
        }
        default:
            break;
    }
    
    return nil;

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
