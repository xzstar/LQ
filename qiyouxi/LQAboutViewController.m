//
//  LQAboutViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQAboutViewController.h"
#import "LQUtilities.h"
#import "KRShare.h"

@interface LQAboutViewController ()

@end

@implementation LQAboutViewController

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

- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onQQWeibo:(id)sender{
    _krShare  = [KRShare sharedInstanceWithTarget:KRShareTargetTencentblog];
    _krShare.delegate = self;
    [_krShare logIn];

}

- (IBAction)onSinaWeibo:(id)sender{
    _krShare  = [KRShare sharedInstanceWithTarget:KRShareTargetSinablog];
    _krShare.delegate = self;
    [_krShare logIn];

}

#pragma mark - SinaWeibo Delegate
- (void)removeAuthData
{
    if(_krShare.shareTarget == KRShareTargetSinablog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Sina"];
    }
    else if(_krShare.shareTarget == KRShareTargetTencentblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Tencent"];
    }
    else if(_krShare.shareTarget == KRShareTargetDoubanblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Douban"];
    }
    else if(_krShare.shareTarget == KRShareTargetRenrenblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Renren"];
    }
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _krShare.accessToken, @"AccessTokenKey",
                              _krShare.expirationDate, @"ExpirationDateKey",
                              _krShare.userID, @"UserIDKey",
                              _krShare.refreshToken, @"refresh_token", nil];
    
    if(_krShare.shareTarget == KRShareTargetSinablog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Sina"];
    }
    else if(_krShare.shareTarget == KRShareTargetTencentblog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Tencent"];
    }
    else if(_krShare.shareTarget == KRShareTargetDoubanblog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Douban"];
    }
    else if(_krShare.shareTarget == KRShareTargetRenrenblog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"KRShareAuthData-Renren"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)KRShareDidLogIn:(KRShare *)krShare
{
    NSString* shareText = @"我在使用#历趣助手#,你也可以试试哦";
    [self storeAuthData];
    if(krShare.shareTarget == KRShareTargetSinablog)
    {
        [_krShare requestWithURL:@"statuses/upload.json"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  shareText, @"status",
                                  [UIImage imageNamed:@"icon.png"], @"pic", nil]
                      httpMethod:@"POST"
                        delegate:self];
        
        [_krShare requestWithURL:@"statuses/update.json"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"test 这是我分享", @"status",
                                   nil]
                      httpMethod:@"POST"
                        delegate:self];
    }
    
    if(krShare.shareTarget == KRShareTargetTencentblog)
    {
        [krShare requestWithURL:@"t/add_pic"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 shareText, @"content",
                                 @"json",@"format",
                                 @"221.232.172.30",@"clientip",
                                 @"all",@"scope",
                                 krShare.userID,@"openid",
                                 @"ios-sdk-2.0-publish",@"appfrom",
                                 @"0",@"compatibleflag",
                                 @"2.a",@"oauth_version",
                                 kTencentWeiboAppKey,@"oauth_consumer_key",
                                 [UIImage imageNamed:@"icon.png"], @"pic", nil]
                     httpMethod:@"POST"
                       delegate:self];
//        [krShare requestWithURL:@"t/add"
//                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"abcd", @"content",
//                                 @"json",@"format",
//                                 @"123.108.223.42",@"clientip",
//                                 @"all",@"scope",
//                                 krShare.userID,@"openid",
//                                 @"ios-sdk-2.0-publish",@"appfrom",
//                                 @"0",@"compatibleflag",
//                                 @"2.a",@"oauth_version",
//                                 kTencentWeiboAppKey,@"oauth_consumer_key",
//                                 krShare.accessToken,@"access_token",
//                                 nil]
//                     httpMethod:@"POST"
//                       delegate:self];    
            }
    if(krShare.shareTarget == KRShareTargetDoubanblog)
    {
        [krShare requestWithURL:@"shuo/v2/statuses"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"这是我分享的图片", @"text",
                                 kDoubanBroadAppKey,@"source",
                                 [UIImage imageNamed:@"Default.png"], @"image", nil]
                     httpMethod:@"POST"
                       delegate:self];
    }
    if(krShare.shareTarget == KRShareTargetRenrenblog)
    {
        [krShare requestWithURL:@"restserver.do"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"1.0",@"v",
                                 @"这是我分享的图片", @"caption",
                                 @"json",@"format",
                                 @"method",@"photos.upload",
                                 @"file",@"upload",
                                 kRenrenBroadAppKey,@"api_key",
                                 [UIImage imageNamed:@"Default.png"], @"image", nil]
                     httpMethod:@"POST"
                       delegate:self];
    }
    
}

- (void)KRShareDidLogOut:(KRShare *)sinaweibo
{
    [self removeAuthData];
}

- (void)KRShareLogInDidCancel:(KRShare *)sinaweibo
{
}

- (void)krShare:(KRShare *)krShare logInDidFailWithError:(NSError *)error
{
}

- (void)krShare:(KRShare *)krShare accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
}

- (void)KRShareWillBeginRequest:(KRShareRequest *)request
{
    //_loadingView.hidden = NO;
}

-(void)request:(KRShareRequest *)request didFailWithError:(NSError *)error
{
    //_loadingView.hidden = YES;
    
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [LQUtilities AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        [LQUtilities AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        [LQUtilities AlertWithMessage:@"发表人人网相片失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
}


- (void)request:(KRShareRequest *)request didFinishLoadingWithResult:(id)result
{
    //_loadingView.hidden = YES;
    
    //新浪微博响应
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        if([[result objectForKey:@"error_code"] intValue]==20019)
        {
            [LQUtilities AlertWithMessage:@"发送频率过高，请您过会再发"];
        }
        else if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发送微博成功"];
        }
    }
    //腾讯微博响应
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        if([[result objectForKey:@"errcode"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表微博成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表微博失败"];
        }
    }
    //豆瓣说响应
    else if ([request.url hasSuffix:@"shuo/v2/statuses"])
    {
        if([[result objectForKey:@"code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表豆瓣说成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表豆瓣说失败"];
        }
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [LQUtilities AlertWithMessage:@"发表人人网相片成功"];
        }
        else{
            NSLog(@"%@",result);
            [LQUtilities AlertWithMessage:@"发表人人网相片失败"];
        }
    }
}

@end
