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

@property (strong) NSMutableArray* userComments;

@end

@implementation LQPostCommentViewController
@synthesize gameId;

@synthesize contactField;
@synthesize contentField;
@synthesize commentsTableView;
@synthesize userComments;
@synthesize gameScore;
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
