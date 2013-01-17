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
#import "LQGameDetailViewController.h"
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
@end

@interface LQUpdateViewController ()

@end

@implementation LQUpdateViewController
@synthesize appsList,tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedRow = -1;
        selectedSection = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray * array = [InstalledAppReader installedApp];
    NSString* appsString = [array componentsJoinedByString:@","];
    if(appsString == nil)
        appsString = [LQConfig restoreAppList];
    else 
        [LQConfig saveAppList:appsString];
    
    [self.client loadAppUpdate:appsString];
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

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{  
    viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",80];  
}  

#pragma mark - load apps 
- (void)loadApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    
    appsList = items;
    [self.tableView reloadData];
    
}

- (void) saveAppsList{
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for(LQGameInfo* info in self.appsList)
    {
        NSString* tempString = [NSString stringWithFormat:@"%@,%@,%@",
                                info.name,info.package,info.versionCode];
        [tempArray addObject:tempString];
    }
    [LQConfig saveUpdateAppList:tempArray];
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [super handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPUPDATE:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadApps:[result objectForKey:@"apps"]];

            }
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    [self endLoading];
    //[super handleNetworkErrorHint];
    
}


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
    return appsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    //LQHistoryTableViewCell* cell;
    if(indexPath.section == selectedSection &&
       indexPath.row == selectedRow){
        LQGameMoreItemTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"moreitem"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQGameMoreItemTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.gameInfo = [appsList objectAtIndex:indexPath.row];
        
        [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:cell.gameInfo.gameId];
        [cell addDownloadButtonsTarget:self action:@selector(onGameDownload:) tag:cell.gameInfo.gameId];
        return cell;
        
    }
    
    else{
        LQHistoryTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"history"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.gameInfo = [appsList objectAtIndex:indexPath.row];
        
        [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:cell.gameInfo.gameId];
        return cell;
        
    }
    
    
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void) onGameDetail:(id)sender{
    UIButton *button = sender;
    int tag = button.tag;
    LQGameDetailViewController *controller = [[LQGameDetailViewController alloc] init];
    controller.gameId = tag;
    
    [self.navigationController pushViewController:controller animated:YES];    
}

- (void) onGameDownload:(id)sender{
    UIButton* button = (UIButton*)sender;
    int gameId = button.tag;
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:gameId];
    LQGameInfo* info;
    for (LQGameInfo* tempinfo in appsList) {
        if(tempinfo.gameId == gameId){
            info = tempinfo;
            break;
        }
    }
    switch (status) {
        case kQYXDSFailed:
            [[LQDownloadManager sharedInstance] resumeDownloadById:gameId];
            break;
            //        case kQYXDSCompleted:
            //        case kQYXDSInstalling:
            //            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
            //            break;
            //        case kQYXDSPaused:
            //            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            //            break;
            //        case kQYXDSRunning:
            //            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
            //            break;
        case kQYXDSNotFound:
            if(info!=nil)
                [[LQDownloadManager sharedInstance] addToDownloadQueue:info suspended:NO];
            
            break;
            //        case kQYXDSInstalled:
            //            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            //            break;
        default:
            break;
    }
}
@end
