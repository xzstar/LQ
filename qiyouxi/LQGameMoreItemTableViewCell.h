//
//  LQGameMoreItemTableViewCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 微云即趣科技有限公司. All rights reserved.
//

#import "LQHistoryTableViewCell.h"

@interface LQGameMoreItemTableViewCell : LQHistoryTableViewCell
@property (unsafe_unretained) IBOutlet UIView* gameActionView;

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
@end
