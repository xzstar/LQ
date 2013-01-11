//
//  LQTopicListViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTopicListViewController.h"
#import "LQTopicCell.h"
@interface LQTopicListViewController ()

@end

@implementation LQTopicListViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQTopicCell* cell = [tableView dequeueReusableCellWithIdentifier:@"topic"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LQTopicCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.gameInfo = [self.appsList objectAtIndex:indexPath.row];
    return cell;   
    
}

#pragma mark - Data Init

- (void)loadData{
    [super loadData];
    
    if(self.orderBy == nil || self.nodeId == nil){
        [self endLoading];
        return;
    }
    //[self startLoading];    
    [self.client loadAppListSoftGameCommon:self.nodeId orderby:self.orderBy];
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
