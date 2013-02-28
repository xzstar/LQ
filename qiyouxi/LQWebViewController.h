//
//  LQWebViewController.h
//  liqu
//
//  Created by Xie Zhe on 13-2-28.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQWebViewController : UIViewController<UIWebViewDelegate>{
    NSString* url;
    NSString* titleString;
    UIActivityIndicatorView*  activityIndicator;
}

-(IBAction)onBack:(id)sender;

@property (unsafe_unretained) IBOutlet UIButton* backButton;
@property (unsafe_unretained) IBOutlet UIWebView* webView;
@property (unsafe_unretained) IBOutlet UILabel*titleLabel;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* titleString;
@end
