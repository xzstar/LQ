//
//  LQDownloadedWallpaperViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQDownloadedWallpaperViewController.h"
#import "LQInstaller.h"
#import "LQDownloadTableViewCell.h"
#import "LQInstallTableViewCell.h"
#import "LQWallpaperCell.h"
#import "LQWallpaperViewController.h"
extern NSString* const kNotificationDownloadComplete;
#define WALLPAPER_COUNT_PERLINE 3
@interface LQDownloadedWallpaperViewController ()

@end

@implementation LQDownloadedWallpaperViewController

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
    if(appsList ==nil)
        appsList = [NSMutableArray array];
    [appsList removeAllObjects];
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"wallpaper"]) {
            [appsList addObject:obj.gameInfo];
        }
        
    }
    
    [self.applicaitonView reloadData];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (appsList.count%WALLPAPER_COUNT_PERLINE)==0?
    appsList.count/WALLPAPER_COUNT_PERLINE:((appsList.count/WALLPAPER_COUNT_PERLINE)+1);
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
    for(int i=startIndex;i<appsList.count&&i<(WALLPAPER_COUNT_PERLINE+startIndex);i++){
        LQGameInfo *item = [appsList objectAtIndex:i];
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
    LQGameInfo *item = [appsList objectAtIndex:tag];
    
    controller.imageUrl = item.downloadUrl;
    controller.titleString = item.name;
    controller.gameInfo = item;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
