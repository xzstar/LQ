//
//  LQConfig.m
//  liqu
//
//  Created by Xie Zhe on 13-1-17.
//  Copyright (c) 2013年 科技有限公司. All rights reserved.
//

#import "LQConfig.h"

#define SEARCHHISTORY @"searchHistory.plist"
#define APPLIST @"applist.plist"
#define UPDATEAPPLIST @"updateapplist.plist"
#define IGNOREAPPLIST @"ignoreapplist.plist"
#define FIRSTBOOTPLIST @"firstboot.plist"

#define TESTLIST @"com.teiron.pphelper,0.990,com.saurik.Cydia,0.9,NetDragon.Mobile.iPhone.PandaSpace,3.2.2,manofham.glowstickfree,2.0,com.apptao.retinawallpapers,2.2,com.meitu.mtgif,1.2.7,com.yupoo.huaban,1.1.5,com.etsy.etsyforios,2.3,com.liqu.liqu,1.0,com.tencent.info,2.4,com.leiwor.YueDi,1.4,com.codeorgana.tooncamera,3.5,com.tencent.qqbuy,201211270000,cn.zaker.iphone,2.1,com.rmsm.AppTang,2.3,com.melodis.midomi,5.2.3,com.brid.AwesomeNote,6.260,com.tuan800.iphone,5.3.0,com.pokercity.fightlordiPhone,2.21,d.cn.Downjoy-Game-Center,1.1,com.imangi.templerun,1.4.1,com.snkplaymore.kofi001,1.01.00,cn.meimeidou.iphone,81,com.coco.shushuiFree,1.4,com.sequel.SearchForApp,1.4.4,com.tencent.QQMusic,2.7,com.kiloo.subwaysurfers,1.2.0,com.fossilsoftware.bannerflo,1.8,com.sequel.mianfeiyingyonghui,1.7.1,com.icloudzone.Death-Moto,1.0.1,com.qianwan.qianwan1,2.10,com.tencent.mqq,2.1.1.1680,com.tianqu.train,1.4.5,com.netease.news,2.3.1,com.tongbu.tbtui.store,1.1.1,com.sohu.newspaper,3.1.1,com.zhihu.ios,21,com.exberts.vgo,2012.8.3,com.laluzapp.sleepupfull,6.5,com.sis.si.mymeasurespro,4.02,com.mapbar.chazhoubian,3.1,com.taobao.tmall,1.1.2,com.sina.weibo,3.1.0,com.snkplaymore.MS3,1.1,com.ganji.life,2.9.1,net.uzen.kpoptube,2.0.2,com.taobao.etaoLocal,1.3,com.cdc.uidplayer,1.0,com.kaixin001.jipin,1.1.1,com.tiantian.-684--,3.1.23,com.fossilsoftware.appzilla2,3.4,Apptly.Oldify,2.5,com.baidu.map,4.1.1,com.sf-express.waybilltracking,2.1.1,net.suxxexx.noted,1.4,com.appwill.6pcleanwallpapers,1.3"
@implementation LQConfig

#pragma mark - utility func
+ (NSArray*) restoreArray:(NSString*) filename{
    // 得到documents directory的路径
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//	if ([paths count] > 0)
//	{
//        // dictionary的保存路径
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:filename];
//		
//		return [NSArray arrayWithContentsOfFile:infoPath];		
//	}
//	return nil;
    
    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:filename];
    return [NSArray arrayWithContentsOfFile:infoPath];	
}
+ (void) saveArray:(NSString*) filename savedValue:(NSArray*) savedValue{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//    
//	if ([paths count] > 0)
//	{
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:filename];
//		
//		// 保存 
//        [savedValue writeToFile:infoPath atomically:YES];
//        
//	}
//	else {
//		//NSLog(@"error when cache user info schema");
//	}
    
    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:filename];
    [savedValue writeToFile:infoPath atomically:YES];

}

+ (NSString*) restoreString:(NSString*) filename{
    // 得到documents directory的路径
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//	if ([paths count] > 0)
//	{
//        // dictionary的保存路径
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:filename];
//		
//		return [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:nil];		
//	}
//    return nil;
     NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:filename];
    return [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:nil];		
}
+ (void) saveString:(NSString*) filename savedValue:(NSString*) savedValue;{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//    
//	if ([paths count] > 0)
//	{
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:filename];
//		
//		// 保存 
//        [savedValue writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        
//	}
//	else {
//		//NSLog(@"error when cache user info schema");
//	}
    
     NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:filename];
    [savedValue writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}




#pragma mark - test func

+ (NSString*) restoreAppList{
    // 得到documents directory的路径
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//	if ([paths count] > 0)
//	{
//        // dictionary的保存路径
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:APPLIST];
//		
//		//return [NSArray arrayWithContentsOfFile:infoPath];		
//	}
    return TESTLIST;
}
+ (void) saveAppList:(NSString*) appList{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//    
//	if ([paths count] > 0)
//	{
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:SEARCHHISTORY];
//		
//		// 保存 
//        [appList writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//	}
//	else {
//		//NSLog(@"error when cache user info schema");
//	}
    
    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:SEARCHHISTORY];
    [appList writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - save/restore func
+ (NSArray*) restoreSearchHistory{
    return [LQConfig restoreArray:SEARCHHISTORY];
}

+ (void) saveSearchHisory:(NSArray*) searchHistory{
    [LQConfig saveArray:SEARCHHISTORY savedValue:searchHistory];
}


+ (NSArray*) restoreUpdateAppList{
    return [LQConfig restoreArray:UPDATEAPPLIST];
}
+ (void) saveUpdateAppList:(NSArray*) appList{
    [LQConfig saveArray:UPDATEAPPLIST savedValue:appList];
}

+ (NSArray*) restoreIgnoreAppList{
    return [LQConfig restoreArray:IGNOREAPPLIST];  
}
+ (void) saveIgnoreAppList:(NSArray*) appList{
    [LQConfig saveArray:IGNOREAPPLIST savedValue:appList]; 
}

+ (BOOL) isFirstBoot{
    // 得到documents directory的路径
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//	if ([paths count] > 0)
//	{
//        // dictionary的保存路径
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:FIRSTBOOTPLIST];
//		
//		return [[NSFileManager defaultManager] fileExistsAtPath:infoPath] == NO;		
//	}
//	return YES;
    
    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:FIRSTBOOTPLIST];
    return [[NSFileManager defaultManager] fileExistsAtPath:infoPath] == NO;		


}
+ (void) setFirstBoot:(BOOL) firstBoot{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//														 NSUserDomainMask, YES);
//    
//	if ([paths count] > 0)
//	{
//		NSString  *infoPath = [[paths objectAtIndex:0]
//                               stringByAppendingPathComponent:FIRSTBOOTPLIST];
//		
//		// 保存 
//        [@"firstbooted" writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        
//	}
//    
    NSString  *infoPath =[[LQUtilities documentsDirectoryPath] stringByAppendingPathComponent:FIRSTBOOTPLIST];
    [@"firstbooted" writeToFile:infoPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

@end
