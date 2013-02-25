//
//  LQShareViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-2-25.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQShareViewController.h"

@interface LQShareViewController ()

@end

@implementation LQShareViewController
@synthesize shareTextView;
@synthesize shareImageView;
@synthesize krShare;
@synthesize krShareRequestDelegate;
@synthesize shareImageContent;
@synthesize shareTextContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    shareTextView.text = shareTextContent;
    shareImageView.image= shareImageContent;
    [shareTextView becomeFirstResponder];
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

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onSend:(id)sender{
    NSString* finalShareText = shareTextView.text;
    if(krShare.shareTarget == KRShareTargetSinablog)
    {
        [krShare requestWithURL:@"statuses/upload.json"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  finalShareText, @"status",
                                  shareImageView.image, @"pic", nil]
                      httpMethod:@"POST"
                        delegate:krShareRequestDelegate];
        
       
    }
    
    if(krShare.shareTarget == KRShareTargetTencentblog)
    {
        [krShare requestWithURL:@"t/add_pic"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 finalShareText, @"content",
                                 @"json",@"format",
                                 //@"221.232.172.30",@"clientip",
                                 @"all",@"scope",
                                 krShare.currentInfo.userID,@"openid",
                                 @"ios-sdk-2.0-publish",@"appfrom",
                                 @"0",@"compatibleflag",
                                 @"2.a",@"oauth_version",
                                 kTencentWeiboAppKey,@"oauth_consumer_key",
                                 shareImageView.image, @"pic", nil]
                     httpMethod:@"POST"
                       delegate:krShareRequestDelegate];
           
    }

}

@end
