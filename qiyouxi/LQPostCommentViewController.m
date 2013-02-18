//
//  QYXPostCommentViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQPostCommentViewController.h"
#import "LQCommentTableViewCell.h"
#import "SVPullToRefresh.h" 


@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
	
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
		
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
	
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
	
    [super drawRect:rect];
}

@end
@interface LQPostCommentViewController ()
{
    NSArray* starButtons;
    int score;
    NSString* moreUrl;
}
@property (nonatomic, strong) NSMutableArray* userComments;
@property (nonatomic, strong) NSString* moreUrl;


@end

@implementation LQPostCommentViewController
@synthesize gameId;
@synthesize moreUrl;
@synthesize contactField;
@synthesize contentField;
@synthesize commentsTableView;
@synthesize userComments;
@synthesize gameScore;
@synthesize scoreString;
@synthesize starButton1,starButton2,starButton3,starButton4,starButton5;
- (void)loadViews{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* contact = [defaults valueForKey:@"qiyouxi.savedcontact"];
    if (contact.length > 0){
        self.contactField.text = contact;
    }
    
}


- (void)loadData{
    if(self.userComments == nil)
        self.userComments = [NSMutableArray array];
    else {
        [self.userComments removeAllObjects];
    }
    [self.client loadUserComments:gameId];
}


- (void)loadMoreData{
    if(self.moreUrl != nil){
        [self.client loadAppMoreListCommon:self.moreUrl];
    }
    else {
        //[self endLoading];
        [self.commentsTableView.infiniteScrollingView stopAnimating];
        return;
    }
}


- (void)viewDidLoad{
    [self loadData];
    gameScore.text = scoreString;
    
    if(starButtons == nil)
        starButtons = [NSArray arrayWithObjects:starButton1,starButton2,starButton3,starButton4,starButton5,nil];
    
    starButton1.tag = 1;
    starButton2.tag = 2;
    starButton3.tag = 3;
    starButton4.tag = 4;
    starButton5.tag = 5;
    score = 5;
    
    self.contentField.placeholder = @"我也说两句";
    __unsafe_unretained LQPostCommentViewController* weakSelf = self;
    // setup pull-to-refresh
    [self.commentsTableView addPullToRefreshWithActionHandler:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [weakSelf loadData];
        });
    }];
    
    [self.commentsTableView addInfiniteScrollingWithActionHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [weakSelf loadMoreData];
        });
    }];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    //[activitySearchBar resignFirstResponder];
    [self.contactField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (IBAction)onSubmit:(id)sender{
    //NSString* contact = self.contactField.text;
    NSString* content = self.contentField.text;
    
    if (content.length == 0){
        [LocalString(@"comment.error.nocontent") showToastAsInfo];
        return;
    }
    
    [self startLoading];
//    [self.client submitComment:self.gameId comment:content nick:contact];
    [self.client postComment:self.gameId rating:[[NSNumber numberWithInt:score]stringValue]  text:content];
}

- (IBAction)onStarButtonClicked:(id)sender{
    UIButton* button = sender;
    score = button.tag;
    
    for(int i=0;i<score;i++)
    {
        UIButton* tempButton = [starButtons objectAtIndex:i];
        [tempButton setImage:[UIImage imageNamed:@"ico_heart_24.png"] forState:UIControlStateNormal];
        
    }
    
    for(int i=score;i<starButtons.count;i++)
    {
        UIButton* tempButton = [starButtons objectAtIndex:i];
        [tempButton setImage:[UIImage imageNamed:@"ico_heart2_24.png.png"] forState:UIControlStateNormal];
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField == self.contactField){
//        [self.contentField becomeFirstResponder];
//    }else{
//        [textField resignFirstResponder];
//    }
    [textField resignFirstResponder];
    return YES;
}

- (void)loadUserComments:(NSDictionary*)result{
    NSArray* items = [result objectForKey:@"arr_comment"];
    moreUrl = [result objectForKey:@"more_url"];  
    [self.userComments removeAllObjects];
    [self.userComments addObjectsFromArray:items];
    [self.commentsTableView reloadData];    
    [self.commentsTableView.pullToRefreshView stopAnimating];
//    self.refreshing = NO;
//    self.moreCommentsToLoad = (moreUrl!=nil);
}

- (void)loadUserMoreComments:(NSDictionary*)result{
    NSArray* items = [result objectForKey:@"arr_comment"];
    moreUrl = [result objectForKey:@"more_url"];  
    int oldAppsCount = self.userComments.count;
    int addAppsCount = items.count;
    
    [self.userComments addObjectsFromArray:items];
    __unsafe_unretained LQPostCommentViewController* weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for(int i=oldAppsCount;i<(oldAppsCount+addAppsCount);i++)
        {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        if(indexPaths.count>0){
            [weakSelf.commentsTableView beginUpdates];
            
            [weakSelf.commentsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.commentsTableView endUpdates];
        }
        [weakSelf.commentsTableView.infiniteScrollingView stopAnimating];
    });

}


#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_GETUSERCOMMENTS:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadUserComments:result];
            }
            break;
        case C_COMMAND_GETAPPLISTSOFTGAME_MORE:
            [self endLoading];
            if ([result isKindOfClass:[NSDictionary class]]){
                [self loadUserMoreComments:result];
            }
            break;
        case C_COMMAND_SUBMITCOMMENT:
        {
            NSString* contact = self.contactField.text;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (contact.length > 0){
                [defaults setValue:contact forKey:@"qiyouxi.savedcontact"];
            }
        }
            [self endLoading];
            [LQUtilities AlertWithMessage:LocalString(@"comment.summit.success")];
            //[self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    [self endLoading];
    [super handleNetworkErrorHint];
}

- (void) endLoading{
    [super endLoading];
    [self.commentsTableView.pullToRefreshView stopAnimating];
    [self.commentsTableView.infiniteScrollingView stopAnimating];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
  
    NSDictionary* item = [self.userComments objectAtIndex:indexPath.row];
    cell.comment = item;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
