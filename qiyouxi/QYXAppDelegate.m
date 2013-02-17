//
//  QYXAppDelegate.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "QYXAppDelegate.h"
#import "LQLaunchViewController.h"
#import "LQConfig.h"
#import "MobClick.h"
@implementation QYXAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize launchViewController;
@synthesize main;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    srand(time(NULL));
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [navigationController pushViewController:main animated:NO];
    [navigationController setNavigationBarHidden:YES];
    [window addSubview:[navigationController view]];
	[self.window makeKeyAndVisible];
   
#ifdef JAILBREAK    
    NSLog(@"exe updatepermission.sh");
    system(". /Applications/liqu.app/UpdatePermissions.sh");
#endif
    
    if (client == nil){
        client = [[LQClient alloc] initWithDelegate:self];
    }
    
    if([LQConfig isFirstBoot] == YES){
        [client bootRecord:YES];
        [LQConfig setFirstBoot:NO];
    }
    [MobClick startWithAppkey:@"50fa1ab1527015336e000024"];;
    [MobClick checkUpdate];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [client bootRecord:NO];
    [[LQDownloadManager sharedInstance] restartGames];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
