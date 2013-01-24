//
//  KRShare.h
//  KRShareKit
//
//  Created by 519968211 on 13-1-9.
//  Copyright (c) 2013年 519968211. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRShareAuthorizeView.h"
#import "KRShareRequest.h"

#define kSinaWeiboAppKey             @"2330639301"//@"1806671160" //
#define kSinaWeiboAppSecret          @"b40da38bc76d70a2ffcd1f4f7a754390" //@"bfe68d7af6dbf5b67a11c9c7a6849395" //
#define kSinaWeiboAppRedirectURI     @"http://weibo.com/u/3195606297"

#define kTencentWeiboAppKey             @"801291903" //@"100363913" //
#define kTencentWeiboAppSecret          @"0cba6f47ac642efc970877d03b2b1891" //@"835add44c1ca78e530036cda20684241"//
#define kTencentWeiboAppRedirectURI     @"https://itunes.apple.com/cn/app/zhong-guo-ying-lou/id541608192?mt=8"

#define kDoubanBroadAppKey             @"0077a5c719af2a470166f1554d0d7ed5"
#define kDoubanBroadAppSecret          @"e624d4fab3356f0a"
#define kDoubanBroadAppRedirectURI     @"http://www.qq.com"

#define kRenrenBroadAPPID             @"223954"
#define kRenrenBroadAppKey             @"bdc9de15d9084d3c81bfbcac2bb56425"
#define kRenrenBroadAppSecret          @"adc75e9663a64df292fbe75369b8167e"
#define kRenrenBroadAppRedirectURI     @"http://widget.renren.com/callback.html"


enum
{
    KRShareTargetSinablog = 0,
    KRShareTargetTencentblog,
    KRShareTargetDoubanblog,
    KRShareTargetRenrenblog
};
typedef NSInteger KRShareTarget;

@protocol KRShareDelegate;

@interface KRShare : NSObject <KRShareAuthorizeViewDelegate, KRShareRequestDelegate>
{
    KRShareTarget shareTarget;
    KRShare *instance;
    
    NSString *userID;
    NSString *accessToken;
    NSDate *expirationDate;
    id<KRShareDelegate> delegate;
    
    NSString *appKey;
    NSString *appSecret;
    NSString *appRedirectURI;
    NSString *ssoCallbackScheme;
    
    KRShareRequest *request;
    NSMutableSet *requests;
    BOOL ssoLoggingIn;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *ssoCallbackScheme;
@property (nonatomic, assign) id<KRShareDelegate> delegate;
@property KRShareTarget shareTarget;


+ (id)sharedInstanceWithTarget:(KRShareTarget)target;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<KRShareDelegate>)delegate;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<KRShareDelegate>)delegate;


- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;

// Log in using OAuth Web authorization.
// If succeed, sinaweiboDidLogIn will be called.
- (void)logIn;

// Log out.
// If succeed, sinaweiboDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;


// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;

- (KRShareRequest*)requestWithURL:(NSString *)url
                             params:(NSMutableDictionary *)params
                         httpMethod:(NSString *)httpMethod
                           delegate:(id<KRShareRequestDelegate>)delegate;

@end


@protocol KRShareDelegate <NSObject>

@optional

- (void)KRShareDidLogIn:(KRShare *)sinaweibo;
- (void)KRShareDidLogOut:(KRShare *)sinaweibo;
- (void)KRShareLogInDidCancel:(KRShare *)sinaweibo;
- (void)KRShareWillBeginRequest:(KRShareRequest *)request;
- (void)krShare:(KRShare *)krShare logInDidFailWithError:(NSError *)error;
- (void)krShare:(KRShare *)krShare accessTokenInvalidOrExpired:(NSError *)error;

@end

extern BOOL KRShareIsDeviceIPad();
