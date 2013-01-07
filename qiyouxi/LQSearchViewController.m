//
//  LQSearchViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQSearchViewController.h"
#import "LQSearchSectionHeader.h"
@interface LQSearchViewController ()

@end

@implementation LQSearchViewController

@synthesize searchBar;
@synthesize searchTable;
@synthesize searchBarController;
@synthesize scrollView;
@synthesize searchHistoryView;
@synthesize searchHistoryTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentRecommendIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = YES;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    searchTable.frame = frame;
    [scrollView addSubview:searchHistoryView];

    frame = scrollView.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    searchTable.frame = frame;
    [scrollView addSubview:searchTable];

    

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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar;
{
	//键盘消失
	[searchbar resignFirstResponder];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(section == 0)
        return 0;
}

#pragma mark - TableView Data Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 45.0;
    }
    else if(section ==1) {
        return 34.0;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if(section == 0)
    {
        LQSearchSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQSearchSectionHeader" owner:self options:nil]objectAtIndex:0];
        [header addInfoButtonsTarget:self action:@selector(onSwitchRecommendSection:) tag:0];
        [header addInfoButtonsTarget:self action:@selector(onSwitchRecommendSection:) tag:1];
        [header setImageNames:nil
                 leftSelected:@"search_history_bt.png"
                  rightNormal:nil 
                rightSelected:@"search_hotword_bt.png"];
        [header setButtonStatus:currentRecommendIndex];
        return header;
        
    }
    return nil;
}

#pragma recommendSetion callback
- (void)onSwitchRecommendSection:(id)sender{
    UIButton* button = sender;
    int tag = button.tag;
    if(tag == currentRecommendIndex)
        return;
    else {
        currentRecommendIndex = tag;
        [self.searchHistoryTable reloadData];
    }

}

@end
