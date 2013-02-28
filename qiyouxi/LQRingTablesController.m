//
//  LQRingTablesController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-21.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQRingTablesController.h"
#import "LQCommonTableViewController.h"
#import "LQGameInfoListViewController.h"
#import "LQRankViewController.h"
#import "LQCategoryListViewController.h"
#define kRingTables 3
@interface LQRingTablesController ()

@end

@implementation LQRingTablesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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


- (void)initTables
{
	// load our data from a plist file inside our app bundle
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"content_iPhone" ofType:@"plist"];
     self.contentList = [NSArray arrayWithContentsOfFile:path];
     */
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kRingTables; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kRingTables, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
}

- (void)initPageController{
    NSArray* names = [[NSArray alloc] initWithObjects:@"电话",@"短信",@"分类", nil];
    
    //int width = names.count*(PAGE_NAME_SPAN+PAGE_NAME_WIDTH);
    
    CGRect frame = CGRectMake(0, 0, self.pageView.frame.size.width, self.pageView.frame.size.height);
    
    pageController = [[LQPageController alloc] initWithFrame:frame];
    [pageController setPageNames:names];
    pageController.currentPage = 0;
    
    [pageController addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [pageController addLeftRightTarget:self action:@selector(onPageUpDown:) tag:0];
    [self.pageView addSubview:pageController];
}
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kRingTables)
        return;
    
    // replace the placeholder if necessary
    LQCommonTableViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        NSString* orderBy;
        if(page == 0) {
            orderBy = ORDER_BY_NEWEST;
            if (nodeId == @"rj" || nodeId == @"yx") {
                
                controller = [[LQRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:nodeId orderBy:orderBy];
            }
            else if(nodeId == @"ls"){
                controller = [[LQRingRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:@"374" orderBy:orderBy];
                controller.parent = self;
            }
            else {
                controller = [[LQWallpaperRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:nodeId orderBy:orderBy];
            }
            
        }
        else if(page == 1) {
            orderBy = ORDER_BY_NEWEST;
            if (nodeId == @"rj" || nodeId == @"yx") {
                
                controller = [[LQRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:nodeId orderBy:orderBy];
            }
            else if(nodeId == @"ls"){
                controller = [[LQRingRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:@"375" orderBy:orderBy];
            }
            else {
                controller = [[LQWallpaperRankViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:listOperator nodeId:nodeId orderBy:orderBy];
            }
            
        }
        else{
             controller = [[LQCategoryListViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil category:categoryId];
        }
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        controller.parent = self;
    }
}
@end
