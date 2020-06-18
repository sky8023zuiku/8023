//
//  ZWShareManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareManager.h"
#import "UIViewController+YCPopover.h"
#import "ZWShareViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ZWShareManager()
@property(nonatomic, strong)NSMutableArray *shareArray;
@property(nonatomic, strong)NSMutableArray *otherArray;
@end

@implementation ZWShareManager
static ZWShareManager *shareManager = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

//配置分享
- (void)configurationShare {
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //qq
        [platformsRegister setupQQWithAppId:@"1109867121" appkey:@"DNGpOAanS53E9fcn"];
        //wechat
        [platformsRegister setupWeChatWithAppId:@"wxaaec29e7bfc06754" appSecret:@"Z0myRYwq1RRPyyvz2x4Kt6yz67CD0HNZ"];
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"662488503" appSecret:@"a2ec413365b4d170fdc245235be8e3cf" redirectUrl:@"http://open.weibo.com/apps/662488503/privilege/oauth"];
        //wework
        [platformsRegister setupWeWorkByAppKey:@"wwauth5e96ba6ddfb8841d000004" corpId:@"ww5e96ba6ddfb8841d" agentId:@"1000004" appSecret:@"X1W9bX-yq99_MwDzMps6lzpQZmlZyL3N_c25KFnablM"];
        //Facebook
        [platformsRegister setupFacebookWithAppkey:@"708358196633797" appSecret:@"39f65f525708046cb51c5d2b5758051a" displayName:@"csnum"];
        //Twitter
        [platformsRegister setupTwitterWithKey:@"" secret:@"" redirectUrl:@"http://mob.com"];
        //领英
        [platformsRegister setupLinkedInByApiKey:@"866n7sb1zgy8nl" secretKey:@"5vRwRZ2ncdSjwGhK" redirectUrl:@"http://www.csnum.com/auth/linkedin/callback"];
        //Instagram
        [platformsRegister setupInstagramWithClientId:@"708358196633797" clientSecret:@"39f65f525708046cb51c5d2b5758051a" redirectUrl:@""];
    }];
}

- (void)showShareAlertWithViewController:(UIViewController *)viewController
                           withDataModel:(ZWShareModel *)model
                           withExtension:(id)extension
                                withType:(NSInteger)type {
    
    NSDictionary *myDic = (NSDictionary *)extension;
    NSLog(@"-------%@",myDic);
    NSLog(@"=======%@",extension);
    
    
    ZWShareViewController *shareVC = [[ZWShareViewController alloc]init];
    shareVC.model = model;
    shareVC.type = type;
    shareVC.extension = extension;
    [viewController yc_bottomPresentController:shareVC presentedHeight:0.3*kScreenWidth+zwTabBarHeight completeHandle:^(BOOL presented) {
        
    }];
}

@end
