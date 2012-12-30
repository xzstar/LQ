//
//  QYXToast.h
//  TicketGo
//
//  Created by maruojie on 09-10-12.
//  Copyright 2009 MobGo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQYXToastLengthShort  2.0
#define kQYXToastLengthLong  5.0

@interface LQToast : NSObject {
	// background view
	UIImageView* _bgView;
	
	// label for displaying text
	UILabel* _label;
}

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, assign) NSTimeInterval toastLength;

// show toast float, which is a class method to simplify calling code
+ (void)show:(NSString*)text length:(NSTimeInterval)length;

// show toast floating view
- (void)show:(NSString*)text length:(NSTimeInterval)length;

+ (void)show:(NSString*)text length:(NSTimeInterval)length inView:(UIView*)applicationView;

- (void)show:(NSString*)text length:(NSTimeInterval)length inView:(UIView*)applicationView;


@end
