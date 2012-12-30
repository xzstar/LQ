//
//  QYXAdvertiseView.h
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQAdvertiseView : UIView<UIScrollViewDelegate>{
    UIScrollView* scrollView;
    UIPageControl* pageControl;
}

@property (nonatomic, strong) NSArray* imageUrls;
@property (unsafe_unretained) id delegate;
@property (nonatomic, assign) BOOL needRotate;
@property (nonatomic, assign) int selectPage;

@end


@interface NSObject(QYXAdvertiseViewDelegate)
- (void)QYXAdvertiseView:(LQAdvertiseView*)advertiseView selectPage:(int)page;
@end