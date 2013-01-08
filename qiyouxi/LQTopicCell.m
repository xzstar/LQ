//
//  LQTopicCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-8.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTopicCell.h"

@implementation LQTopicCell
@synthesize gameIconView, gameDetailLabel, gameTitleLabel,gameComments;
@synthesize gameInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameInfo:(id)aGameInfo{
    gameInfo = aGameInfo;
    self.gameTitleLabel.text = self.gameInfo.name;
    
    self.gameDetailLabel.text = self.gameInfo.intro;
    
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:self.gameInfo.icon context:self];
    if (image != nil){
        self.gameIconView.image = image;
    }else {
        self.gameIconView.image = [UIImage imageNamed:@"icon_small.png"];
    }
    
    self.gameComments.text = [NSString stringWithFormat:@"更新时间: %@",self.gameInfo.date];
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if ([self.gameInfo.icon isEqualToString:imageUrl]){
        self.gameIconView.image = image;
    }
}

@end
