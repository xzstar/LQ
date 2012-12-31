//
//  LQAdTableViewCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import "LQAdTableViewCell.h"

@implementation LQAdTableViewCell
@synthesize advView;

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
- (void) setDelegate:(id) delegate{
    advView.delegate = delegate;
}

@end
