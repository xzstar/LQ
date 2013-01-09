//
//  LQPageController.m
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-9.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQPageController.h"
#define PAGE_UNERLINE_HEIGHT 4
#define PAGE_UNERLINE_OFFSET 15

#define PAGE_UNDERLINE_BEGIN   @"head_animation_1.png"
#define PAGE_UNDERLINE_MIDDLE  @"head_animation_2.png"
#define PAGE_UNDERLINE_END     @"head_animation_3.png"

@implementation LQPageController
@synthesize pageNames,currentPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pageLables = [NSMutableArray array];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setPageNames:(NSArray *)aPageNames{
    pageNames = aPageNames;
    UIButton* button;
    
    for(int i=0;i<pageNames.count;i++){
        CGRect frame = CGRectMake(i*(PAGE_NAME_SPAN+PAGE_NAME_WIDTH), PAGE_NAME_HEIGHT_OFFSET , PAGE_NAME_WIDTH, PAGE_NAME_HEIGHT);
        button = [[UIButton alloc] initWithFrame:frame];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[pageNames objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:button];
        [pageLables addObject:button];
    }
    
    UIImage* image = [UIImage imageNamed:PAGE_UNDERLINE_BEGIN];
    underLineImageView = [[UIImageView alloc] initWithImage:image];
    
    CGRect frame = CGRectMake(0, self.frame.size.height -PAGE_UNERLINE_OFFSET , PAGE_NAME_WIDTH, PAGE_UNERLINE_HEIGHT);
    underLineImageView.frame = frame;
    [self addSubview:underLineImageView];
}

-(void) setCurrentPage:(NSUInteger)aCurrentPage {
    if(aCurrentPage>= pageLables.count)
        return;
    
    NSString* underlineName;
    if(aCurrentPage == 0)
        underlineName = PAGE_UNDERLINE_BEGIN;
    else if(aCurrentPage == pageLables.count -1)
        underlineName = PAGE_UNDERLINE_END;
    else
        underlineName = PAGE_UNDERLINE_MIDDLE;
    
    currentPage = aCurrentPage;
    UIImage* image = [UIImage imageNamed:underlineName];
    [underLineImageView setImage:image];
    
    
    CGRect frame = CGRectMake(currentPage*(PAGE_NAME_SPAN+PAGE_NAME_WIDTH), self.frame.size.height -PAGE_UNERLINE_OFFSET, PAGE_NAME_WIDTH, PAGE_UNERLINE_HEIGHT);
    underLineImageView.frame = frame;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    for (UIButton* button in pageLables) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
}

@end
