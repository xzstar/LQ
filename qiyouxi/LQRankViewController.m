//
//  LQRankViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQRankViewController.h"
#import "LQRankSectionHeader.h"
@interface LQRankViewController ()

@end

@implementation LQRankViewController

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

#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
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
#pragma mark - TableView Data Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LQRankSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQRankSectionHeader" owner:self options:nil]objectAtIndex:0];
    
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:0];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:1];
    [header addInfoButtonsTarget:self action:@selector(onChangeRank:) tag:2];        
    return header;
    
}
-(void) onChangeRank:(id)sender{
    UIButton* button = (UIButton*) sender;
    int tag = button.tag;
    
    if(tag == 0){
        self.orderBy = ORDER_BY_WEEK;
    }
    else if(tag == 1){
        self.orderBy = ORDER_BY_MONTH;
    }
    else {
        self.orderBy = ORDER_BY_TOTAL;
    }
    [   self loadData];
}

@end
