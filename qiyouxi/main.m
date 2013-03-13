//
//  main.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QYXAppDelegate.h"
#include <errno.h>
int main(int argc, char *argv[])
{
#ifdef JAILBREAK 
    seteuid(0);
    setgid(0);
    //NSLog(@"exe updatepermission.sh");
    
    int ret = system("/Applications/apodang.app/executor \"/usr/bin/dpkg -P --force-all com.apodang.installer\" ");
    ret = ( ret >> 8 );
    NSLog(@"executor %d %d",ret,errno);
#endif
    @autoreleasepool {
#ifdef JAILBREAK        
        
        
        //setuid(0);
        //setgid(0);  
#endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QYXAppDelegate class]));
    }
}
