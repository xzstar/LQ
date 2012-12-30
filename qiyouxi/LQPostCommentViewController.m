//
//  QYXPostCommentViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQPostCommentViewController.h"

@interface LQPostCommentViewController ()

@end

@implementation LQPostCommentViewController
@synthesize gameId;

@synthesize contactField;
@synthesize contentField;

- (void)loadViews{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* contact = [defaults valueForKey:@"qiyouxi.savedcontact"];
    if (contact.length > 0){
        self.contactField.text = contact;
    }
}

- (IBAction)onSubmit:(id)sender{
    NSString* contact = self.contactField.text;
    NSString* content = self.contentField.text;
    
    if (content.length == 0){
        [LocalString(@"comment.error.nocontent") showToastAsInfo];
        return;
    }
    
    [self startLoading];
    [self.client submitComment:self.gameId comment:content nick:contact];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.contactField){
        [self.contentField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}



#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
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

@end
