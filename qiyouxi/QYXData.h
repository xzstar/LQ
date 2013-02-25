//
//  QYXData.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQGameInfo : NSObject
@property (nonatomic, assign) int gameId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* size;

@property (nonatomic, strong) NSString* evaluatorComment;
@property (nonatomic, strong) NSString* evaluatorNickName;
@property (nonatomic, strong) NSString* evaluatorAvatar;

@property (nonatomic, assign) BOOL screenShotIsHorizontal;
@property (nonatomic, strong) NSArray* screenShotsSmall;
@property (nonatomic, strong) NSArray* screenShotsBig;

@property (nonatomic, assign) int commentCount;

@property (nonatomic, strong) NSString* downloadUrl;
@property (nonatomic, strong) NSString* downloadNumber;
@property (nonatomic, strong) NSString* package;
@property (nonatomic, strong) NSString* shareUri;

@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* versionCode;
@property (nonatomic, strong) NSString* tags;
@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSString* rating;
@property (nonatomic, strong) NSString* requestUrl;
//专题用
@property (nonatomic, strong) NSString* intro;
@property (nonatomic, strong) NSString* date;

//类型:soft,game,ring,wallpaper
@property (nonatomic, strong) NSString* fileType;

//分享用图
@property (nonatomic, strong) NSString* photo;

- (id)initWithAPIResult:(NSDictionary*)result;

@end
