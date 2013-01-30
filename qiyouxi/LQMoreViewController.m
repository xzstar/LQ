//
//  LQMoreViewController.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-30.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import "LQMoreViewController.h"
#import "LQAboutViewController.h"
@interface LQMoreViewController ()

@end

@implementation LQMoreViewController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onAbout:(id)sender{
    LQAboutViewController* controller = [[LQAboutViewController alloc] initWithNibName:@"LQAboutViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onLogoff:(id)sender{
    system("killall SpringBoard");
}

@end
