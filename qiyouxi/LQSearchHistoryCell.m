//
//  LQSearchHistoryCell.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-7.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQSearchHistoryCell.h"

#define SELECTEDIMAGE @"search_cell_bg.png"
#define UNSELECTEDIMAGE @"search_cell_bg_down.png"
@implementation LQSearchHistoryCell
@synthesize type,name,deleteButton,cellBg;
@synthesize hiddenDelButton;
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
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    UIImage* image;
//    if(selected)
//    {
//        image = [UIImage imageNamed:SELECTEDIMAGE];
//    }
//    else {
//        image = [UIImage imageNamed:UNSELECTEDIMAGE];
//    }
//    
//    [cellBg setImage:image];
}

- (void) hiddenDelButton:(BOOL)aHiddenDelButton{
    deleteButton.hidden = aHiddenDelButton;
}

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
    [deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.tag = tag;
}
@end
