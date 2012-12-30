//
//  LQClient.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQClientBase.h"

#define C_COMMAND_GETRECOMMENDATION C_USER_COMMAND + 1
#define C_COMMAND_GETTODAYADVS C_USER_COMMAND + 2
#define C_COMMAND_GETANNOUNCEMENT C_USER_COMMAND + 3
#define C_COMMAND_GETHISTORY C_USER_COMMAND + 4
#define C_COMMAND_GETCATEGORIES C_USER_COMMAND + 5
#define C_COMMAND_GETGAMEOFCATEGORY C_USER_COMMAND + 6
#define C_COMMAND_GETGAMEINFO C_USER_COMMAND + 7
#define C_COMMAND_GETUSERCOMMENTS C_USER_COMMAND + 8
#define C_COMMAND_SUBMITCOMMENT C_USER_COMMAND + 9
#define C_COMMAND_SUBMITFEEDBACK C_USER_COMMAND + 10
#define C_COMMAND_GETLAUNCHIMAGE C_USER_COMMAND + 11


@interface LQClient : LQClientBase
- (void)loadLaunchImage;

- (void)loadTodayRecommendation:(NSDate*)date;
- (void)loadTodayAdvs;
- (void)loadAnnouncement;
- (void)loadHistory:(NSDate*)startDate days:(int)days;
- (void)loadCategories;
- (void)loadGameOfCategory:(int)categoryId start:(int)start count:(int)count;
- (void)loadGameInfo:(int)gameId;

- (void)loadUserComments:(int)gameId start:(int)start count:(int)count;
- (void)submitComment:(int)gameId comment:(NSString*)comment nick:(NSString*)nick;
- (void)submitFeedback:(NSString*)feedback contact:(NSString*)contact;

@end
