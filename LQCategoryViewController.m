//
//  QYXCategoryViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQCategoryViewController.h"
#import "LQCategoryTableViewCell.h"
#import "LQDetailViewController.h"

@interface LQCategoryViewController ()
@property (strong) NSArray* categories;
@property (strong) NSMutableArray* games;
@property (strong) EGORefreshTableFooterView* headerView;
@property (assign) BOOL moreGameToLoad;
@property (assign) BOOL refreshing;
@property (assign) int currentCategoryId;
@end

@implementation LQCategoryViewController
@synthesize categories, games;

@synthesize categoriesView, gamesView;
@synthesize headerView;

@synthesize currentCategoryId;
@synthesize refreshing;
@synthesize moreGameToLoad;

- (void)loadViews{
    [super loadViews];

    CGRect frame = self.gamesView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.height;
    self.headerView = [[EGORefreshTableFooterView alloc] initWithFrame:frame];
    [self.gamesView addSubview:self.headerView];

    self.headerView.delegate = self;
    [self.headerView refreshLastUpdatedDate];
}

- (void)loadData{
    [super loadData];
    
    [self startLoading];
    [self.client loadCategories];
}

- (void)loadGameOfCategory:(NSDictionary*)category{
    [self startLoading];
    int category_id = [[category objectForKey:@"id"] intValue];
    self.currentCategoryId = category_id;
    self.games = [NSMutableArray array];
    [self.gamesView reloadData];
    [self.client loadGameOfCategory:category_id start:0 count:30];
}

- (void)loadCurrentCategory{
    [self startLoading];
    self.refreshing = NO;
    [self.client loadGameOfCategory:self.currentCategoryId start:self.games.count count:30];
}


- (void)loadCategories:(NSArray*)result{
    self.categories = result;
    [self.categoriesView reloadData];
    
    if (self.categories.count > 0){
        [self.categoriesView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        [self loadGameOfCategory:[self.categories objectAtIndex:0]];
    }
}

- (void)loadGames:(NSDictionary*)result{
    int total_count = [[result objectForKey:@"total_count"] intValue];
    [self.games addObjectsFromArray:[result objectForKey:@"items"]];
    [self.gamesView reloadData];
    
    self.refreshing = NO;
    self.moreGameToLoad = total_count > self.games.count;
    
    [self.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.gamesView];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2){
        return self.categories.count;
    }else if (tableView.tag == 1){
        return (self.games.count + 2)/3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1){
        LQCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
        
        int index = indexPath.row * 3;
        
        cell.gameInfo1 = [self.games objectAtIndex:index];
        
        if (index + 1 < self.games.count){
            cell.gameInfo2 = [self.games objectAtIndex:index + 1];
        }else{
            cell.gameInfo2 = nil;
        }
        
        if (index + 2 < self.games.count){
            cell.gameInfo3 = [self.games objectAtIndex:index + 2];
        }else{
            cell.gameInfo3 = nil;
        }
        
        
        return cell;
    }else if (tableView.tag == 2){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"button"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"button"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_bg_hover.png"]];
        }

        NSDictionary* category = [self.categories objectAtIndex:indexPath.row];
        cell.textLabel.text = [category objectForKey:@"name"];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2){
        if ([cell viewWithTag:10] == nil){
            UIImageView* seperator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_separator.png"]];
            seperator.tag = 10;
            CGRect frame = seperator.frame;
            frame.size.width = cell.bounds.size.width - 2;
            frame.origin.y = cell.bounds.size.height - frame.size.height;
            seperator.frame = frame;    
            [cell addSubview:seperator];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2){
        NSDictionary* category = [self.categories objectAtIndex:indexPath.row];
        [self loadGameOfCategory:category];
    }
}

#pragma mark - EGORefreshTableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (self.moreGameToLoad){
        [self.headerView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.moreGameToLoad){
        [self.headerView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self loadCurrentCategory];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return self.refreshing; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

- (float)egoRefreshTableHeaderTableViewHeight:(EGORefreshTableHeaderView*)view{
    return (self.games.count + 2)/3 * self.gamesView.rowHeight;
}

- (BOOL)egoRefreshTableHeaderDataSourceNeedLoading:(EGORefreshTableHeaderView*)view{
    return self.moreGameToLoad;
}


#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_GETCATEGORIES:
            if ([result isKindOfClass:[NSArray class]]){
                [self loadCategories:result];
            }
            break;
        case C_COMMAND_GETGAMEOFCATEGORY:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadGames:result];
            }
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    switch (error.command) {
        case C_COMMAND_GETCATEGORIES:
            [self endLoading];
            if (self.categories.count == 0){
                [super handleNetworkError:error];
            }
            break;
        case C_COMMAND_GETGAMEOFCATEGORY:
            [self endLoading];
            if (self.categories.count > 0){
                [super handleNetworkErrorHint];
            }else{
                [super handleNetworkError:error];
            }
            break;
        default:
            break;
    }
}

- (void)QYXCategoryTableViewCell:(LQCategoryTableViewCell*)cell selectGameId:(int)gameId{
    [self performSegueWithIdentifier:@"gotoDetail" sender:[NSNumber numberWithInt:gameId]];
}

#pragma mark - segue preparation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoDetail"]){
        //设置对象
        LQDetailViewController* detailController = segue.destinationViewController;
        NSNumber* gameInfo = sender;
        detailController.gameId = [gameInfo intValue];
    }
}
@end
