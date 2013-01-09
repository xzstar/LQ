//
//  LQTablesController.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPageController.h"

@interface LQTablesController : UIViewController<UIScrollViewDelegate>
{   
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    LQPageController *pageController;
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *viewControllers;

@end
