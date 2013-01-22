//
//  LQWallpaperViewControllerViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQViewController.h"

@interface LQWallpaperViewController : LQViewController<LQImageReceiver>{
    NSString* imageUrl;
    BOOL hidden;
    NSString* titleString;
}

@property(nonatomic,strong) LQGameInfo *gameInfo;
@property(nonatomic,strong) NSString* imageUrl;
@property(nonatomic,strong) NSString* titleString;

@property(nonatomic,unsafe_unretained) IBOutlet UIImageView* imageView;
@property(nonatomic,unsafe_unretained) IBOutlet UIButton* fullScreenButton;
@property(nonatomic,unsafe_unretained) IBOutlet UIButton* setWallpaperButton;
@property(nonatomic,unsafe_unretained) IBOutlet UIButton* downloadButton;
@property(nonatomic,unsafe_unretained) IBOutlet UIView* topView;
@property(nonatomic,unsafe_unretained) IBOutlet UIView* bottomView;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel*
title;

-(IBAction) onBack:(id)sender;
-(IBAction) onSetWallpaperClick:(id)sender;
-(IBAction) onDownloadClick:(id)sender;
-(IBAction) onHideToolbarClick:(id)sender;
@end
