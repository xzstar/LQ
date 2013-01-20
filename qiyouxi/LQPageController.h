//
//  LQPageController.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PAGE_NAME_SPAN 10
#define PAGE_NAME_WIDTH 25
#define PAGE_NAME_HEIGHT 30
#define PAGE_NAME_HEIGHT_OFFSET 5
@interface LQPageController : UIView {
    NSArray* pageNames;
    //UIImageView* underLineImageView;
    NSMutableArray* pageLables;
    NSUInteger currentPage;
    UIButton* leftButton;
    UIButton* rightButton;
}

@property (nonatomic,strong) NSArray* pageNames;
@property (nonatomic,assign) NSUInteger currentPage;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
