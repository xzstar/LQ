//
//  LQCommonTableViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQCommonTableViewController.h"
#import "LQHistoryTableViewCell.h"
#import "LQGameDetailViewController.h"
#define NAVIGATIONBAR_HEIGHT 44.0

@interface LQCommonTableViewController (){
}
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UIWindow* shadowView;
@property (nonatomic, strong) NSTimer* animationTimer;
@end

@implementation LQCommonTableViewController
@synthesize errorView;
@synthesize shadowView;
@synthesize animationTimer;
@synthesize nodeId,orderBy;
@synthesize appsList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self loadViews];
        [self loadData];

    }
    return self;
}


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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadViews];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_dataLoaded) {
        _dataLoaded = YES;
        [self loadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];

}

- (void)viewDidDisappear:(BOOL)animated{
    [self endLoading];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return appsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    LQHistoryTableViewCell* cell;
    if(indexPath.section == selectedSection &&
       indexPath.row == selectedRow){
        cell = [tableView dequeueReusableCellWithIdentifier:@"moreitem"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LQGameMoreItemTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
    }
    
    cell.gameInfo = [appsList objectAtIndex:indexPath.row];
    
    [cell addInfoButtonsTarget:self action:@selector(onGameDetail:) tag:cell.gameInfo.gameId];
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(selectedRow!= indexPath.row
       && selectedSection!=indexPath.section){
        selectedRow = indexPath.row;
        selectedSection = indexPath.section;    
    }
    else {
        selectedRow = -1;
        selectedSection = -1;  
    }
    [self.tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (LQClient*)client{
    if (_client == nil){
        _client = [[LQClient alloc] initWithDelegate:self];
    }
    
    return _client;
}

- (void)loadViews{
    
}

- (void)loadData{
    appsList = [NSMutableArray array];
    [self startLoading];
    selectedRow = -1;
    selectedSection = -1;
    //[self.client loadSoftNewest];
}

//- (IBAction)onBack:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)startLoading{
    self.shadowView = [[UIWindow alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.shadowView.hidden = NO;
    self.shadowView.windowLevel = UIWindowLevelAlert;
    
    UIImageView* animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_loading.png"]];
    animationView.center = CGPointMake(self.shadowView.bounds.size.width/2, self.shadowView.bounds.size.height/2);
    [self.shadowView addSubview:animationView];
    
    UIImageView* centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_center.png"]];
    centerView.center = animationView.center;
    [self.shadowView addSubview:centerView];
    
    [self.animationTimer invalidate];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onLoading:) userInfo:animationView repeats:YES];
}

- (void)onLoading:(NSTimer*)timer{
    UIView* view = timer.userInfo;
    view.transform = CGAffineTransformMakeRotation(view.tag * 2 * 3.1415926535/20);
    view.tag ++;
}

- (void)endLoading{
    [self.animationTimer invalidate];
    self.shadowView.hidden = YES;
    self.shadowView = nil;
    self.animationTimer = nil;
}

- (void)handleNetworkOK{
    [self.errorView removeFromSuperview];
    self.errorView = nil;
}

- (void)handleNetworkErrorHint{
    [LocalString(@"network.error") showToastAsInfo];
}

- (void)handleNetworkError:(LQClientError*)error{
    [self.errorView removeFromSuperview];
    CGRect frame = self.view.bounds;
    frame.origin.y += NAVIGATIONBAR_HEIGHT;
    frame.size.height -= NAVIGATIONBAR_HEIGHT;
    self.errorView = [[UIView alloc] initWithFrame:frame];
    self.errorView.backgroundColor = [UIColor whiteColor];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"err_network.png"]];
    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
    [self.errorView addSubview:imageView];
    [self.view addSubview:self.errorView];
}

- (void)handleNoNetwork{
    [self.errorView removeFromSuperview];
    CGRect frame = self.view.bounds;
    frame.origin.y += NAVIGATIONBAR_HEIGHT;
    frame.size.height -= NAVIGATIONBAR_HEIGHT;
    self.errorView = [[UIView alloc] initWithFrame:frame];
    self.errorView.backgroundColor = [UIColor whiteColor];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_network.png"]];
    imageView.center = CGPointMake(errorView.bounds.size.width/2, errorView.bounds.size.height/2);
    [self.errorView addSubview:imageView];
    [self.view addSubview:self.errorView];
}


- (void)client:(LQClientBase*)client didFailExecution:(LQClientError*)error{
    [self endLoading];
    [self handleNetworkError:error];
}

#pragma mark - load apps 
- (void)loadApps:(NSArray*) apps{
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSDictionary* game in apps){
        [items addObject:[[LQGameInfo alloc] initWithAPIResult:game]];
    }
    appsList = items;
    [self.tableView reloadData];
    
}


- (void) onGameDetail:(id)sender{
    UIButton *button = sender;
    int tag = button.tag;
    LQGameDetailViewController *controller = [[LQGameDetailViewController alloc] init];
    controller.gameId = tag;
    [self.navigationController pushViewController:controller animated:YES];    
}
@end
