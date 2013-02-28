//
//  LQWebViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-2-28.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQWebViewController.h"

@interface LQWebViewController ()

@end

@implementation LQWebViewController
@synthesize backButton;
@synthesize webView;
@synthesize url;
@synthesize titleString;
@synthesize titleLabel;
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
    self.titleLabel.text = titleString;
    
    NSURL* requestUrl = [NSURL URLWithString:url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
    [webView setDelegate:self];  
    
    //创建UIActivityIndicatorView背底半透明View 
    CGRect frame = webView.frame;
    UIView *view = [[UIView alloc] initWithFrame:frame];  
    [view setTag:103];  
    [view setBackgroundColor:[UIColor blackColor]];  
    [view setAlpha:0.8];  
    [self.view addSubview:view]; 
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];  
    [activityIndicator setCenter:self.view.center];  
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];  
    [self.view addSubview:activityIndicator];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc{
    [webView setDelegate:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];          

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];     
    UIView *view = (UIView *)[self.view viewWithTag:103];  
    [view removeFromSuperview];  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activityIndicator stopAnimating];     
    [LQUtilities AlertWithMessage:[error description]];
}

@end
