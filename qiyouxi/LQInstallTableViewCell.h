//
//  QYXInstallTableViewCell.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQInstallTableViewCell : UITableViewCell<LQImageReceiver>
@property (unsafe_unretained) IBOutlet UIImageView* gameIconView;
@property (unsafe_unretained) IBOutlet UILabel* gameNameLabel;
@property (unsafe_unretained) IBOutlet UILabel* gameDetailLabel;

@property (unsafe_unretained) IBOutlet UIButton* actionButton;
@property (unsafe_unretained) IBOutlet UIButton* cancelButton;

@property (nonatomic, strong) QYXDownloadObject* downloadObject;

- (IBAction)onActionButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;

@end
