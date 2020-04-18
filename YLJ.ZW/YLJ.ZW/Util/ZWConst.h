//
//  ZWConst.h
//  YLJ.ZW
//
//  Created by CHY on 2019/8/7.
//  Copyright © 2019年 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+FFHEX.h"

NS_ASSUME_NONNULL_BEGIN

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 5SE
#define isiPhone4s ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f)

// 判断是否为 iPhone 5SE
#define iPhone5SE ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)

// 判断是否为iPhone 6/6s
#define iPhone6_6s ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)

//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define kDevice_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
//判断iPhoneXr
#define kDevice_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
//判断iPhoneXsMax
#define kDevice_iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !IS_IPAD : NO)
#define kDevice_iPhoneXAll (kDevice_iPhoneX || kDevice_iPhoneXr || kDevice_iPhoneXs_Max)



//获取屏幕 宽度、高度
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define TabBarHeight 49
#define ZWMasStatusBarHeight (kDevice_iPhoneXAll ? 44 : 20)
#define ZWMasSafeTopHeight (kDevice_iPhoneXAll ? 44 : 0)
//导航栏高度
#define ZWMasNavHeight (kDevice_iPhoneXAll ? 88 : 64)
//距离底部的距离（不带tabbar）
#define ZWMasBtnBottomConstaint (kDevice_iPhoneXAll ? 34 : 0)

//create by renyi----------------
//皮肤颜色
#define skinColor [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1]
//表格背景颜色
#define zwTableBackColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1]
//线条颜色
#define zwGrayColor [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]
#define zwDarkGrayColor [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1]
//字体大小
#define YYFONT(x) [UIFont systemFontOfSize:x]


#define bigFont [UIFont systemFontOfSize:0.045*kScreenWidth]
#define boldBigFont [UIFont fontWithName:@"Helvetica-Bold" size:0.045*kScreenWidth]

#define normalFont [UIFont systemFontOfSize:0.038*kScreenWidth]
#define boldNormalFont [UIFont fontWithName:@"Helvetica-Bold" size:0.038*kScreenWidth]


#define smallMediumFont [UIFont systemFontOfSize:0.033*kScreenWidth]
#define boldSmallMediumFont [UIFont fontWithName:@"Helvetica-Bold" size:0.033*kScreenWidth]

#define smallFont [UIFont systemFontOfSize:0.025*kScreenWidth]
#define boldSmallFont [UIFont fontWithName:@"Helvetica-Bold" size:0.025*kScreenWidth]
/**
 * 适配导航
 */
#define isIphoneX_XS (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)

#define isIphoneXR_XSMax (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)

#define isFullScreen (isIphoneX_XS || isIphoneXR_XSMax)

#define zwStatusBarHeight (isFullScreen ?44.0f: 20.0f)//状态栏高度

#define zwNavBarHeight (isFullScreen ?88.f : 64.f)

#define zwTabBarHeight (isFullScreen ?83.0f: 49.0f)//tabar高度

#define zwTabBarStausHeight (isFullScreen ?34.0f: 0.0f)//tabar高度

//单例定时器
#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef    IMP_SINGLETON
#define IMP_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static __class * __singleton__; \
static dispatch_once_t onceToken; \
dispatch_once( &onceToken, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

extern NSInteger const requestPageStart;
extern NSInteger const requestPageCount;

@interface ZWConst : NSObject

@end

NS_ASSUME_NONNULL_END
