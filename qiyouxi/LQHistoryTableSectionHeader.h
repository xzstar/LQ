//
//  QYXHistoryTableSectionHeader.h
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQHistoryTableSectionHeader : UIView
- (void)setDate:(NSDate*)date;
@end


@interface LQHistoryTableSectionHeader()
@property (unsafe_unretained) IBOutlet UILabel* dayLabel;
@property (unsafe_unretained) IBOutlet UILabel* weekLabel;
@property (unsafe_unretained) IBOutlet UILabel* monthLabel;
@end