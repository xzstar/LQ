//
//  LQDownloadedRingsViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQViewController.h"
@class AudioPlayer;

@interface LQDownloadedRingsViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>{
    int selectedRow;
    NSMutableArray* appsList;
    AudioPlayer *_audioPlayer;

}
@property (unsafe_unretained) int selectedRow;
@property (unsafe_unretained) IBOutlet UILabel* title;
@property (unsafe_unretained) IBOutlet UITableView* applicaitonView;
@property (unsafe_unretained) IBOutlet UILabel* noItemLabel;
@property (nonatomic,strong) NSString* titleString;

-(IBAction)onBack:(id)sender;
@end
