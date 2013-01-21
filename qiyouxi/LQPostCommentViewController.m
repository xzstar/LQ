//
//  QYXPostCommentViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQPostCommentViewController.h"
#import "LQCommentTableViewCell.h"

@interface LQPostCommentViewController ()
{
    NSArray* starButtons;
    int score;
}
@property (strong) NSMutableArray* userComments;

@end

@implementation LQPostCommentViewController
@synthesize gameId;

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

- (void)viewDidLoad{
    if(self.userComments == nil)
        self.userComments = [NSMutableArray array];
    [self.client loadUserComments:gameId];
    gameScore.text = scoreString;
    
    if(starButtons == nil)
        starButtons = [NSArray arrayWithObjects:starButton1,starButton2,starButton3,starButton4,starButton5,nil];
    
    starButton1.tag = 1;
    starButton2.tag = 2;
    starButton3.tag = 3;
    starButton4.tag = 4;
    starButton5.tag = 5;
}

- (IBAction)onSubmit:(id)sender{
    NSString* contact = self.contactField.text;
    NSString* content = self.contentField.text;
    
    if (content.length == 0){
        [LocalString(@"comment.error.nocontent") showToastAsInfo];
        return;
    }
    
    [self startLoading];
//    [self.client submitComment:self.gameId comment:content nick:contact];
    [self.client postComment:self.gameId rating:@"5" text:content];
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
    if (textField == self.contactField){
        [self.contentField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)loadUserComments:(NSDictionary*)result{
    NSArray* items = [result objectForKey:@"arr_comment"];
    NSString* moreUrl = [result objectForKey:@"more_url"];  
    [self.userComments addObjectsFromArray:items];
    [self.commentsTableView reloadData];    
    
//    self.refreshing = NO;
//    self.moreCommentsToLoad = (moreUrl!=nil);
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
            
        case C_COMMAND_SUBMITCOMMENT:
        {
            NSString* contact = self.contactField.text;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (contact.length > 0){
                [defaults setValue:contact forKey:@"qiyouxi.savedcontact"];
            }
        }
            [self endLoading];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    [self endLoading];
    [super handleNetworkErrorHint];
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
