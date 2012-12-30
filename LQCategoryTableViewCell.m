//
//  QYXCategoryTableViewCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQCategoryTableViewCell.h"

@implementation LQCategoryTableViewCell
@synthesize gameInfo1, gameInfo2, gameInfo3;
@synthesize gameButton1, gameButton2, gameButton3;
@synthesize delegate;

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

- (void)setGameInfo1:(id)aGameInfo{
    gameInfo1 = aGameInfo;
    [self.gameButton1 setTitle:[aGameInfo objectForKey:@"name"] forState:UIControlStateNormal];
    [self.gameButton1 loadImageUrl:[aGameInfo objectForKey:@"icon"] defaultImage:DEFAULT_GAME_ICON];
    self.gameButton1.tag = [[aGameInfo objectForKey:@"id"] intValue];
}

- (void)setGameInfo2:(id)aGameInfo{
    gameInfo2 = aGameInfo;
    self.gameButton2.hidden = aGameInfo == nil;
    [self.gameButton2 setTitle:[aGameInfo objectForKey:@"name"] forState:UIControlStateNormal];
    [self.gameButton2 loadImageUrl:[aGameInfo objectForKey:@"icon"] defaultImage:DEFAULT_GAME_ICON];
    self.gameButton2.tag = [[aGameInfo objectForKey:@"id"] intValue];
}

- (void)setGameInfo3:(id)aGameInfo{
    gameInfo3 = aGameInfo;
    self.gameButton3.hidden = aGameInfo == nil;
    [self.gameButton3 setTitle:[aGameInfo objectForKey:@"name"] forState:UIControlStateNormal];
    [self.gameButton3 loadImageUrl:[aGameInfo objectForKey:@"icon"] defaultImage:DEFAULT_GAME_ICON];
    self.gameButton3.tag = [[aGameInfo objectForKey:@"id"] intValue];
}

- (IBAction)onGameButton:(id)sender{
    UIButton* btn = sender;
    if ([self.delegate respondsToSelector:@selector(QYXCategoryTableViewCell:selectGameId:)]){
        [self.delegate QYXCategoryTableViewCell:self selectGameId:btn.tag];
    }
}

@end
