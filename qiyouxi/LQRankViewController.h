//
//  LQRankViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQCommonTableViewController.h"
@interface LQRankViewController : LQCommonTableViewController

-(void) onChangeRank:(id)sender;
@end


@class AudioPlayer;
@interface LQRingRankViewController : LQRankViewController{
    AudioPlayer *_audioPlayer;
}
@property(nonatomic,strong)NSString* curUrl;
@end

@interface LQWallpaperRankViewController : LQRankViewController

@end