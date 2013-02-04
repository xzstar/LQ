//
//  QYXCommentTableViewCellCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQCommentTableViewCell.h"
#import "UIImage+Scale.h"
@implementation LQCommentTableViewCell
@synthesize comment;
@synthesize commentLabel,nickLabel,dateLabel;
@synthesize avatar;

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

#define CELL_HEIGHT 49
#define COMMENT_HEIGHT 21
- (void)setComment:(NSDictionary *)aComment{
    comment = aComment;
    
    
    UIImage* defaultImage = [UIImage imageNamed:@"soft_detail_comment_cryptonym_icon.png"];
    NSString* avatarUrl = [aComment objectForKey:@"user_icon"];
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:avatarUrl context:self];
    if (image != nil){
        
        [avatar setImage:[image scaleToSize:CGSizeMake(50.0f, 50.0f)]];
        [avatar setImage:defaultImage];
    }
    
    NSString* nick = [aComment objectForKey:@"author"];
    if (nick.length == 0){
        nick = LocalString(@"nick.default");
    }
    self.dateLabel.text = [aComment objectForKey:@"date"];
    self.nickLabel.text = nick;

    
    //先设置成默认
    CGRect frame = self.frame;
    frame.size.height = CELL_HEIGHT;
    self.frame = frame;
    
    frame = self.commentLabel.frame;
    frame.size.height = COMMENT_HEIGHT;
    self.commentLabel.frame = frame;
    
    
    self.commentLabel.text = [aComment objectForKey:@"data"];
    //[self.commentLabel autowrap:INT_MAX];
    
    UIFont *font = [UIFont systemFontOfSize:14];  
    self.commentLabel.numberOfLines = 0;
    NSString *content = self.commentLabel.text;  
    frame = self.commentLabel.frame;
    CGSize size = [content sizeWithFont:font 
                      constrainedToSize:CGSizeMake(frame.size.width, 1000)
                          lineBreakMode:UILineBreakModeWordWrap];  
    
    // 没必要 扩展
    if(size.height<= frame.size.height){
        return;
    }    
    
    frame.size.height = size.height;
    int addHeight = frame.size.height - self.commentLabel.frame.size.height;
    self.commentLabel.frame = frame;
     
    frame = self.frame;
    frame.size.height+=addHeight;
    self.frame = frame;
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize calSize = [super sizeThatFits:size];
    return calSize;
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    [avatar setImage:[image scaleToSize:CGSizeMake(50.0f, 50.0f)]];
}

@end
