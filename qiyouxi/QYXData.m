//
//  QYXData.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "QYXData.h"

@implementation LQGameInfo
@synthesize gameId;
@synthesize name,  icon, category, size;

@synthesize evaluatorComment, evaluatorAvatar, evaluatorNickName;

@synthesize screenShotsBig, screenShotsSmall, screenShotIsHorizontal;

@synthesize commentCount;

@synthesize downloadUrl;

@synthesize package;

@synthesize imageUrl,versionCode,tags,price,rating;

@synthesize intro,date;

@synthesize requestUrl;

- (id)initWithAPIResult:(NSDictionary*)result{
    self = [super init];
    if (self != nil){
        self.gameId = [[result objectForKey:@"id"] intValue];
        
        self.name = [result objectForKey:@"name"];
        self.icon = [result objectForKey:@"icon"];
        self.size = [result objectForKey:@"size"];
        
        NSDictionary* categoryInfo = [result objectForKey:@"category"];
        self.category = [categoryInfo objectForKey:@"name"];
        
        
        NSDictionary* evaluatorInfo = [[result objectForKey:@"evaluators"] objectAtIndex:0];
        
        self.evaluatorComment = [evaluatorInfo objectForKey:@"description"];
        self.evaluatorNickName = [evaluatorInfo objectForKey:@"username"];
        self.evaluatorAvatar = [evaluatorInfo objectForKey:@"icon"];
        
        self.screenShotIsHorizontal = [[result objectForKey:@"screenshot_hr"] boolValue];
        NSMutableArray* imageUrls = [NSMutableArray array];
        NSArray* screenshots = [result objectForKey:@"screenshots"];
        for (NSDictionary* screenshot in screenshots){
            [imageUrls addObject:[screenshot objectForKey:@"small"]];
        }
        
        self.screenShotsSmall = imageUrls;
        
        imageUrls = [NSMutableArray array];
        for (NSDictionary* screenshot in screenshots){
            [imageUrls addObject:[screenshot objectForKey:@"big"]];
        }
        self.screenShotsBig = imageUrls;
        
        self.commentCount = [[result objectForKey:@"comment_count"] intValue];
        
        self.downloadUrl = [result objectForKey:@"download_url"];
        self.package = [result objectForKey:@"package"];
        
//        self.downloadUrl = @"http://172.16.96.53/~wangqing/ukongarith.ipa";
//        self.package = @"com.ukongame.UKongArithZh";// [result objectForKey:@"package"];
        

        self.imageUrl = [result objectForKey:@"image_url"];
        self.versionCode = [result objectForKey:@"versionCode"];
        self.tags= [result objectForKey:@"tags"];
        self.price = [result objectForKey:@"price"];
        self.rating = [result objectForKey:@"rating"];
        self.intro = [result objectForKey:@"Intro"];
        self.date = [result objectForKey:@"date"];
        self.requestUrl = [result objectForKey:@"request_url"];
    }
    return self;
}

@end
