//
//  LQRecommendSectionHeader.h
//  qiyouxi
//
//  Created by Xie Zhe on 12-12-31.
//  Copyright (c) 2012年 LQ有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQRecommendSectionHeader : UIView{ 
    NSString* leftImageNormal;
    NSString* leftImageSelected;
    NSString* rightImageNormal;
    NSString* rightImageSelected;
}
- (void) addInfoButtonsTarget:(id)target action:(SEL)action tag:(int)tag;
- (void) setButtonStatus:(int)index;

- (void) setImageNames:(NSString*) leftNormal   
          leftSelected:(NSString*) leftImageSelected
           rightNormal:(NSString*) rightImageNormal
         rightSelected:(NSString*) rightImageSelected;

@end
@interface LQRecommendSectionHeader()
@property (unsafe_unretained) IBOutlet UIButton* softButton;
@property (unsafe_unretained) IBOutlet UIButton* topicButton;
@property (atomic,strong) NSString* leftImageNormal;
@property (atomic,strong) NSString* leftImageSelected;
@property (atomic,strong) NSString* rightImageNormal;
@property (atomic,strong) NSString* rightImageSelected;

@end
