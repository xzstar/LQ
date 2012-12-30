//
//  QYXFirstViewController.m
//  qiyouxi
//
//  Created by 谢哲 on 12-7-30.
//  Copyright (c) 2012年 科技有限公司. All rights reserved.
//

#import "LQTodayViewController.h"
#import "LQDetailViewController.h"

@interface LQTodayViewController ()
@property (nonatomic, strong) NSDictionary* announcement;
@property (nonatomic, strong) NSArray* advertisements;

- (void)loadData;
@end

@implementation LQTodayViewController
@synthesize announcement;
@synthesize advertisements;

@synthesize scrollView;
@synthesize advView;
@synthesize announceButton;
@synthesize boardView, gameButton1, gameButton2,gameButton3,gameButton4,gameButton5,gameButton6,gameButton7;
@synthesize dateView, dayLabel, monthLabel, weekLabel;

@synthesize bottomView;

#pragma mark - View Init
- (void)loadViews{
    [super loadViews];
    
    self.scrollView.contentSize = CGSizeMake(self.boardView.bounds.size.width, self.bottomView.frame.origin.y + self.bottomView.frame.size.height + 5.0);
    
    self.advView.delegate = self;
    
    int sel = rand() % 4;

    CGFloat middleBig = self.gameButton5.frame.origin.x;
    CGFloat middleSmall = self.gameButton2.frame.origin.x;
    CGFloat left = self.gameButton1.frame.origin.x;

    switch (sel) {
        case 0:
            break;
        case 1:
        {
            CGRect frame = self.gameButton1.frame;
            frame.origin.x = middleBig;
            self.gameButton1.frame = frame;
            
            frame = self.gameButton2.frame;
            frame.origin.x = left;
            self.gameButton2.frame = frame;
            frame = self.gameButton3.frame;
            frame.origin.x = left;
            self.gameButton3.frame = frame;
            
            frame = self.gameButton5.frame;
            frame.origin.x = left;
            self.gameButton5.frame = frame;
            
            frame = self.gameButton6.frame;
            frame.origin.x = middleSmall;
            self.gameButton6.frame = frame;
            frame = self.gameButton7.frame;
            frame.origin.x = middleSmall;
            self.gameButton7.frame = frame;
        }
            break;
        case 2:
        {
            CGRect frame = self.gameButton1.frame;
            frame.origin.x = middleBig;
            self.gameButton1.frame = frame;
            
            frame = self.gameButton2.frame;
            frame.origin.x = left;
            self.gameButton2.frame = frame;
            frame = self.gameButton3.frame;
            frame.origin.x = left;
            self.gameButton3.frame = frame;
            
            frame = self.gameButton5.frame;
            frame.origin.x = left;
            self.gameButton5.frame = frame;
            
            frame = self.gameButton6.frame;
            frame.origin.x = middleSmall;
            self.gameButton6.frame = frame;
            frame = self.gameButton7.frame;
            frame.origin.x = middleSmall;
            self.gameButton7.frame = frame;
            
            frame = self.dateView.frame;
            frame.origin.x = middleBig;
            self.dateView.frame = frame;

            frame = self.gameButton4.frame;
            frame.origin.x = left;
            self.gameButton4.frame = frame;

        }
            break;
        case 3:
        {
            CGRect frame;
            frame = self.dateView.frame;
            frame.origin.x = middleBig;
            self.dateView.frame = frame;
            
            frame = self.gameButton4.frame;
            frame.origin.x = left;
            self.gameButton4.frame = frame;
            
        }

            break;            
        default:
            break;
    }
    
    
    LQRecommendButton* buttons[7] = {
        self.gameButton1, self.gameButton2, self.gameButton3, self.gameButton4, self.gameButton5, self.gameButton6, self.gameButton7
    };
    
    sortedButtons = [NSMutableArray arrayWithCapacity:7];
    
    do{
        sel = rand()%7;
        if ([sortedButtons indexOfObject:buttons[sel]] == NSNotFound){
            [sortedButtons addObject:buttons[sel]];
        }
    }while (sortedButtons.count < 7);
    
}

#pragma mark - Data Init
- (void)loadRecommends{
    [self startLoading];
    [self.client loadTodayRecommendation:[NSDate date]];
}

- (void)loadData{
    [super loadData];
    
    UIColor* colors[7] = {
        [UIColor colorWithHexString:@"0xff17a8c7"],  
        [UIColor colorWithHexString:@"0xff007ef3"],  
        [UIColor colorWithHexString:@"0xff7841e9"],  
        [UIColor colorWithHexString:@"0xffdd6809"],  
        [UIColor colorWithHexString:@"0xffd01010"],  
        [UIColor colorWithHexString:@"0xff22ac38"],  
        [UIColor colorWithHexString:@"0xffb84766"],  
    };
    
    NSDate* today = [NSDate date];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSDayCalendarUnit|NSWeekdayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:today];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%.2d", components.day];
    self.weekLabel.text = [[LocalString(@"label.week") componentsSeparatedByString:@","] objectAtIndex:components.weekday-1];
    self.monthLabel.text = [NSString stringWithFormat:LocalString(@"label.month"), components.year, components.month];
    self.dateView.backgroundColor = colors[components.weekday-1];
    
    
    [self.announceButton setTitle:LocalString(@"default.announce") forState:UIControlStateNormal];
    
    [self.client loadAnnouncement];
    [self.client loadTodayAdvs];
    
    [self loadRecommends];
    
}

- (void)loadTodayGames:(NSArray*)games{
    int index = 0;
    for (NSDictionary * game in games){
        LQRecommendButton* button = [sortedButtons objectAtIndex:index];
        [button setTitle:[game objectForKey:@"name"] forState:UIControlStateNormal];
        NSDictionary* images = [game objectForKey:@"pic"];
        NSString* largeImage = [images objectForKey:@"big"];
        NSString* smallImage = [images objectForKey:@"small"];
        if (button == self.gameButton1 ||
            button == self.gameButton5){
            [button loadImageUrl:largeImage defaultImage:nil];
        }else{
            [button loadImageUrl:smallImage defaultImage:nil];
        }
        button.tag = [[game objectForKey:@"id"] intValue];
        index++;
    }
}

- (void)loadTodayAdvs:(NSArray*)advs{
    self.advertisements = advs;
    
    NSMutableArray* imageUrls = [NSMutableArray arrayWithCapacity:advs.count];
    for (NSDictionary* adv in advs){
        [imageUrls addObject:[adv objectForKey:@"adv_icon"]];
    }
    
    self.advView.imageUrls = imageUrls;
}

#pragma mark - Network Callback
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject{
    [super handleNetworkOK];
    switch (command) {
        case C_COMMAND_GETRECOMMENDATION:
            [self endLoading];
            if ([result isKindOfClass:[NSArray class]]){
                [self loadTodayGames:result];
            }
            break;
        case C_COMMAND_GETTODAYADVS:
            if ([result isKindOfClass:[NSArray class]]){
                [self loadTodayAdvs:result];
            }
            break;
        case C_COMMAND_GETANNOUNCEMENT:
            if ([result isKindOfClass:[NSArray class]]){
                self.announcement = [result objectAtIndex:0];
                [self.announceButton setTitle:[self.announcement objectForKey:@"content"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (void)handleNetworkError:(LQClientError*)error{
    switch (error.command) {
        case C_COMMAND_GETRECOMMENDATION:
            [self endLoading];
            if (self.advertisements.count > 0){
                [super handleNetworkErrorHint];
            }else{
                [super handleNetworkError:error];
            }
            break;
        case C_COMMAND_GETTODAYADVS:
        case C_COMMAND_GETANNOUNCEMENT:
        default:
            break;
    }
}

#pragma mark - Actions


- (IBAction)onReload:(id)sender{
    [self loadRecommends];
    
    if (self.advertisements == nil){
        [self.client loadTodayAdvs];
    }
    
    if (self.announcement == nil){
        [self.client loadAnnouncement];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoDetail"]){
        //设置对象
        LQDetailViewController* detailController = segue.destinationViewController;
        NSDictionary* gameInfo = sender;
        detailController.gameId = [[gameInfo objectForKey:@"id"] intValue];
    }else{
        LQDetailViewController* detailController = segue.destinationViewController;
        UIButton* button = sender;
        detailController.gameId = button.tag;
    }
}


- (void)QYXAdvertiseView:(LQAdvertiseView*)advertiseView selectPage:(int)page{
    [self performSegueWithIdentifier:@"gotoDetail" sender:[self.advertisements objectAtIndex:page]];
}


@end
