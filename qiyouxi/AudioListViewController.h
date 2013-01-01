//
//  ViewController.h
//  AudioPlayerDemo
//
//  Created by Lin Zhang on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
@class AudioPlayer;

@interface AudioListViewController : LQViewController <UITableViewDelegate, UITableViewDataSource>
{
    AudioPlayer *_audioPlayer;
    NSInteger selectedRow;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
