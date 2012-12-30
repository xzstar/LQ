//
//  QYXHistoryTableSectionHeader.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQHistoryTableSectionHeader.h"

@implementation LQHistoryTableSectionHeader
@synthesize dayLabel, weekLabel, monthLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDate:(NSDate*)date{
    
    UIColor* colors[7] = {
        [UIColor colorWithHexString:@"0xff17a8c7"],  
        [UIColor colorWithHexString:@"0xff007ef3"],  
        [UIColor colorWithHexString:@"0xff7841e9"],  
        [UIColor colorWithHexString:@"0xffdd6809"],  
        [UIColor colorWithHexString:@"0xffd01010"],  
        [UIColor colorWithHexString:@"0xff22ac38"],  
        [UIColor colorWithHexString:@"0xffb84766"],  
    };

    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSDayCalendarUnit|NSWeekdayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%.2d", components.day];
    self.weekLabel.text = [[LocalString(@"label.week") componentsSeparatedByString:@","] objectAtIndex:components.weekday-1];
    self.monthLabel.text = [NSString stringWithFormat:LocalString(@"label.month"), components.year, components.month];
    
    self.backgroundColor = colors[components.weekday -1];

}

@end
