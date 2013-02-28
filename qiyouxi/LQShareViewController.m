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
@synthesize backgroundImageView;
@synthesize shareWeiboIcon;
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
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    shareTextView.text = shareTextContent;
    shareImageView.image= shareImageContent;
    [shareTextView becomeFirstResponder];
    if(krShare.shareTarget == KRShareTargetSinablog)
    {
        shareWeiboIcon.image = [UIImage imageNamed:@"ico_share_sina_48.png"];
    }
    else if(krShare.shareTarget == KRShareTargetTencentblog)
    {
        shareWeiboIcon.image = [UIImage imageNamed:@"ico_share_qq_48.png"];
    }
    else {
        shareWeiboIcon.image = nil;
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onSend:(id)sender{
    [shareTextView resignFirstResponder];
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

    CGRect frame = backgroundImageView.frame;
    UIView *view = [[UIView alloc] initWithFrame:frame];  
    [view setTag:103];  
    [view setBackgroundColor:[UIColor blackColor]];  
    [view setAlpha:0.8];  
    [self.view addSubview:view]; 
    
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];  
    [activityIndicator setCenter:self.view.center];  
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];  
    [activityIndicator setTag:104];  
    
    [self.view addSubview:activityIndicator];

    [activityIndicator startAnimating];
}

-(void) finishSend{
    UIView *view = (UIView *)[self.view viewWithTag:103];  
    [view removeFromSuperview];  
    UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:104];  
    [activityIndicator stopAnimating];     
    [activityIndicator removeFromSuperview];  

    [shareTextView becomeFirstResponder];

}

@end
