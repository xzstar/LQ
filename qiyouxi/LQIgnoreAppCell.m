//
//  LQIgnoreAppCell.m
//  liqu
//
//  Created by Xie Zhe on 13-1-18.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQIgnoreAppCell.h"

@implementation LQIgnoreAppCell
@synthesize icon,title,deleteButton,gameInfo;
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
- (void)setGameInfo:(LQGameInfo*)aGameInfo{
    gameInfo = aGameInfo;
    
    self.title.text = self.gameInfo.name;
    
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:self.gameInfo.icon context:self];
    if (image != nil){
        self.icon.image = image;
    }else {
        self.icon.image = [UIImage imageNamed:@"icon_small.png"];
    }

}

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
    deleteButton.tag = tag;
    [deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    icon.image = image;
}
@end
