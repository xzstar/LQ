//
//  QYXCategoryTableViewCell.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQTextIconButton.h"

@interface LQCategoryTableViewCell : UITableViewCell
@property (nonatomic, strong) id gameInfo1;
@property (nonatomic, strong) id gameInfo2;
@property (nonatomic, strong) id gameInfo3;

@property (unsafe_unretained) id delegate;

- (IBAction)onGameButton:(id)sender;

@end

@interface LQCategoryTableViewCell()
@property (unsafe_unretained) IBOutlet LQTextIconButton* gameButton1;
@property (unsafe_unretained) IBOutlet LQTextIconButton* gameButton2;
@property (unsafe_unretained) IBOutlet LQTextIconButton* gameButton3;
@end


@interface NSObject(QYXCategoryTableViewCellDelegate)
- (void)QYXCategoryTableViewCell:(LQCategoryTableViewCell*)cell selectGameId:(int)gameId;
@end