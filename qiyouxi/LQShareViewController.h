//
//  LQShareViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-2-25.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRShare.h"
@interface LQShareViewController : UIViewController{
    KRShare* krShare;
    id krShareRequestDelegate;
    NSString* shareTextContent;
    UIImage* shareImageContent;
}

@property (unsafe_unretained) IBOutlet UITextView* shareTextView;
@property (unsafe_unretained) IBOutlet UIImageView* shareImageView;
@property (nonatomic,strong)  KRShare *krShare;
@property (nonatomic,strong) id krShareRequestDelegate;
@property (nonatomic,strong) NSString* shareTextContent;
@property (nonatomic,strong) UIImage* shareImageContent;
-(IBAction)onBack:(id)sender;
-(IBAction)onSend:(id)sender;
@end
