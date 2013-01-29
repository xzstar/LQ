//
//  LQSMSRingReplaceViewController.m
//  liqu
//
//  Created by Xie Zhe on 13-1-23.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQSMSRingReplaceViewController.h"
#import "LQDownloadManager.h"
#define RINGPATH @"/System/Library/Audio/UISounds/"
@interface LQSMSRingReplaceViewController ()
{
    NSArray* ringNames;
    NSArray* ringFileName;
}
@property (strong) NSArray* ringNames;
@property (strong) NSArray* ringFileName;
@end

@implementation LQSMSRingReplaceViewController
@synthesize ringNames,ringFileName,ringObject;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getRingTone];
    selectedRow = -1;
    ringNames = [NSArray arrayWithObjects:@"三全音",@"管钟琴",@"玻璃声",@"圆号",@"铃声",@"电子乐", nil];
    ringFileName = [NSArray arrayWithObjects:
                    @"sms-received1.caf",@"sms-received2.caf",
                    @"sms-received3.caf",@"sms-received4.caf",
                    @"sms-received5.caf",@"sms-received6.caf",nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ringNames.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TableSampleIdentifier = @"ring"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
                             TableSampleIdentifier]; 
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:TableSampleIdentifier]; 
    } 
    
    NSUInteger row = [indexPath row]; 
    cell.textLabel.text = [self.ringNames objectAtIndex:row]; 
	return cell;     
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
}

- (void)getRingTone{
    toneDictory = [[NSDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Media/iTunes_Control/iTunes/Ringtones.plist"];

}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onReplaceRing:(id)sender{
    
    NSString* fileName= [ringFileName objectAtIndex:selectedRow];
    NSString* destPath=[RINGPATH stringByAppendingPathComponent:fileName];//这里要特别主意，目标文件路径一定要以文件名结尾，而不要以文件夹结尾
   
    NSArray* destPaths = [NSArray arrayWithObjects:destPath,nil];
    self.ringObject.finalFilePaths = destPaths;
    ringObject.installAfterDownloaded = YES;
    [[LQDownloadManager sharedInstance] installGameBy:ringObject.gameInfo.gameId];
//    NSError* error=nil;
//    
//    if ([fileManager fileExistsAtPath:dstPath]) {
//        NSLog(@"文件存在");
//        [fileManager removeItemAtURL:dstPath error:&error];//删除不了哦
//        NSLog(@"error=%@",error);
//    }
//    
//    [[NSFileManager defaultManager]copyItemAtPath:srcPath toPath:dstPath error:&error ];
//    if (error!=nil) {
//        NSLog(@"%@", error);
//        NSLog(@"%@", [error userInfo]);
//    }
    
    
}
@end
