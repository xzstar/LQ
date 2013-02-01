//
//  QYXInstallTableViewCell.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-3.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQInstallTableViewCell.h"

@implementation LQInstallTableViewCell

@synthesize gameIconView, gameNameLabel, gameDetailLabel;
@synthesize actionButton, cancelButton;

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
    
    BOOL value = [[LQDownloadManager sharedInstance] isGameInstalled:self.downloadObject.gameInfo.package] && self.downloadObject.status!= kQYXDSInstalled;
    
    
    if (value == YES){
        [[LQDownloadManager sharedInstance] startGame:self.downloadObject.gameInfo.package];
    }else{
        [[LQDownloadManager sharedInstance] installGameBy:self.downloadObject.gameInfo.gameId force:YES];
    }
    
}

- (IBAction)onCancelButton:(id)sender{
    [[LQDownloadManager sharedInstance] removeDownloadBy:self.downloadObject.gameInfo.gameId];
}

- (void)setDownloadObject:(QYXDownloadObject *)aDownloadObject{
    downloadObject = aDownloadObject;
    
    self.gameNameLabel.text = aDownloadObject.gameInfo.name;
    self.gameDetailLabel.text = [aDownloadObject totalSizeDesc];    
    
    UIImage* image = [[LQImageLoader sharedInstance] loadImage:self.downloadObject.gameInfo.icon context:self];
    if (image != nil){
        self.gameIconView.image = image;
    }else {
        self.gameIconView.image = [UIImage imageNamed:@"icon_small.png"];
    }
    
    NSString* title = nil;
    if ([[LQDownloadManager sharedInstance] isGameInstalled:aDownloadObject.gameInfo.package] && aDownloadObject.status== kQYXDSInstalled){
        title = LocalString(@"button.start");
    }else{
        if (aDownloadObject.status == kQYXDSInstalling){
            title = LocalString(@"button.installing");
        }else{
            title = LocalString(@"button.install");
        }
    }

    [self.actionButton setTitle:title forState:UIControlStateNormal];
    
    
    if ([[LQDownloadManager sharedInstance] isGameInstalled:aDownloadObject.gameInfo.package] && aDownloadObject.status== kQYXDSInstalled){
        title = LocalString(@"button.uninstall");
    }else{
        title = LocalString(@"button.delete");
    }

    [self.cancelButton setTitle:title forState:UIControlStateNormal];
    
    if (aDownloadObject.status == kQYXDSInstalling){
        self.actionButton.enabled = NO;
        self.cancelButton.enabled = NO;
    }else{
        self.actionButton.enabled = YES;
        self.cancelButton.enabled = YES;
    }

}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if ([self.downloadObject.gameInfo.icon isEqualToString:imageUrl]){
        self.gameIconView.image = image;
    }
}

@end
