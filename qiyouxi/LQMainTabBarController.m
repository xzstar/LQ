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
#import "LQDownloadViewController.h"
#import "LQUpdateViewController.h"
#import "LQMoreViewController.h"

@interface LQMainTabBarController ()

@end

@implementation LQMainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSArray* items = self.tabBar.items;
//    NSMutableArray* newItems = [NSMutableArray array];
    
//    int index = 0;
//    for (UITabBarItem* item in items){
//        [newItems addObject:[[UITabBarItem alloc] initWithTitle:item.title 
//                                                          image:item.image 
//                                                            tag:index++]];
//    }
//    
//    [newItems addObject:[[UITabBarItem alloc] initWithTitle:nil 
//                                                      image:nil
//                                                        tag:index++]];
// 
//    [newItems addObject:[[UITabBarItem alloc] initWithTitle:nil 
//                                                      image:nil
//                                                        tag:index++]];
// 
//    [newItems addObject:[[UITabBarItem alloc] initWithTitle:nil 
//                                                      image:nil
//                                                        tag:index++]];
// 
//    [newItems addObject:[[UITabBarItem alloc] initWithTitle:nil 
//                                                      image:nil
//                                                        tag:index++]];
//    
//    [newItems addObject:[[UITabBarItem alloc] initWithTitle:nil 
//                                                      image:nil
//                                                        tag:index++]];
//    LQTodayViewController* todayController = [[LQTodayViewController alloc] init];  
//    LQHistoryViewController* historyController = [[LQHistoryViewController alloc] init];
    LQFirstPageViewController * first = [[LQFirstPageViewController alloc] initWithNibName:@"LQFirstPageViewController"
                                                         bundle:nil];  
    LQSearchViewController * search = [[LQSearchViewController alloc] initWithNibName:@"LQSearchViewController"
                                                                                    bundle:nil];  
    LQDownloadViewController * download = [[LQDownloadViewController alloc] initWithNibName:@"LQDownloadViewController"
                                                                                    bundle:nil];  
    LQUpdateViewController * update = [[LQUpdateViewController alloc] initWithNibName:@"LQUpdateViewController"
                                                                                    bundle:nil];  
    LQMoreViewController * more = [[LQMoreViewController alloc] initWithNibName:@"LQMoreViewController"
                                                                                    bundle:nil];  
    
    NSArray *viewControllerArray = [NSArray arrayWithObjects:/*todayController,historyController,downloadController,feedbackViewController,postCommentViewController,*/first,search,download,update,more,nil];  
    self.viewControllers = viewControllerArray;  

    NSArray* items = self.tabBar.items;
        NSMutableArray* newItems = [NSMutableArray array];
    
        int index = 0;
        for (UITabBarItem* item in items){
            [newItems addObject:[[UITabBarItem alloc] initWithTitle:item.title 
                                                              image:item.image 
                                                                tag:index++]];
        }
    UITabBar* myTabBar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
    myTabBar.items = newItems;
    myTabBar.delegate = self;
    [self.view addSubview:myTabBar];
    myTabBar.selectedItem = [newItems objectAtIndex:0];
    
    myTabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg.png"];
    
    //myTabBar.selectionIndicatorImage = [UIImage imageNamed:@"selected.png"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.selectedIndex = item.tag;
    
    switch (item.tag) {
        case 0:
            tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_index.png"];
            break;
        case 1:
            tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_search.png"];
            break;
        case 2:
            tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_down.png"];
            break;
        case 3:
            tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_update.png"];
            break;
        case 4:
            tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_more.png"];
            break;

        default:
            break;
    }
    if (item.tag == 3){
        if (moreBgView == nil){
            
            moreBgView = [[[NSBundle mainBundle] loadNibNamed:@"MoreTabView" owner:self options:nil] objectAtIndex:0];
            [self.view addSubview:moreBgView];

            CGRect frame = moreBgView.frame;
            frame.origin.x = self.view.bounds.size.width - frame.size.width;
            frame.origin.y = tabBar.frame.origin.y - frame.size.height;
            moreBgView.frame = frame;
            moreBgView.hidden = YES;
        }

        moreBgView.hidden = !moreBgView.hidden;
    }else{
        moreBgView.hidden = YES;
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


@end
