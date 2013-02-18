//
//  LQSearchViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQSearchViewController.h"
#import "LQSearchSectionHeader.h"
#import "LQSearchHistoryCell.h"
#import "LQGameInfoListViewController.h"
#import "LQConfig.h"
#define LQAPPSEARCH @"app_search"

@interface LQSearchViewController ()

@end

@implementation LQSearchViewController

@synthesize searchBar;
@synthesize searchResultTable;
@synthesize scrollView;
@synthesize searchHistoryView;
@synthesize searchHistoryTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentRecommendIndex = 0;
        
        searchHistoryItems = [NSMutableArray arrayWithArray:[LQConfig restoreSearchHistory]];
        if(searchHistoryItems == nil)
            searchHistoryItems = [NSMutableArray array];
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
    scrollView.alwaysBounceVertical = NO;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    searchResultTable.frame = frame;
    [scrollView addSubview:searchHistoryView];

    frame = scrollView.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    searchResultTable.frame = frame;
    [scrollView addSubview:searchResultTable];

    [self.client loadHotKeywords];
    
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            frame = subview.frame;
            [subview removeFromSuperview];

            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_bg.png"]];
            frame.size.height = 50;
            imageView.frame = frame;
            imageView.contentMode = UIViewContentModeScaleToFill;
            [searchBar insertSubview:imageView atIndex:0];
            break;
        }
    }

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];


   
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar resignFirstResponder];
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

#pragma mark - searchBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar;
{
	//键盘消失
	[searchbar resignFirstResponder];
    NSString* searchText = [searchbar text];
    if(searchText.length==0)
        return;
    
//    SearchHistoryItem* item = 
//    [SearchHistoryItem searchHistoryItemWithType:@"soft"
//                                            name:[searchbar text]];
    NSString* item = [searchbar text];
    //移除旧的
    for (NSString* tempItem in searchHistoryItems) {
        if(tempItem == item)
        {
            [searchHistoryItems removeObject:tempItem];
            break;
        }
    }
    
    [searchHistoryItems addObject:item];
    
    [LQConfig saveSearchHisory:searchHistoryItems];
    
    [searchHistoryTable reloadData];
    
    [self search:[searchbar text]];

}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(section == 0)
    if(tableView == searchHistoryTable)
        return currentRecommendIndex==0? searchHistoryItems.count:searchHotKeywordItems.count;
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==searchHistoryTable){
        
        LQSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQSearchHistoryCell" owner:self options:nil]objectAtIndex:0];
        }
        NSArray* items =currentRecommendIndex==0? searchHistoryItems:searchHotKeywordItems;
        NSString* item = [items objectAtIndex:indexPath.row];
        //[cell.type setText:item.type];
        [cell hiddenDelButton:currentRecommendIndex!=0];
        [cell.name setText:item];
        [cell addInfoButtonsTarget:self action:@selector(onDeleteSearchItem:) tag:indexPath.row];
        return cell;
    }
    return nil;
}
#pragma mark - TableView Data Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView==searchHistoryTable && section == 0){
        return 45.0;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if(tableView==searchHistoryTable && section == 0)
    {
        LQSearchSectionHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"LQSearchSectionHeader" owner:self options:nil]objectAtIndex:0];
        [header addInfoButtonsTarget:self action:@selector(onSwitchRecommendSection:) tag:0];
        [header addInfoButtonsTarget:self action:@selector(onSwitchRecommendSection:) tag:1];
//        [header setImageNames:nil
//                 leftSelected:@"search_history_bt.png"
//                  rightNormal:nil 
//                rightSelected:@"search_hotword_bt.png"];
        [header setButtonStatus:currentRecommendIndex];
        return header;
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView!=searchHistoryTable) {
        return;
    }
    int row = indexPath.row;
    NSString* keyword = (currentRecommendIndex==0)?[searchHistoryItems objectAtIndex:row]:[searchHotKeywordItems objectAtIndex:row];
    self.searchBar.text = keyword;
    [self search:keyword];
        


    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark recommendSetion callback
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

- (void)onDeleteSearchItem:(id)sender{
    UIButton* button = sender;
    int tag = button.tag;
    if(tag>=0 && tag< searchHistoryItems.count){
        [searchHistoryItems removeObjectAtIndex:tag];
        [self.searchHistoryTable reloadData];
    }

}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOptions]];
//    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [super handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETHOTKEYWORDS:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadHotkeyword:[result objectForKey:@"keywords"]];
            }
            break;
            
      
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    [super handleNetworkErrorHint];
}

#pragma mark - load keyword
-(void) loadHotkeyword:(NSArray*) keywords{
    searchHotKeywordItems = keywords;
    if(currentRecommendIndex == 1)
        [self.searchHistoryTable reloadData];

}

- (void)search:(NSString*)keyword{
    if (keyword!=nil) {
        BOOL needSearchAgain = YES;
        if(listController==nil)
        {
            listController = [[LQGameInfoListViewController alloc] initWithNibName:@"LQCommonTableViewController" bundle:nil listOperator:LQAPPSEARCH keywords:keyword];
            CGRect frame = searchResultTable.frame;
            frame.origin.x = 0;
            listController.view.frame = frame;
            needSearchAgain = NO;
            listController.parent = self;
        }
        else {
            listController.keywords = keyword;
            listController.appsList = nil;
            [listController loadData];
        }
        NSArray* subViews = [searchResultTable subviews];
        for (UIView* view in subViews) {
            [view removeFromSuperview];
        }
        [searchResultTable addSubview:listController.view];
        if (needSearchAgain) {
            [listController loadData];
        }
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width ;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:YES];
    }
}
@end
