//
//  main.m
//  executor
//
//  Created by Xie Zhe on 13-3-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LQAppDelegate.h"

int main(int argc, char *argv[])
{
    setuid(0);
    printf("%s",argv[1]);
    system(argv[1]);
    
    exit(0);
}
