//
//  LQTopicSectionHeader.h
//  liqu
//
//  Created by Xie Zhe on 13-1-21.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQTopicSectionHeader : UIView<LQImageReceiver>

@property (nonatomic,unsafe_unretained) IBOutlet UIImageView* iconImageView;
@property (nonatomic,unsafe_unretained) IBOutlet UILabel* nameLabel;
@property (nonatomic,unsafe_unretained) IBOutlet UILabel* descLabel;

- (void)setTopicHeaderInfo:(NSString*)iconUrl name:(NSString*)name desc:(NSString*) desc;

@end
