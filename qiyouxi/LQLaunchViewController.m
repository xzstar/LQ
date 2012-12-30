//
//  QYXLaunchViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-2.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQLaunchViewController.h"
#import "LQURLCache.h"
#import "LQMainTabBarController.h"

@interface LQLaunchViewController ()
@property (strong) NSString* launchImageUrl;
@end

@implementation LQLaunchViewController
@synthesize launchImageView;
@synthesize launchImageUrl;

- (void)loadViews{
    
    launchImageView.contentMode = UIViewContentModeScaleToFill;
    
    NSArray* cacheDirectoires = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    LQURLCache* urlCache = [[LQURLCache alloc] initWithMemoryCapacity:1024000 diskCapacity:1024000*10 diskPath:[cacheDirectoires objectAtIndex:0]];
    
    [NSURLCache setSharedURLCache:urlCache];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* imageUrl = [defaults valueForKey:@"qiyouxi.launchimage"];
    if (imageUrl.length > 0){
        NSError *error = nil;
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
                                                    cachePolicy:NSURLRequestReturnCacheDataDontLoad
                                                timeoutInterval:30.0];
        NSURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if (data != nil){
            UIImage* image = [UIImage imageWithData:data];
            if (image != nil){
                self.launchImageView.image = image;
            }
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onDone:) userInfo:nil repeats:NO];
    
    [[LQDownloadManager sharedInstance] loadIpaInstalled];
}

- (void)loadData{
    [self.client loadLaunchImage];
}

- (void)onDone:(NSTimer*)timer{
    //[self performSegueWithIdentifier:@"gotoMain" sender:nil];
    LQMainTabBarController *controller = [[LQMainTabBarController alloc] init];

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    switch (command) {
        case C_COMMAND_GETLAUNCHIMAGE:
        {
            self.launchImageUrl = [result objectForKey:@"url"];
            [[LQImageLoader sharedInstance] loadImage:self.launchImageUrl context:self];
        }
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    //do nothing
}

- (void)handleNoNetwork{
    //do nothing
}

- (void)updateImage:(UIImage*)image forUrl:(NSString*)imageUrl{
    if ([imageUrl isEqualToString:self.launchImageUrl]){
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:imageUrl forKey:@"qiyouxi.launchimage"];
        [defaults synchronize];
    }
}

@end
