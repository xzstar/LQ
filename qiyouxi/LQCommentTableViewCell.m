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
@synthesize commentLabel,nickLabel,deviceLabel,dateLabel;
@synthesize bottomView;
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
    
    

    
    self.nickLabel.text = nick;
    self.commentLabel.text = [aComment objectForKey:@"data"];
    [self.commentLabel autowrap:INT_MAX];
    
    self.deviceLabel.text = [aComment objectForKey:@"device"];
    self.dateLabel.text = [aComment objectForKey:@"date"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat bottom = self.commentLabel.frame.origin.y + self.commentLabel.frame.size.height;
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y = bottom;
    self.bottomView.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize calSize = [super sizeThatFits:size];
    calSize.height = self.bottomView.frame.origin.y + self.bottomView.frame.size.height + 2.0;
    return calSize;
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    [avatar setImage:[image scaleToSize:CGSizeMake(50.0f, 50.0f)]];
}

@end
