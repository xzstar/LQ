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
@property (nonatomic, strong) NSString* package;

- (id)initWithAPIResult:(NSDictionary*)result;

@end
