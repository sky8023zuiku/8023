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

#import "ZWJPushAction.h"
#import "ZWRegisteredVersionAction.h"

#import "ZWShareManager.h"



// 引入 JPush 功能所需头文件
#import <JPUSHService.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<UIAlertViewDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initMapKey];
    
    [self loadMainVC];
    
    [self createShare];
    
    [self createVersionUpdate];

    [self createJPush:launchOptions];
        
    return YES;
}

//注册地图
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
//配置分享
- (void)createShare {
    [[ZWShareManager shareManager]configurationShare];
}
//版本更新
- (void)createVersionUpdate {
    [[ZWRegisteredVersionAction shareAction]versionUpdate:self.window.rootViewController];
}
//注册极光推送
- (void)createJPush:(NSDictionary *)launchOptions {
//    [[ZWJPushAction shareAction]registerJPush:launchOptions];
    
    [self registerJPush:launchOptions];
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
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//清除APP所有通知消息
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}










//极光推送
- (void)registerJPush:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        if (@available(iOS 10.0, *)) {
            entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        } else {
            // Fallback on earlier versions
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"745c31c4d84e16d6bb4d57c4"
                          channel:nil
                 apsForProduction:JPushBool
            advertisingIdentifier:nil];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{



    NSLog(@"deviceToken -- %@",deviceToken);



    [JPUSHService registerDeviceToken:deviceToken];//将token传给极光


}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    NSLog(@"error -- %@",error);

}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){

    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
         NSLog(@"----我的推送消息一 = %@",userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}
// iOS 10 Support
/// 程序运行于前台，后台 或杀死 点击推送通知 都会走这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else {

    }
    completionHandler();  // 系统要求执行这个方法
    [self JumpTwoMessageInterface:userInfo];
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {

    NSLog(@"----我的推送消息一 = %@",info);

}

- (void)JumpTwoMessageInterface:(NSDictionary *)myDic {

    NSLog(@"我的推送信息%@",myDic);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}

@end
