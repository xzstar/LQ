//
//  SinaWeiboConstants.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/22/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#ifndef KRShare_ios_sdk_SinaWeiboConstants_h
#define KRShare_ios_sdk_SinaWeiboConstants_h

#define SinaWeiboSdkVersion                @"2.0"
#define kSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"
#define kSinaWeiboSDKAPIDomain             @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL        @"https://open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"


#define TencentWeiboSdkVersion                @"2.0"
#define kTencentWeiboSDKErrorDomain           @"TCSDKErrorDomain"
#define kTencentWeiboSDKErrorCodeKey          @"TCSDKErrorCodeKey"
#define kTencentWeiboSDKAPIDomain             @"https://open.t.qq.com/api/"
#define kTencentWeiboSDKOAuth2APIDomain       @"https://open.t.qq.com/cgi-bin/oauth2/"
#define kTencentWeiboWebAuthURL               @"https://open.t.qq.com/cgi-bin/oauth2/authorize/ios"
#define kTencentWeiboWebAccessTokenURL        @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTencentWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kTencentWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"


//#define DoubanBroadSdkVersion                @"2.0"
//#define kDoubanBroadSDKErrorDomain           @"DoubanSDKErrorDomain"
//#define kDoubanBroadSDKErrorCodeKey          @"DoubanSDKErrorCodeKey"
//#define kDoubanBroadSDKAPIDomain             @"https://api.douban.com/"
//#define kDoubanBroadSDKOAuth2APIDomain       @"https://www.douban.com/service/auth2/"
//#define kDoubanBroadWebAuthURL               @"https://www.douban.com/service/auth2/auth"
//#define kDoubanBroadWebAccessTokenURL        @"https://www.douban.com/service/auth2/token"
//#define kDoubanBroadAppAuthURL_iPhone        @"sinaweibosso://login"
//#define kDoubanBroadAppAuthURL_iPad          @"sinaweibohdsso://login"
//
//
//#define RenrenBroadSdkVersion                @"3.0"
//#define kRenrenBroadSDKErrorDomain           @"RenrenSDKErrorDomain"
//#define kRenrenBroadSDKErrorCodeKey          @"RenrenSDKErrorCodeKey"
//#define kRenrenBroadSDKAPIDomain             @"http://api.renren.com/"
//#define kRenrenBroadSDKOAuth2APIDomain       @"http://graph.renren.com/oauth/"
//#define kRenrenBroadWebAuthURL               @"http://graph.renren.com/oauth/authorize"
//#define kRenrenBroadWebAccessTokenURL        @"https://graph.renren.com/oauth/token"
//#define kRenrenBroadAppAuthURL_iPhone        @"sinaweibosso://login"
//#define kRenrenBroadAppAuthURL_iPad          @"sinaweibohdsso://login"

#define kKRShareRequestTimeOutInterval 120.0f


typedef enum
{
	kSinaWeiboSDKErrorCodeParseError       = 200,
	kSinaWeiboSDKErrorCodeSSOParamsError   = 202,
} SinaWeiboSDKErrorCode;

#endif
