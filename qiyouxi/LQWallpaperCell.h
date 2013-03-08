//
//  LQWallpaperCell.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-12.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WALLPAPER_COUNT_PERLINE 3
@interface LQWallpaperCell : UITableViewCell<LQImageReceiver>
{
    NSArray* buttonList;
    NSArray* gameInfoList;
    NSArray* imageViewList;
}

@property (unsafe_unretained) IBOutlet UIButton* button1;
@property (unsafe_unretained) IBOutlet UIButton* button2;
@property (unsafe_unretained) IBOutlet UIButton* button3;
@property (nonatomic, copy) void (^refreshActionHandler)(int);

@property (unsafe_unretained) IBOutlet UIImageView* delete1;
@property (unsafe_unretained) IBOutlet UIImageView* delete2;
@property (unsafe_unretained) IBOutlet UIImageView* delete3;

@property (unsafe_unretained) IBOutlet UIImageView* image1;
@property (unsafe_unretained) IBOutlet UIImageView* image2;
@property (unsafe_unretained) IBOutlet UIImageView* image3;


-(void) setButtonInfo:(NSArray*) infoList;
-(void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
-(void) hiddenDeleteIcon:(int)index hidden:(BOOL)hidden;
-(BOOL) isDeleteIconHidden:(int)index;
-(void) addRefreshActionHandler:(void (^)(int))actionHandler;
@end
