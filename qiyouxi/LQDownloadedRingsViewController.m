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
#import "LQSMSRingReplaceViewController.h"

#define RINGTONEPATH @"/private/var/mobile/Media/iTunes_Control/Ringtones"
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
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
    }
}
- (void)updateStatus:(NSNotification*)notification{
    if(appsList ==nil)
        appsList = [NSMutableArray array];
    [appsList removeAllObjects];
    for (QYXDownloadObject* obj in [LQDownloadManager sharedInstance].completedGames){
        //LQGameInfo* info = obj.gameInfo;
        if ([obj.gameInfo.fileType isEqualToString: @"sms_ring"] ||
            [obj.gameInfo.fileType isEqualToString: @"tel_ring"]) {
            [appsList addObject:obj];
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
         
            [morecell setButtonsName:@"设置" middle:nil right:nil];
            
            [morecell addLeftButtonTarget:self action:@selector(onInstallRing:) tag:indexPath.row];
          
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
    QYXDownloadObject *obj = [appsList objectAtIndex:indexPath.row];
    LQGameInfo *item = obj.gameInfo;
    
    cell.titleLabel.text = item.name;
    cell.artistLabel.text = item.tags;
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
    
    return cell;
    
}

- (void)playAudio:(AudioButton *)button
{    
    NSInteger index = button.tag;
    QYXDownloadObject *item = [appsList objectAtIndex:index];
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        NSURL* url=[NSURL URLWithString:item.gameInfo.downloadUrl];
        url = [[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"mp3"];;
        
        _audioPlayer.button = button; 
        _audioPlayer.url = [NSURL URLWithString:url.absoluteString];
        
        [_audioPlayer play];
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
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


- (void) onInstallRing:(id) sender{
    UIButton* button = sender;
    int row = button.tag;
    QYXDownloadObject *obj = [appsList objectAtIndex:row];

    if([obj.gameInfo.fileType isEqualToString:@"sms_ring"]){
    LQSMSRingReplaceViewController* controller = [[LQSMSRingReplaceViewController alloc] initWithNibName:@"LQSMSRingReplaceViewController" bundle:nil];
    controller.ringObject = obj;
    [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        //NSString* fileName= [obj.filePath lastPathComponent];
        NSString* fileName= [NSString stringWithFormat:@"%@.m4r",obj.gameInfo.name];

        NSString* destPath=[RINGTONEPATH stringByAppendingPathComponent:fileName];//这里要特别主意，目标文件路径一定要以文件名结尾，而不要以文件夹结尾
       
        NSArray* destPaths = [NSArray arrayWithObjects:destPath,nil];
        obj.finalFilePaths = destPaths;
        obj.installAfterDownloaded = YES;
        [[LQDownloadManager sharedInstance] installGameBy:obj.gameInfo.gameId];
    }
}
@end
