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
#define ARROW_HEIGHT 24
#define ARROW_WIDTH  24
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
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                  CGRectMake(0, 0,frame.size.width, frame.size.height) ];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        
        UIImage* image = [UIImage imageNamed:@"index_nav_bg.png"];
        imageView.image = image;
        [self addSubview:imageView];
        
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
    
    CGRect frame = self.frame;
    if(leftButton == nil)
    {
        int x = 0;
        int y = (self.frame.size.height - ARROW_HEIGHT)/2;
        leftButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, ARROW_WIDTH, ARROW_HEIGHT)];
        [leftButton setImage:[UIImage imageNamed:@"arrow_01_right_default.png"] forState:UIControlStateNormal] ;
        [self addSubview:leftButton];
    }
    if(rightButton == nil)
    {
        int x = (self.frame.size.width - ARROW_WIDTH);
        int y = (self.frame.size.height - ARROW_HEIGHT)/2;
        rightButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, ARROW_WIDTH,ARROW_HEIGHT )];
        [rightButton setImage:[UIImage imageNamed:@"arrow_01_right_default.png"] forState:UIControlStateNormal] ;
        [self addSubview:rightButton];

    }
    
    int buttonCount = pageNames.count;
    int buttonWidth = (frame.size.width - 2*ARROW_WIDTH)/buttonCount;
    
    
    for(int i=0;i<pageNames.count;i++){
//        CGRect buttonFrame = CGRectMake(i*(PAGE_NAME_SPAN+PAGE_NAME_WIDTH), PAGE_NAME_HEIGHT_OFFSET , PAGE_NAME_WIDTH, PAGE_NAME_HEIGHT);
        CGRect buttonFrame = CGRectMake(i*buttonWidth+ARROW_WIDTH, 0 , buttonWidth, frame.size.height);
        button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.titleLabel.textAlignment = UITextAlignmentCenter;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[pageNames objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:button];
        [pageLables addObject:button];
    }
    
//    UIImage* image = [UIImage imageNamed:PAGE_UNDERLINE_MIDDLE];
//    underLineImageView = [[UIImageView alloc] initWithImage:image];
//    
//    CGRect frame = CGRectMake(0, self.frame.size.height -PAGE_UNERLINE_OFFSET , PAGE_NAME_WIDTH, PAGE_UNERLINE_HEIGHT);
//    underLineImageView.frame = frame;
//    [self addSubview:underLineImageView];
}

-(void) setCurrentPage:(NSUInteger)aCurrentPage {
    if(aCurrentPage>= pageLables.count)
        return;
    
    if(aCurrentPage == 0)
    {
       [leftButton setImage:[UIImage imageNamed:@"arrow_01_left_disabled.png"] forState:UIControlStateNormal] ; 
    }
    else {
        [leftButton setImage:[UIImage imageNamed:@"arrow_01_left_default.png"] forState:UIControlStateNormal] ; 
    }
    if(aCurrentPage == pageLables.count -1){
         [rightButton setImage:[UIImage imageNamed:@"arrow_01_right_disabled.png"] forState:UIControlStateNormal] ; 
    }
    else {
         [rightButton setImage:[UIImage imageNamed:@"arrow_01_right_default.png"] forState:UIControlStateNormal] ; 
    }
    
    for(int i=0; i< pageLables.count;i++)
    {
        UIButton* button = [pageLables objectAtIndex:i];
        
        if(i!=aCurrentPage)
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
//    NSString* underlineName;
//    if(aCurrentPage == 0)
//        underlineName = PAGE_UNDERLINE_BEGIN;
//    else if(aCurrentPage == pageLables.count -1)
//        underlineName = PAGE_UNDERLINE_END;
//    else
//        underlineName = PAGE_UNDERLINE_MIDDLE;
    
    currentPage = aCurrentPage;
//    UIImage* image = [UIImage imageNamed:underlineName];
//    [underLineImageView setImage:image];
    
//    
//    CGRect frame = CGRectMake(currentPage*(PAGE_NAME_SPAN+PAGE_NAME_WIDTH), self.frame.size.height -PAGE_UNERLINE_OFFSET, PAGE_NAME_WIDTH, PAGE_UNERLINE_HEIGHT);
//    underLineImageView.frame = frame;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    int i=0;
    for (UIButton* button in pageLables) {
        [button addTarget:target action:action forControlEvents:controlEvents];
        button.tag = i;
        i++;
    }
}
- (void)addLeftRightTarget:(id)target action:(SEL)action tag:(int)tag{
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = LEFTBUTTON_TAG;
    
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = RIGHTBUTTON_TAG;
        
}
@end
