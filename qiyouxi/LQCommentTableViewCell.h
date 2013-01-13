//
//  QYXCommentTableViewCellCell.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQCommentTableViewCell : UITableViewCell<LQImageReceiver>

@property (unsafe_unretained) IBOutlet UILabel* nickLabel;
@property (unsafe_unretained) IBOutlet UILabel* commentLabel;
@property (unsafe_unretained) IBOutlet UILabel* deviceLabel;
@property (unsafe_unretained) IBOutlet UILabel* dateLabel;
@property (unsafe_unretained) IBOutlet UIView* bottomView;
@property (unsafe_unretained) IBOutlet UIImageView* avatar;
@property (nonatomic, strong) NSDictionary* comment;

@end
