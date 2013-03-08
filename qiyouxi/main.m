//
//  main.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QYXAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
#ifdef JAILBREAK        
        setuid(0);
        setgid(0);  
        NSLog(@"exe updatepermission.sh");
        system(". /Applications/apodang.app/UpdatePermissions.sh");
#endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QYXAppDelegate class]));
    }
}
