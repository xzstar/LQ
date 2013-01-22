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
}
@property (unsafe_unretained) IBOutlet UITableView* applicaitonView;

-(IBAction)onBack:(id)sender;


@end
