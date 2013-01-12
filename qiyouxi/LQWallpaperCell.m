//
//  LQWallpaperCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-12.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQWallpaperCell.h"
#import "QYXData.h"
@implementation LQWallpaperCell
@synthesize button1,button2,button3,button4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        buttonList = [NSArray arrayWithObjects:button1,button2,button3,button4, nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setButtonInfo:(NSArray*) infoList{
    int i =0;
    gameInfoList = infoList;
    if(buttonList==nil)
        buttonList = [NSArray arrayWithObjects:button1,button2,button3,button4, nil];
    
    UIImage* defaultImage = [UIImage imageNamed:@"icon_small.png"] ;
    for (;i<infoList.count && i<buttonList.count;i++) {
        LQGameInfo* gameInfo = [infoList objectAtIndex:i];
        UIButton* button = [buttonList objectAtIndex:i];
        UIImage* image = [[LQImageLoader sharedInstance] loadImage:gameInfo.icon context:self];
        if (image != nil){
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }else {
            [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
        }
    }
    
    for (;i<buttonList.count;i++){
        UIButton* button = [buttonList objectAtIndex:i];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    for(int i=0;i<gameInfoList.count;i++)
    {
        LQGameInfo* info = [gameInfoList objectAtIndex:i];
        if(info.icon == imageUrl){
            if(i<buttonList.count){
                UIButton *button = [buttonList objectAtIndex:i];
                [button setBackgroundImage:image forState:UIControlStateNormal];
           }
            break;
        }
    }
}
@end
