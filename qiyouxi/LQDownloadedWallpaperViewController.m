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
extern NSString* const kNotificationStatusChanged;
extern NSString* const kNotificationWallpaperRefresh;
#define WALLPAPER_COUNT_PERLINE 3
#define NORMAL_STATE 0
#define MODIFY_STATE 1
@interface LQDownloadedWallpaperViewController ()

@end

@implementation LQDownloadedWallpaperViewController

@synthesize applicaitonView;
@synthesize titleString,title;
@synthesize parent;
@synthesize modifyButton;
@synthesize deleteButton;
@synthesize backButton;
@synthesize noItemLabel;
- (void)loadViews{
    //    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateStatus:)
												 name:kNotificationStatusChanged
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(AfterDeleteWallpapers:)
												 name:kNotificationWallpaperRefresh
											   object:nil];
    [self updateStatus:nil];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    if(self.titleString!=nil)
        self.title.text = self.titleString;
    isWaitingDeleteActionFinished = NO;
}
- (void) viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)updateStatus:(NSNotification*)notification{
    if (isWaitingDeleteActionFinished == YES) {
        return;
    }
    if(appsList ==nil)
        appsList = [NSMutableArray array];
    [appsList removeAllObjects];
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        if ([obj.gameInfo.fileType isEqualToString: @"wallpaper"]) {
            [appsList addObject:obj.gameInfo];
        }
        
    }
    if (appsList.count == 0) {
        noItemLabel.hidden = NO;
        self.applicaitonView.hidden = YES;
    }
    else{
        noItemLabel.hidden = YES;
        self.applicaitonView.hidden = NO;
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
    [cell addInfoButtonsTarget:self action:@selector(onWallpaperClicked:) tag:indexPath.row* WALLPAPER_COUNT_PERLINE];
    
    
    for(NSNumber* number in deleteList){
        int value = [number intValue];
        if (value>=indexPath.row*WALLPAPER_COUNT_PERLINE 
            && value < (indexPath.row+1)*WALLPAPER_COUNT_PERLINE) {
            [cell hiddenDeleteIcon:value-indexPath.row*WALLPAPER_COUNT_PERLINE hidden:NO];
        }
    }
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
    if (tag>=appsList.count) {
        return;
    }
    if(state == NORMAL_STATE){
        LQWallpaperViewController* controller = [[LQWallpaperViewController alloc]initWithNibName:@"LQWallpaperViewController" bundle:nil];
        LQGameInfo *item = [appsList objectAtIndex:tag];
        controller.iconImageUrl = item.icon;
        controller.imageUrl = item.downloadUrl;
        controller.titleString = item.name;
        controller.gameInfo = item;
        controller.appsList = appsList;
        controller.currentIndex = tag;
        controller.moreUrl = nil;
        controller.downloadButton.hidden = YES;
        
        [self.parent.navigationController pushViewController:controller animated:YES];
    }
    else {
        //setDeleteIcon
        if(deleteList == nil)
        {
            deleteList = [NSMutableArray array];
        }
        
        BOOL found = NO;
        for(NSNumber* number in deleteList){
            int value = [number intValue];
            if (value == tag) {
                found = YES;
                [deleteList removeObject:number];
                break;
            }
        }
        if (found == NO) {
            [deleteList addObject:[NSNumber numberWithInt:tag]];
        }
        [applicaitonView reloadData];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0]; 
//        LQWallpaperCell *cell = (LQWallpaperCell*)[self tableView:self.applicaitonView cellForRowAtIndexPath:indexPath];
//        [cell setDeleteIcon:tag];
        
    }
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onModify:(id)sender{
    if(state == NORMAL_STATE){
        deleteButton.hidden = NO;
        backButton.hidden = YES;
        state = MODIFY_STATE;
        [modifyButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        deleteButton.hidden = YES;
        backButton.hidden = NO;
        state = NORMAL_STATE;
        [modifyButton setTitle:@"编辑" forState:UIControlStateNormal];

    }
}

-(IBAction)onDelete:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    isWaitingDeleteActionFinished = YES;
    
    NSMutableArray* deleteGameIds = [NSMutableArray array];
    for(NSNumber* number in deleteList){
        int value = [number intValue];
        LQGameInfo *item = [appsList objectAtIndex:value];
        [deleteGameIds addObject:[NSNumber numberWithInt:item.gameId]];
    }
    [[LQDownloadManager sharedInstance] removeDownloadWallpaperBy:deleteGameIds];
}

-(void) AfterDeleteWallpapers:(NSNotification*)notification{
    isWaitingDeleteActionFinished = NO;
    [deleteList removeAllObjects];
    [self onModify:nil];
    [self updateStatus:nil];
}
@end
