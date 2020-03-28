//
//  AppDelegate.m
//  YLJ.ZW
//
//  Created by CHY on 2019/7/31.
//  Copyright © 2019年 CHY. All rights reserved.
//

#import "AppDelegate.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import "ZWMainTabBarController.h"
#import "CSMenuViewController.h"

#import "ZWMainLoginVC.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initMapKey];
    
    [self loadMainVC];
    
    [self versionUpdate];

    [self share_sdk];
    
    return YES;
}

- (void)initMapKey {
    [AMapServices sharedServices].apiKey = @"8ea30af9e3b75beb4fe8906fde8ba90b";
}

- (void)loadMainVC {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ZWMainTabBarController *tabBarC = [[ZWMainTabBarController alloc]init];
    self.window.rootViewController = tabBarC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

- (void)loadMainLoginVC {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ZWMainLoginVC *loginVC = [[ZWMainLoginVC alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
    navi.navigationBar.barTintColor = skinColor;
    navi.navigationBar.translucent = NO;
    navi.navigationBar.tintColor = [UIColor whiteColor];
    [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}


- (void)share_sdk {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //qq
        [platformsRegister setupQQWithAppId:@"1109867121" appkey:@"DNGpOAanS53E9fcn"];
        //wechat
        [platformsRegister setupWeChatWithAppId:@"wxaaec29e7bfc06754" appSecret:@"Z0myRYwq1RRPyyvz2x4Kt6yz67CD0HNZ"];
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"662488503" appSecret:@"a2ec413365b4d170fdc245235be8e3cf" redirectUrl:@"http://open.weibo.com/apps/662488503/privilege/oauth"];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}


- (void)versionUpdate {
    
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"我的版本号码= %@",version);
    
    [[ZWDataAction sharedAction]postReqeustWithURL:@"http://itunes.apple.com/cn/lookup?id=1483303004" parametes:@{} successBlock:^(NSDictionary *data) {
        
        NSString *strVersion = data[@"results"][0][@"version"];
        
        NSLog(@"---我的版本%@ is bigger22",strVersion);
        
        if ([strVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
            
            NSLog(@"---我的版本%@ is bigger22",strVersion);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"展网新版本已发布,为了让您有更好的体验,我们需要您更新为新版本,请谅解!"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"前去更新", nil];
            alert.tag = 222;
            [alert show];
            
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==222) {
        if (buttonIndex==0) {
            NSURL *url=[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1483303004?mt=8"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    
}

@end
