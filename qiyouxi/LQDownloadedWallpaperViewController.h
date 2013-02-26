//
//  LQDownloadedWallpaperViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-22.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQViewController.h"

@interface LQDownloadedWallpaperViewController : LQViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray* appsList;
    NSMutableArray* deleteList;

    int state; 
    BOOL isWaitingDeleteActionFinished;
}
@property (unsafe_unretained) IBOutlet UITableView* applicaitonView;
@property (unsafe_unretained) IBOutlet UILabel* title;
@property (nonatomic,strong) NSString* titleString;
@property (nonatomic, strong) UIViewController* parent;
@property (unsafe_unretained) IBOutlet UIButton* modifyButton;
@property (unsafe_unretained) IBOutlet UIButton* deleteButton;
@property (unsafe_unretained) IBOutlet UIButton* backButton;
-(IBAction)onBack:(id)sender;
-(IBAction)onModify:(id)sender;
-(IBAction)onDelete:(id)sender;
@end
