//
//  LQAboutViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRShare.h"

@interface LQAboutViewController : UIViewController<KRShareDelegate,KRShareRequestDelegate>{
    KRShare *_krShare;

}

- (IBAction)onBack:(id)sender;
- (IBAction)onQQWeibo:(id)sender;
- (IBAction)onSinaWeibo:(id)sender;
@end
