//
//  QYXHistoryTableViewCellCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-31.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQHistoryTableViewCell.h"
#import "LQDownloadManager.h"

@implementation LQHistoryTableViewCell
@synthesize gameIconView, gameDetailLabel, gameTitleLabel, actionButton;
@synthesize gameInfo;
@synthesize gameInfoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameInfo:(id)aGameInfo{
    gameInfo = aGameInfo;
    self.gameTitleLabel.text = self.gameInfo.name;
    self.gameDetailLabel.text = [NSString stringWithFormat:@"%@ | %@MB", self.gameInfo.category, self.gameInfo.size];

    UIImage* image = [[LQImageLoader sharedInstance] loadImage:self.gameInfo.icon context:self];
    if (image != nil){
        self.gameIconView.image = image;
    }else {
        self.gameIconView.image = [UIImage imageNamed:@"icon_small.png"];
    }

    NSString* title = nil;
    UIImage* bgImage = nil;

    
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:self.gameInfo.gameId];
    switch (status) {
        case kQYXDSFailed:
            title = LocalString(@"button.restart");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSCompleted:
            title = LocalString(@"button.install");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSInstalling:
            title = LocalString(@"button.installing");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSPaused:
            title = LocalString(@"button.resume");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSRunning:
            title = LocalString(@"button.pause");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSInstalled:
            title = LocalString(@"button.start");
            bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            break;
        case kQYXDSNotFound:
            if ([[LQDownloadManager sharedInstance] isGameInstalled:self.gameInfo.package]){
                title = LocalString(@"button.start");
                bgImage = [UIImage imageNamed:@"btn_action_left.png"];
            }else{
                title = LocalString(@"button.download");
                bgImage = [UIImage imageNamed:@"btn_download.png"];
            }
            break;
        default:
            break;
    }

    [self.actionButton setTitle:title forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:bgImage forState:UIControlStateNormal];
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if ([self.gameInfo.icon isEqualToString:imageUrl]){
        self.gameIconView.image = image;
    }
}

//- (IBAction)onDetailButton:(id)sender{
//    [gameIconView setHidden:true];
//    bool isHidden = ![gameActionView isHidden];
//    [gameActionView setHidden:isHidden];
//    
//    CGRect frame = self.frame;
//    
//    if(isHidden)
//        frame.size.height -= gameActionView.frame.size.height;
//    else {
//        frame.size.height += gameActionView.frame.size.height;
//    }
//    self.frame = frame;
//}
//
//- (void) showActionView:(bool) shown {
//    bool isHidden = ![gameActionView isHidden];
//    [gameActionView setHidden:isHidden];
//    
//    CGRect frame = self.frame;
//    
//    if(isHidden)
//        frame.size.height =gameInfoView.frame.size.height; 
//    else {
//        frame.size.height = gameInfoView.frame.size.height+ gameActionView.frame.size.height;
//    }
//    self.frame = frame;
//}

- (IBAction)onActionButton:(id)sender{
    QYXDownloadStatus status = [[LQDownloadManager sharedInstance] getStatusById:self.gameInfo.gameId];
    switch (status) {
        case kQYXDSFailed:
            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            break;
        case kQYXDSCompleted:
        case kQYXDSInstalling:
            [[LQDownloadManager sharedInstance] installGameBy:self.gameInfo.gameId];
            break;
        case kQYXDSPaused:
            [[LQDownloadManager sharedInstance] resumeDownloadById:self.gameInfo.gameId];
            break;
        case kQYXDSRunning:
            [[LQDownloadManager sharedInstance] pauseDownloadById:self.gameInfo.gameId];
            break;
        case kQYXDSNotFound:
            if ([[LQDownloadManager sharedInstance] isGameInstalled:self.gameInfo.package]){
                [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            }else{
                [[LQDownloadManager sharedInstance] addToDownloadQueue:self.gameInfo suspended:NO];
            }
            break;
        case kQYXDSInstalled:
            [[LQDownloadManager sharedInstance] startGame:self.gameInfo.package];
            break;
        default:
            break;
    }
    self.gameInfo = gameInfo;
}

//- (void)onSelected:(bool) selected{
//    
//    [gameActionView setHidden:!selected];
//    CGRect frame = self.frame;
//    if(selected)
//        frame.size.height= gameInfoView.frame.size.height+ gameActionView.frame.size.height;
//    else
//        frame.size.height= gameInfoView.frame.size.height;
//    self.frame = frame;
//}

- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag{
     [actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    actionButton.tag = self.gameInfo.gameId;
}

@end
