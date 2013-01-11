//
//  LQTopicListViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQCategoryListViewController.h"
#import "LQTopicCell.h"
@interface LQCategoryListViewController ()

@end

@implementation LQCategoryListViewController
@synthesize category;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             category:(NSString *)aCategory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        category = aCategory;
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
    cell.gameDetailLabel.hidden = YES;
    cell.gameComments.hidden = YES;
    return cell;   
    
}

#pragma mark - Data Init

- (void)loadData{
    [super loadData];
    
    if(self.category == nil){
        [self endLoading];
        return;
    }
    //[self startLoading];    
    [self.client loadCategory:category];
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [self handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETCATEGORY:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                // [self loadTodayGames:result];
                [self loadCats:[result objectForKey:@"cats"]];
            }
            break;
            
        default:
            break;
    }
}


- (void) loadCats:(NSArray*) cats{
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSDictionary* game in cats){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    self.appsList = items;
    [self.tableView reloadData];
    
}

@end
