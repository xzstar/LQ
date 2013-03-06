//
//  QYXMainTabBarController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQMainTabBarController.h"

#import "LQFirstPageViewController.h"
#import "LQSearchViewController.h"
//#import "LQDownloadViewController.h"
#import "LQDownloadTablesController.h"
#import "LQUpdateViewController.h"
#import "LQMoreViewController.h"
#import "LQConfig.h"
#import "LQDownloadManager.h"
extern NSString* const kNotificationStatusChanged;
extern NSString* const kNotificationUpdateListChanged;

@interface LQMainTabBarController (){
    UINavigationController* tab0Nav;
    UINavigationController* tab1Nav;
    UINavigationController* tab2Nav;
    UINavigationController* tab3Nav;
    UINavigationController* tab4Nav;
}
@end

@implementation LQMainTabBarController
@synthesize tabItems;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LQFirstPageViewController * first = [[LQFirstPageViewController alloc] 
                                         initWithNibName:@"LQFirstPageViewController" bundle:nil];  
    tab0Nav = [[UINavigationController alloc] init];
    [tab0Nav setNavigationBarHidden:YES];
    [tab0Nav pushViewController:first animated:NO];
    
    
    LQSearchViewController * search = [[LQSearchViewController alloc]
                                       initWithNibName:@"LQSearchViewController" bundle:nil];  
    
    tab1Nav = [[UINavigationController alloc] init];
    [tab1Nav setNavigationBarHidden:YES];
    [tab1Nav pushViewController:search animated:NO];
    
    
    LQDownloadTablesController* download = [[LQDownloadTablesController alloc] 
                                            initWithNibName:@"LQTablesController" bundle:nil];
    tab2Nav = [[UINavigationController alloc] init];
    [tab2Nav setNavigationBarHidden:YES];
    [tab2Nav pushViewController:download animated:NO];
    
    LQUpdateViewController* update = [[LQUpdateViewController alloc]
                                      initWithNibName:@"LQUpdateViewController" bundle:nil];  
    tab3Nav = [[UINavigationController alloc] init];
    [tab3Nav setNavigationBarHidden:YES];
    [tab3Nav pushViewController:update animated:NO];
    
    LQMoreViewController* more = [[LQMoreViewController alloc]
                                  initWithNibName:@"LQMoreViewController" bundle:nil];  
    tab4Nav = [[UINavigationController alloc] init];
    [tab4Nav setNavigationBarHidden:YES];
    [tab4Nav pushViewController:more animated:NO];
    
    NSArray* viewControllerArray = [NSArray arrayWithObjects:tab0Nav,tab1Nav,tab2Nav,tab3Nav,tab4Nav,nil];  
    self.viewControllers = viewControllerArray;  
    
    NSArray* items = self.tabBar.items;
    if(tabItems == nil)
        tabItems = [NSMutableArray array];
    else
        [tabItems removeAllObjects];
    int index = 0;
    
    NSString* title[] = {@"首页",@"搜索",@"下载管理",@"更新",@"更多"};
    NSString* images[] ={@"menu_home_default.png"
        ,@"menu_search_default.png",@"menu_download_default.png"
        ,@"menu_update_default.png",@"menu_about_default.png"};
    for (UITabBarItem* item in items){
        
        UIImage* image = [UIImage imageNamed:images[index]];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:title[index] 
                                                              image:image 
                                                                tag:index];
        [tabItems addObject:tabItem];
        
        //        [newItems addObject:[[UITabBarItem alloc] initWithTitle:title[index] 
        //                                                          image:image 
        //                                                            tag:index]];
        index++;
        
    }
    
    UITabBar* myTabBar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
    myTabBar.items = tabItems;
    myTabBar.delegate = self;
    [self.view addSubview:myTabBar];
    myTabBar.selectedItem = [tabItems objectAtIndex:0];
    
    myTabBar.backgroundImage = [UIImage imageNamed:@"menu_bg.png"];
    
    myTabBar.selectionIndicatorImage = [UIImage imageNamed:@"menu_current_bg.png"];
    
    [[AppUpdateReader sharedInstance] addListener: self];
    [[AppUpdateReader sharedInstance] loadNeedUpdateApps];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDownloadingStatus:)
                                                 name:kNotificationStatusChanged
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNeedUpdateNumber:)
                                                 name:kNotificationUpdateListChanged
                                               object:nil];
    
    //初始化显示在下载列表中的个数
    [self updateDownloadingStatus:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[AppUpdateReader sharedInstance] removeListener:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if(self.selectedIndex == item.tag){
        switch (item.tag) {
            case 0:
                [tab0Nav popToRootViewControllerAnimated:YES];
                break;
            case 1:   
                [tab1Nav popToRootViewControllerAnimated:YES];
                break;
            case 2:   
                [tab2Nav popToRootViewControllerAnimated:YES];
                break;
            case 3:   
                [tab3Nav popToRootViewControllerAnimated:YES];
                break;
            case 4:   
                [tab4Nav popToRootViewControllerAnimated:YES];
                break;
            default:
                break;
        }
    }
    
    
    self.selectedIndex = item.tag;
    NSString* images[] = {@"menu_home_current.png",
        @"menu_search_current.png",
        @"menu_download_current.png",
        @"menu_update_current.png",
        @"menu_about_current.png"};
    item.image = [UIImage imageNamed:images[self.selectedIndex]];
    
    //下载管理需要判断是否跳转到正在下载页
    //如果有下载，则需要跳转到下载页面，否则不需要
    if(item.tag == 2){
        
        //        LQDownloadTablesController* controller = (LQDownloadTablesController*)[tab2Nav presentedViewController];
        UIViewController* controller = [tab2Nav topViewController];
        if([controller isKindOfClass:[LQDownloadTablesController class]] == YES){
            int count = [LQDownloadManager sharedInstance].downloadGames.count;
            ((LQDownloadTablesController*)controller).showDownloadingList = count>0?YES:NO;
        }
    }
    
    
}

- (IBAction)onManage:(id)sender{
    moreBgView.hidden = YES;
    //[self performSegueWithIdentifier:@"gotoManage" sender:sender];
}

- (IBAction)onFeedback:(id)sender{
    moreBgView.hidden = YES;
    //[self performSegueWithIdentifier:@"gotoFeedback" sender:sender];
}

//成功获得appList
-(void) didAppUpdateListSuccess:(NSArray*) appsList{
    UITabBarItem *tabItem = [tabItems objectAtIndex:3];
    if(appsList!=nil && appsList.count>0){
        
        NSArray* ignoreApps = [LQConfig restoreIgnoreAppList];
        int ignoreCount =0;
        
        if(ignoreApps!=nil)
            ignoreCount = ignoreApps.count;
        
        tabItem.badgeValue = [NSString stringWithFormat:@"%d",appsList.count - ignoreCount];
        [UIApplication sharedApplication].applicationIconBadgeNumber = appsList.count-ignoreCount;
    }
    else{
        tabItem.badgeValue = nil;   
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } 
}
//获得appList失败
-(void) didAppUpdateListFailed:(LQClientError*)error{
    UITabBarItem *tabItem = [tabItems objectAtIndex:3];
    tabItem.badgeValue = nil; 
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)setNeedUpdateNumber:(NSNotification*)notification{
    UITabBarItem *tabItem = [tabItems objectAtIndex:3];
    if(notification.userInfo!=nil && [notification.userInfo objectForKey:@"number"]!=nil  ){
        NSNumber* number = [notification.userInfo objectForKey:@"number"];
        UITabBarItem *tabItem = [tabItems objectAtIndex:3];
        
        tabItem.badgeValue = [NSString stringWithFormat:@"%d",[number intValue] ];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [number intValue];
    }
    else{
        tabItem.badgeValue = nil;   
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } 
    
}

- (void)updateDownloadingStatus:(NSNotification*)notification{
    UITabBarItem *tabItem = [tabItems objectAtIndex:2];
    
    int count = [LQDownloadManager sharedInstance].downloadGames.count;
    
    if(count>0){
        tabItem.badgeValue = [NSString stringWithFormat:@"%d",count];
    }
    else
        tabItem.badgeValue = nil;    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1)
    {
        NSDictionary* category = [NSDictionary dictionaryWithObject:@"阿婆当" forKey:@"name"];
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0",@"id", 
                              @"阿婆当",@"name",
                              updateDesc,@"description",
                              updateLink,@"downloadUri",
                              @"com.liqu.liquhelper",@"package",
                              updateDesc,@"Intro",
                              updateVersion,@"versionName",
                              @"",@"icon",
                              category,@"category",
                              @"阿婆当",@"tags",
                              nil];
        LQGameInfo* info = [[LQGameInfo alloc] initWithAPIResult:dict];
        [[LQDownloadManager sharedInstance] addToDownloadQueue:info installAfterDownloaded:NO];
    }
}

-(void) willPresentAlertView:(UIAlertView *)alertView{
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) view;
            label.textAlignment=UITextAlignmentLeft;
        }
    }
}

- (void)client:(LQClientBase*)client didNeedUpdate:(NSString*)description link:(NSString*)link newVersion:(NSString *)newVersion{
    updateDesc = description;
    updateLink = link;
    updateVersion = newVersion;
    [self performSelector:@selector(showUpdateInfo) withObject:nil afterDelay:5];
    
}
-(void) showUpdateInfo{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"更新提示" 
                                                   message:updateDesc 
                                                  delegate:self   
                                         cancelButtonTitle:@"取消" 
                                         otherButtonTitles:@"确定",nil];
    [alert show];
}
@end
