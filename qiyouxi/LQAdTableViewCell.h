//
//  LQAdTableViewCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQAdvertiseView.h"
@interface LQAdTableViewCell : UITableViewCell
@property (unsafe_unretained) IBOutlet LQAdvertiseView* advView;

- (void) setDelegate:(id) delegate;
@end
