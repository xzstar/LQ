//
//  LQUpdateViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQUpdateViewController.h"
#import "LQConfig.h"
#import "LQGameInfoListViewController.h"
#import "LQGameMoreItemTableViewCell.h"
#import "LQDetailTablesController.h"
#import "LQIgnoreAppCell.h"
#import "LQUtilities.h"

static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@implementation InstalledAppReader

#pragma mark - Init
+(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        NSRange range = [appKey rangeOfString:@"com.apple."];
        if(range.location == 0 && range.length>0)
            continue;
        
        NSDictionary* appDict = [dictionary objectForKey:appKey];
        NSString* appVersion = [appDict objectForKey:@"CFBundleVersion"];
        NSString* appValue = [NSString stringWithFormat:@"%@,%@",appKey,appVersion];
        [desktopApps addObject:appValue];
        
        
    }
    return desktopApps;
}

+(NSArray *)installedApp
{    
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir) 
    {
        NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *system = [cacheDict objectForKey: @"System"];
        NSMutableArray *installedApp = [NSMutableArray arrayWithArray:[self desktopAppsFromDictionary:system]];
        
        NSDictionary *user = [cacheDict objectForKey: @"User"]; 
        [installedApp addObjectsFromArray:[self desktopAppsFromDictionary:user]];
        
        return installedApp;
    }
    
    return nil;
}

+(void) getRings{
//     BOOL isDir = NO;
//    if([[NSFileManager defaultManager] fileExistsAtPath: @"/var/mobile/Library/Preferences/com.apple.springboard.plist" isDirectory: &isDir] && !isDir) 
//    { 
//        NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
//        
//        NSMutableDictionary *custDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Media/iTunes_Control/iTunes/Ringtones.plist"];
//        NSMutableDictionary *dictionary = [custDict objectForKey:@"Ringtones"];
//
//    }
//
    
}
@end

@interface LQUpdateViewController ()
- (void) onGameDownload:(id)sender;
- (void) onGameDetail:(id)sender;
- (void) onAppIgnore:(id)sender;
- (void) onAppNotIgnore:(id)sender;
- (IBAction)onOpenIgnoreView:(id)sender;
- (IBAction) onCloseIgnoreView:(id)sender;
@end

@implementation LQUpdateViewController
@synthesize appsList,tableView,openIgnoreView;
@synthesize ignoreView,ignoreTableView,closeIgnoreView;
@synthesize updateAllButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedRow = -1;
        selectedSection = -1;
        ignoreAppsList = [NSMutableArray array];
        updateAppsList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSArray * array = [InstalledAppReader installedApp];
//    //[InstalledAppReader getRings];
//    NSString* appsString = [array componentsJoinedByString:@","];
////    if(appsString == nil)
////        appsString = [LQConfig restoreAppList];
////    else 
////        [LQConfig saveAppList:appsString];
//    if(appsString !=nil && appsString.length>0)
//    [self.client loadAppUpdate:appsString];
    
    [[AppUpdateReader sharedInstance] addListener:self];
    [[AppUpdateReader sharedInstance] loadNeedUpdateApps];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[AppUpdateReader sharedInstance] removeListener:self];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{  
    viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",80];  
}  

#pragma mark - load apps 
- (void)loadApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    
    NSArray* savedIgnoreList = [LQConfig restoreIgnoreAppList];
    
    
    for (LQGameInfo* gameInfo in apps){
        
        //LQGameInfo* gameInfo = [[LQGameInfo alloc] initWithAPIResult:game];
        [items addObject:gameInfo];
        
        BOOL found = NO;
        for(NSString* package in savedIgnoreList){
            if(package == gameInfo.package)
            {
                found = YES;
                break;
            }
        }
        
        if(found){
            [ignoreAppsList addObject:gameInfo];
        }
        else {
            [updateAppsList addObject:gameInfo];
        }
        
    }
    
    appsList = items;
    
    
    [self.tableView reloadData];
    [self updateIgoreButton];
}

- (void) saveAppsList{
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for(LQGameInfo* info in self.appsList)
    {
        NSString* tempString = [NSString stringWithFormat:@"%@,%@,%@",
                                info.name,info.package,info.icon];
        [tempArray addObject:tempString];
    }
    [LQConfig saveUpdateAppList:tempArray];
}

- (void) saveIgnoreApp:(LQGameInfo*) info{
    NSString* tempString = [NSString stringWithFormat:@"%@,%@,%@",
                            info.name,info.package,info.icon];
    [ignoreAppsList addObject:tempString];

}

//#pragma mark - Network Callback
//- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
//    [super handleNetworkOK];
//    switch (command) {
//        case C_COMMAND_GETAPPUPDATE:
//            [self endLoading];
//            if ([result isKindOfClass:[NSDictionary class]]){
//                [self loadApps:[result objectForKey:@"apps"]];
//
//            }
//            break;
//        default:
//            break;
//    }
//}

//- (void)handleNetworkError:(LQClientError*)error{
//    [self endLoading];
//    //[super handleNetworkErrorHint];
//    
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.tableView) {
        return updateAppsList.count;
    }
    else {
        return ignoreAppsList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if(tableView == self.tableView){
        if(indexPath.section == selectedSection &&
           indexPath.row == selectedRow){
            LQGameMoreItemTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"moreitem"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LQGameMoreItemTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            
            cell.gameInfo = [updateAppsList objectAtIndex:indexPath.row];
            [cell setButtonsName:@"立刻更新" middle:@"下载" right:@"暂不更新"];
            [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:indexPath.row];
            [cell addLeftButtonTarget:self action:@selector(onGameDownloadAndInstall:) tag:indexPath.row];
            [cell addMiddleButtonTarget:self action:@selector(onGameDownload:) tag:indexPath.row];
            [cell addRightButtonTarget:self action:@selector(onAppIgnore:) tag:indexPath.row];
            
            NSString* currentVersion = [[AppUpdateReader sharedInstance] currentVersion:cell.gameInfo.package];
            
            [cell setDetailInfo:[NSString stringWithFormat:@"当前版本%@ 最新版本%@", currentVersion,cell.gameInfo.versionCode]];
            
            return cell;
            
        }
        
        else{
            LQHistoryTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"history"];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
            cell.gameInfo = [updateAppsList objectAtIndex:indexPath.row];
            
            [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:indexPath.row];
            NSString* currentVersion = [[AppUpdateReader sharedInstance] currentVersion:cell.gameInfo.package];
            
            [cell setDetailInfo:[NSString stringWithFormat:@"当前版本%@ 最新版本%@", currentVersion,cell.gameInfo.versionCode]];
             
            return cell;
            
        }
    }
    else {
        LQIgnoreAppCell* cell = [self.ignoreTableView dequeueReusableCellWithIdentifier:@"history"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQIgnoreAppCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.gameInfo = [ignoreAppsList objectAtIndex:indexPath.row];
        
        [cell addInfoButtonsTarget:self action:@selector(onAppNotIgnore:) tag:indexPath.row];
        return cell;
    }
    
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        if(selectedRow!= indexPath.row){
            selectedRow = indexPath.row;
            selectedSection = indexPath.section;    
        }
        else {
            selectedRow = -1;
            selectedSection = -1;  
        }
        [self.tableView reloadData];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else {
        UITableViewCell *cell = [self tableView:self.ignoreTableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    
}

- (void) onGameDetail:(id)sender{
    UIButton *button = sender;
    int row = button.tag;
    LQGameInfo* gameInfo = [updateAppsList objectAtIndex:row];
    LQDetailTablesController *controller = [[LQDetailTablesController alloc] initWithNibName:@"LQTablesController" bundle:nil];
    controller.gameId = gameInfo.gameId;
    
    [self.navigationController pushViewController:controller animated:YES];    
}

- (void) onGameDownloadAndInstall:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* info = [appsList objectAtIndex:row];
    [[LQDownloadManager sharedInstance] commonAction:info installAfterDownloaded:YES];
}
- (void) onGameDownload:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* gameInfo = [updateAppsList objectAtIndex:row];
    [[LQDownloadManager sharedInstance] commonAction:gameInfo installAfterDownloaded:NO];
//    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameInfo.gameId];
//    LQGameInfo* info;
//    for (LQGameInfo* tempinfo in updateAppsList) {
//        if(tempinfo.gameId == gameId){
//            info = tempinfo;
//            break;
//        }
//    }
//    switch (status) {
//        case kQYXDSFailed:
//        case kQYXDSPaused:
//            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
//            [info showToastAsInfo];
//            [[LQDownloadManager sharedInstance] resumeDownloadById:gameInfo.gameId];
//            break;
//        case kQYXDSCompleted:
//            info = [NSString stringWithFormat:LocalString(@"info.download.downloaded"),gameInfo.name];
//            [info showToastAsInfo];
//            break;
//        case kQYXDSInstalling:
//            info = [NSString stringWithFormat:LocalString(@"info.download.install"),gameInfo.name];
//            [info showToastAsInfo];
//            break;
//        case kQYXDSRunning:
//            info = [NSString stringWithFormat:LocalString(@"info.download.running"),gameInfo.name];
//            [info showToastAsInfo];
//            break;
//        case kQYXDSNotFound:
//            if(gameInfo!=nil)
//                [[LQDownloadManager sharedInstance] addToDownloadQueue:gameInfo installAfterDownloaded:NO];
//            break;
//        case kQYXDSInstalled:
//            info = [NSString stringWithFormat:LocalString(@"info.download.install.success"),gameInfo.name];
//            [info showToastAsInfo];
//            break;
//        default:
//            break;
//    }
}

- (void)updateIgoreButton{
    NSString* title;
    if (ignoreAppsList==nil) {
        title = [NSString stringWithFormat:@"忽略(0)",ignoreAppsList.count];
    }
    else
        title = [NSString stringWithFormat:@"忽略(%d)",ignoreAppsList.count];
    [openIgnoreView setTitle:title forState:UIControlStateNormal];
}

- (void)onAppIgnore:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* gameInfo = [updateAppsList objectAtIndex:row];   
    [ignoreAppsList addObject:gameInfo];
    [updateAppsList removeObject:gameInfo];
    [self updateIgoreButton];
    LQUpdateViewController* __unsafe_unretained weakSelf = self;
    selectedRow = -1;
    selectedSection = -1;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
 
        NSMutableArray *ignoreIndexPaths = [NSMutableArray array];
        [ignoreIndexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];

        
        if(indexPaths.count>0){
            [weakSelf.tableView beginUpdates];            
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
        }
    });
}

- (void)updateList{
    [updateAppsList removeAllObjects];
    for(LQGameInfo* gameInfo in appsList){
        if([ignoreAppsList containsObject:gameInfo]==NO)
            [updateAppsList addObject:gameInfo];        
    }
  
}


- (void)onAppNotIgnore:(id)sender{
    UIButton* button = (UIButton*)sender;
    int row = button.tag;
    LQGameInfo* gameInfo = [ignoreAppsList objectAtIndex:row];   
    [ignoreAppsList removeObject:gameInfo];
    
    [self updateList];
    [self updateIgoreButton];

    //[updateAppsList addObject:gameInfo];

    
    LQUpdateViewController* __unsafe_unretained weakSelf = self;
    selectedRow = -1;
    selectedSection = -1;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSMutableArray *ignoreIndexPaths = [NSMutableArray array];
        [ignoreIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        
        if(ignoreIndexPaths.count>0){
            [weakSelf.ignoreTableView beginUpdates];
            [weakSelf.ignoreTableView deleteRowsAtIndexPaths:ignoreIndexPaths withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.ignoreTableView endUpdates];
            
        }
    });
}
- (void) onOpenIgnoreView:(id)sender{
    if(ignoreView.superview == nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

        UIViewAnimationTransition transition = UIViewAnimationTransitionCurlUp;
        
        [UIView setAnimationTransition:transition forView:self.view cache:YES];
        CGRect frame = self.view.frame;
        ignoreView.frame = frame;
        [self.view addSubview:ignoreView];
        [ignoreTableView reloadData];
        [UIView commitAnimations];

    }
}
- (void) onCloseIgnoreView:(id)sender{
    if(ignoreView.superview != nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        UIViewAnimationTransition transition = UIViewAnimationTransitionCurlDown;
        
        [UIView setAnimationTransition:transition forView:self.view cache:YES];
        [ignoreView removeFromSuperview];
        [tableView reloadData];
        [UIView commitAnimations];

    }
}
- (IBAction) onUpdateAll:(id)sender{
  
    for(LQGameInfo* gameInfo in appsList){
        //int gameId = info.gameId;
        [[LQDownloadManager sharedInstance] commonAction:gameInfo installAfterDownloaded:YES];
//        QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
//        QYXDownloadObject* obj = [[LQDownloadManager sharedInstance] objectWithGameId:info.gameId];
//        if(obj!=nil)
//            obj.installAfterDownloaded = YES;
       
    }
}

//成功获得appList
-(void) didAppUpdateListSuccess:(NSArray*) appsArray{
    [self loadApps:appsArray];  
}
//获得appList失败
-(void) didAppUpdateListFailed:(LQClientError*)error{
    [self endLoading];
}


@end
