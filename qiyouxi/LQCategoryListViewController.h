//
//  LQTopicListViewController.h
//  qiyouxi
//
//  Created by Xie Zhe on 13-1-11.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQCommonTableViewController.h"

@interface LQCategoryListViewController : LQCommonTableViewController
{
    NSString* category;
}

@property (nonatomic,strong) NSString* category;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             category:(NSString *)aCategory;
- (void)onTopicList:(id)sender;
@end
