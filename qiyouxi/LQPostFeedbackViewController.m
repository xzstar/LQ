//
//  QYXPostFeedbackViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQPostFeedbackViewController.h"

@interface LQPostFeedbackViewController ()

@end

@implementation LQPostFeedbackViewController
@synthesize contactField;
@synthesize contentField, contentPlaceholder;

- (IBAction)onPostFeedback:(id)sender{    
    NSString* contact = self.contactField.text;
    NSString* content = self.contentField.text;
        
    if (contact.length == 0){
        [LocalString(@"feedback.error.nocontact") showToastAsInfo];
        return;
    }
    
    if (content.length == 0){
        [LocalString(@"feedback.error.nocontent") showToastAsInfo];
        return;
    }
    
    [self startLoading];
    [self.client submitFeedback:content contact:contact];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.contactField){
        [self.contentField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.contentPlaceholder.hidden = textView.text.length > 0;    
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_SUBMITFEEDBACK:
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
