//
//  QYXAdvertiseView.m
//  qiyouxi
//
//  Created by 谢哲 on 12-8-1.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQAdvertiseView.h"
#import "LQImageButton.h"

@implementation LQAdvertiseView
@synthesize imageUrls;
@synthesize delegate;
@synthesize needRotate;
@synthesize selectPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadImageForPage:(int)page scroll:(BOOL)scroll{
    if (page < self.imageUrls.count){
        LQImageButton* imageview = (LQImageButton*) [scrollView viewWithTag:page+1];
//        [imageview loadImageUrl:[self.imageUrls objectAtIndex:page] defaultImage:nil];
        if (scroll){
            [scrollView scrollRectToVisible:imageview.frame animated:NO];
        }
    }
}

- (void)setImageUrls:(NSArray *)aImageUrls{
    imageUrls = aImageUrls;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    
    int index = 0;
    CGRect frame = self.bounds;
    for (NSString* url in imageUrls){
        LQImageButton* imageView = [[LQImageButton alloc] initWithFrame:frame];
        if (self.needRotate){
            imageView.transform = CGAffineTransformMakeRotation(-3.1415926535897/2);
        }
        imageView.tag = index+1;
        imageView.frame = frame;
        [imageView addTarget:self action:@selector(onSelectPage:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:imageView];
        frame.origin.x += frame.size.width;
        [imageView loadImageUrl:[self.imageUrls objectAtIndex:index] defaultImage:nil];
        index++;
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.bounds.size.width * imageUrls.count, self.bounds.size.height);
    scrollView.delegate = self;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.numberOfPages = imageUrls.count;
    [pageControl sizeToFit];
    
    [pageControl addTarget:self action:@selector(onPageChange:) forControlEvents:UIControlEventValueChanged];

    frame = pageControl.frame;
    frame.origin.x = (self.bounds.size.width - frame.size.width)/2;
    frame.origin.y = self.bounds.size.height - frame.size.height + 10;
    pageControl.frame = frame;
    
    [self addSubview:pageControl];
    
    if (self.selectPage > 0 && self.selectPage < self.imageUrls.count){
        [self loadImageForPage:self.selectPage scroll:YES];
    }else{
        [self loadImageForPage:0 scroll:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    int index = (scrollView.contentOffset.x + scrollView.bounds.size.width - 1)/scrollView.bounds.size.width;
    if (index < self.imageUrls.count){
        [self loadImageForPage:index scroll:NO];
        pageControl.currentPage = index;
    }
}

- (void)onPageChange:(id)sender{
    [self loadImageForPage:pageControl.currentPage  scroll:YES];
}

- (void)onSelectPage:(id)sender{
    LQImageButton* button = (LQImageButton*)sender;
    int page = button.tag - 1;
    if ([self.delegate respondsToSelector:@selector(QYXAdvertiseView:selectPage:)]){
        [self.delegate QYXAdvertiseView:self selectPage:page];
    }
}

@end
