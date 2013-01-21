//
//  LQAppsListWrapperViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-16.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQAppsListWrapperViewController.h"
#import "LQGameInfoListViewController.h"
@interface LQAppsListWrapperViewController ()

@end

@implementation LQAppsListWrapperViewController
@synthesize requestUrl;

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
    CGRect frame = super.pageView.frame;
    super.pageView.frame = CGRectZero;
    CGRect scrollViewFrame = super.scrollView.frame;
    scrollViewFrame.size.height+=frame.size.height;
    scrollViewFrame.origin.y=frame.origin.y;
    super.scrollView.frame = scrollViewFrame; 
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
    for (unsigned i = 0; i < 1; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 1, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
    //[self loadScrollViewWithPage:1];
}

- (void)initPageController{
    
}

- (LQRequestListViewController*) getController:(int)page{
    // replace the placeholder if necessary
    LQAppsListViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[LQAppsListViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil requestUrl:requestUrl];        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    return controller;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page != 0)
        return;
    
    // replace the placeholder if necessary
    LQRequestListViewController *controller = [self getController:page];

    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        controller.parent = self;
        /* NSDictionary *numberItem = [self.contentList objectAtIndex:page];
         controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
         controller.numberTitle.text = [numberItem valueForKey:NameKey];*/
    }
}
@end


@implementation LQRingsListWrapperViewController

- (LQRequestListViewController*) getController:(int)page{
    // replace the placeholder if necessary
    LQRingListWithReqUrlViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[LQRingListWithReqUrlViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil requestUrl:self.requestUrl];        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    return controller;
}
@end

@implementation LQWallpaperListWrapperViewController

- (LQRequestListViewController*) getController:(int)page{
    // replace the placeholder if necessary
    LQWallpaperListWithReqUrlViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[LQWallpaperListWithReqUrlViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil requestUrl:self.requestUrl];        
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    return controller;
}
@end
