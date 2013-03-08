//
//  AMN_StatusViewControl.h
//  AMN_StatusViewControl
//
//  Created by Amana Qi on 12-6-22.
//  Copyright (c) 2012年 Amana. All rights reserved.
//

//StatusBar显示跑马灯封装类
#import <Foundation/Foundation.h>
#import "QYXAppDelegate.h"
@interface AMN_StatusViewControl : UIView
{
    //接收主页面传来的显示数据
    NSMutableArray *_msgArray;
    
    QYXAppDelegate *_delegate;
    
    UIImage *_bgImage;
    
    //用于获取运行时间，如果为小于单次时间则只跑一次,如果为0则永久运行
    int _runTime;
    
    //用于获得单条运行时间，完整单条运行时间应为单条运行时间＋间隔时间
    int _eachTime;
    
    //用于获得间隔时间
    int _intervalTime;
    
    //用于获得StatusBar宽度
    float _statusWidth;
    
    //总运行次数，根据运行时间除以完整单条运行时间取得
    int _runCount;
    
    //已运行次数，单条运行的次数
    int _runNum;
    
    //纪录显示数据的编号
    int _msgNum;
}

@property (nonatomic, retain) NSMutableArray *msgArray;
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, assign) int runTime;
@property (nonatomic, assign) int eachTime;
@property (nonatomic, assign) int intervalTime;

- (id)init;
- (void)showStatusMessage;
- (void)runMsg;
- (void)stopAnimation;

@end
