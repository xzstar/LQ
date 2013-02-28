//
//  LQAboutViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRShare.h"
@class LQShareViewController;
@interface LQAboutViewController : UIViewController<KRShareDelegate,KRShareRequestDelegate>{
    KRShare *_krShare;
    LQShareViewController* shareController;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onQQWeibo:(id)sender;
- (IBAction)onSinaWeibo:(id)sender;
- (IBAction)onHomepage:(id)sender;
- (IBAction)onHomeWeibo:(id)sender;
@end
