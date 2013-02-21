//
//  LQSMSRingReplaceViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQSMSRingReplaceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary* toneDictory;
    int selectedRow;
}
@property(nonatomic,strong) LQGameInfo* ringGameInfo;
-(IBAction)onReplaceRing:(id)sender;

-(IBAction)onBack:(id) sender;

@end
