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
    NSString* listOperator;
    NSString* nodeId;
    NSString* categoryId;
    NSString* titleString;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView* pageView;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSString* nodeId;
@property (nonatomic, strong) NSString* categoryId;
@property (nonatomic, strong) NSString* listOperator;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) LQPageController* pageController;
- (IBAction)onBack:(id)sender;
- (IBAction)changePage:(id)sender;
- (void) switchToPage:(int)page;

@end
