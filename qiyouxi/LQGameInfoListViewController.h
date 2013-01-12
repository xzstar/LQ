//
//  LQGameInfoListViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQViewController.h"
#import "LQCommonTableViewController.h"
#import "AudioCell.h"
#import "AudioPlayer.h"


@interface LQGameInfoListViewController : LQCommonTableViewController{
    int type;
}
@property (nonatomic,assign) int type;
@end

@class AudioPlayer;

@interface LQRingListViewController : LQGameInfoListViewController{
    AudioPlayer *_audioPlayer;
}
@end