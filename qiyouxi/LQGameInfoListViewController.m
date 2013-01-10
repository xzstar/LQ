//
//  LQGameInfoListViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ科技有限公司. All rights reserved.
//

#import "LQGameInfoListViewController.h"
#import "LQGameDetailViewController.h"
@interface LQGameInfoListViewController ()
@end

@implementation LQGameInfoListViewController
@synthesize nodeId,orderBy;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               nodeId:(NSString*) aNodeId
              orderBy:(NSString*) aOrderBy
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;
        nodeId = aNodeId;
        orderBy = aOrderBy;
        [self loadViews];
        [self loadData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.title = NSLocalizedString(@"First", @"First");
        // self.tabBarItem.image = nil;

    }
    return self;
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



#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
}

#pragma mark - Data Init

- (void)loadData{
    [super loadData];
    
    if(orderBy == nil || nodeId == nil){
        [self endLoading];
        return;
    }
    //[self startLoading];    
    [self.client loadAppListSoftGameCommon:nodeId orderby:orderBy];
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETAPPLISTSOFTGAME:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadApps:[result objectForKey:@"apps"]];
            }
            break;
            
        default:
            break;
    }
}

@end
