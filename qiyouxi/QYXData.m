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

@synthesize downloadUrl,downloadNumber;

@synthesize package;

@synthesize imageUrl,versionCode,tags,price,rating;

@synthesize intro,date;

@synthesize requestUrl;
@synthesize fileType;
@synthesize shareUri;
@synthesize photo;

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
        NSArray* screenshots = [result objectForKey:@"arr_photo"];
        for (NSString* screenshot in screenshots){
            [imageUrls addObject:screenshot];
        }
        
        self.screenShotsSmall = imageUrls;
        
//        NSArray* screenshots = [result objectForKey:@"screenshots"];
//        for (NSDictionary* screenshot in screenshots){
//            [imageUrls addObject:[screenshot objectForKey:@"small"]];
//        }
//        
//        self.screenShotsSmall = imageUrls;
//        
//        imageUrls = [NSMutableArray array];
//        for (NSDictionary* screenshot in screenshots){
//            [imageUrls addObject:[screenshot objectForKey:@"big"]];
//        }
//        self.screenShotsBig = imageUrls;
        
        self.commentCount = [[result objectForKey:@"comment_count"] intValue];
        
        self.downloadUrl = [result objectForKey:@"downloadUri"];
        self.downloadNumber = [result objectForKey:@"downloadNum"];
        self.package = [result objectForKey:@"package"];
        self.shareUri = [result objectForKey:@"shareUri"];
//        self.downloadUrl = @"http://172.16.96.53/~wangqing/ukongarith.ipa";
//        self.package = @"com.ukongame.UKongArithZh";// [result objectForKey:@"package"];
        

        self.imageUrl = [result objectForKey:@"image_url"];
        self.versionCode = [result objectForKey:@"versionName"];
        self.tags= [result objectForKey:@"tags"];
        self.price = [result objectForKey:@"price"];
        self.rating = [result objectForKey:@"rating"];
        self.intro = [result objectForKey:@"Intro"];
        self.date = [result objectForKey:@"date"];
        self.requestUrl = [result objectForKey:@"request_url"];
        self.photo = [result objectForKey:@"Photo"];
        NSString* rootCat = [result objectForKey:@"RootCat"];
        
        if([rootCat isEqualToString:@"手机软件"]){
            self.fileType = @"soft";
        }
        else if([rootCat isEqualToString:@"手机游戏"]){
            self.fileType = @"game";
        }
        else if([rootCat isEqualToString:@"手机壁纸"]){
            self.fileType = @"wallpaper";
            self.package = self.name ;
        }
        else if([rootCat isEqualToString:@"手机铃声"]){
            self.fileType = [result objectForKey:@"ring_type"];
            self.package = self.name ;
        }
        else {
            //如果都没有找到就用后缀方式设置
            NSRange range = [downloadUrl rangeOfString:@".jpg"];
            if([result objectForKey:@"ring_type"]){
                self.fileType = [result objectForKey:@"ring_type"];
                self.package = self.name ;
                
            }
            else if(range.location == (downloadUrl.length-4) && range.length>0){
                self.fileType = @"wallpaper";
                self.package = self.name
                ;
            }
            else{
                self.fileType = @"soft";
            }
        }
    }
    return self;
}

@end
