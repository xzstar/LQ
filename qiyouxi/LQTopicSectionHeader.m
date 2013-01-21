//
//  LQTopicSectionHeader.m
//  liqu
//
//  Created by Xie Zhe on 13-1-21.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQTopicSectionHeader.h"

@implementation LQTopicSectionHeader
@synthesize nameLabel,descLabel,iconImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setTopicHeaderInfo:(NSString*)iconUrl name:(NSString*)name desc:(NSString*) desc{
   
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:iconUrl context:self];
    if (image != nil){
        self.iconImageView.image = image;
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"icon_small.png"];
    }
    
    self.nameLabel.text = name;
    self.descLabel.text = desc;
    //文字居中显示  
    descLabel.textAlignment = UITextAlignmentLeft;  
    //自动折行设置  
    descLabel.lineBreakMode = UILineBreakModeWordWrap;  
    descLabel.numberOfLines = 0;  
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    self.iconImageView.image = image;
}

@end
