//
//  QYXDownloadTableViewCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQDownloadTableViewCell.h"

@implementation LQDownloadTableViewCell
@synthesize gameIconView, gameNameLabel, gameDetailLabel;
@synthesize actionButton, cancelButton;
@synthesize progressView;

@synthesize downloadObject;

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



- (IBAction)onActionButton:(id)sender{
    switch (self.downloadObject.status){
        case kQYXDSRunning:
            [[LQDownloadManager sharedInstance] pauseDownloadById:self.downloadObject.gameInfo.gameId];
            break;
        default:
            [[LQDownloadManager sharedInstance] commonAction:self.downloadObject.gameInfo installAfterDownloaded:self.downloadObject.installAfterDownloaded];
    }
    
    
//    switch (self.downloadObject.status) {
//        case kQYXDSFailed:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:self.downloadObject.gameInfo.gameId];
//            break;
//        case kQYXDSCompleted:
//            [[LQDownloadManager sharedInstance] installGameBy:self.downloadObject.gameInfo.gameId];
//            break;
//        case kQYXDSPaused:
//            [[LQDownloadManager sharedInstance] resumeDownloadById:self.downloadObject.gameInfo.gameId];
//            break;
//        case kQYXDSRunning:
//            [[LQDownloadManager sharedInstance] pauseDownloadById:self.downloadObject.gameInfo.gameId];
//            break;
//        default:
//            break;
//    }
    
//    self.downloadObject = downloadObject;

}

- (IBAction)onCancelButton:(id)sender{
    [[LQDownloadManager sharedInstance] removeDownloadBy:self.downloadObject.gameInfo.gameId];
}

- (void)setDownloadObject:(QYXDownloadObject *)aDownloadObject{
    downloadObject = aDownloadObject;
    
    self.gameNameLabel.text = aDownloadObject.gameInfo.name;
    
    if (self.downloadObject.status == kQYXDSRunning) {
        
        if(aDownloadObject.totalLength<=0)
            self.gameDetailLabel.text = @"连接中，请稍等";
        else
            self.gameDetailLabel.text = [NSString stringWithFormat:@"%.2f%%/%@/%.2fKB/秒", [aDownloadObject percent], 
                                     [aDownloadObject totalSizeDesc],[aDownloadObject speed]];
        
    }
    else{
        self.gameDetailLabel.text = [NSString stringWithFormat:@"%.2f%%/%@", [aDownloadObject percent], 
                                     [aDownloadObject totalSizeDesc]];
        
    }
    self.progressView.progress = (float)[aDownloadObject percent]/100;
    
    
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:self.downloadObject.gameInfo.icon context:self];
    if (image != nil){
        self.gameIconView.image = image;
    }else {
        if([self.downloadObject.gameInfo.name isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]]){
            self.gameIconView.image = [UIImage imageNamed:@"Icon.png"];
        }
        else {
            self.gameIconView.image = [UIImage imageNamed:@"icon_small.png"];
        }
    }

    NSString* title = nil;
    switch (self.downloadObject.status) {
        case kQYXDSFailed:
            title = LocalString(@"button.restart");
            break;
        case kQYXDSCompleted:
            title = LocalString(@"button.install");
            break;
        case kQYXDSPaused:
            title = LocalString(@"button.resume");
            break;
        case kQYXDSRunning:
            title = LocalString(@"button.pause");
            break;
        default:
            break;
    }

    [self.actionButton setTitle:title forState:UIControlStateNormal];
    [self.actionButton setTitle:title forState:UIControlStateHighlighted];

}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if ([self.downloadObject.gameInfo.icon isEqualToString:imageUrl]){
        self.gameIconView.image = image;
    }
}


@end
