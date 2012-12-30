//
//  QYXCommentTableViewCellCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQCommentTableViewCell.h"

@implementation LQCommentTableViewCell
@synthesize comment;
@synthesize commentLabel,nickLabel,deviceLabel,dateLabel;
@synthesize bottomView;

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
    
    NSString* nick = [aComment objectForKey:@"nickname"];
    if (nick.length == 0){
        nick = LocalString(@"nick.default");
    }
    
    self.nickLabel.text = nick;
    self.commentLabel.text = [aComment objectForKey:@"comment"];
    [self.commentLabel autowrap:INT_MAX];
    
    self.deviceLabel.text = [aComment objectForKey:@"device"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    long long time = [[aComment objectForKey:@"time"] longLongValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    self.dateLabel.text = [formatter stringFromDate:date];
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



@end
