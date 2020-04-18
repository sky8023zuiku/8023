//
//  YPchAction.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#ifndef YPchAction_h
#define YPchAction_h

#import "YNavigationBar.h"
#import "ZWToolActon.h"
#import "ZWSaveDataAction.h"
#import "ZWAlertAction.h"
#import "ZWTextView.h"
#import "ZWOSSConstants.h"
#import "ZWNetwork.h"
#import <MJExtension.h>
#import <TPKeyboardAvoidingTableView.h>
#import <TPKeyboardAvoidingCollectionView.h>
#import <TPKeyboardAvoidingScrollView.h>
#import "ZWPhotoBrowserAction.h"
#import "ZWSearchBar.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ZWBaseEmptyTableView.h"
#define httpImageUrl @"http://zhanwang.oss-cn-shanghai.aliyuncs.com/"
#define blankPagesImageName @"qita_img_wu"
#define requestFailedBlankPagesImageName @"qita_img_wang"
#define kHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

///**
// *      屏幕宽高
// */
//#define YScreenHeight [UIScreen mainScreen].bounds.size.height
//#define YScreenWidth [UIScreen mainScreen].bounds.size.width
///**
// * 适配导航
// */
//#define isIphoneX_XS (tmScreenWidth == 375.f && tmScreenHeight == 812.f ? YES : NO)
//
//#define isIphoneXR_XSMax (tmScreenWidth == 414.f && tmScreenHeight == 896.f ? YES : NO)
//
//#define isFullScreen (isIphoneX_XS || isIphoneXR_XSMax)
//
//#define tmStatusBarHeight (isFullScreen ?44.0f: 20.0f)//状态栏高度
//
//#define tmNavBarHeight (isFullScreen ?88.f : 64.f)
//
//#define tmTabBarHeight (isFullScreen ?83.0f: 49.0f)//tabar高度
///**
// * 常规颜色
// */
//#define skinColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]
///**
// *      字体大小
// */
//#define largeFont [UIFont systemFontOfSize:0.05*tm_screen_width]
//#define tmBoldLargeFont [UIFont fontWithName:@"Helvetica-Bold" size:0.08*tm_screen_width]
//
//#define tmBigFont [UIFont systemFontOfSize:0.05*tm_screen_width]
//#define tmBoldBigFont [UIFont fontWithName:@"Helvetica-Bold" size:0.05*tm_screen_width]
//
//#define normalFont [UIFont systemFontOfSize:0.040*tm_screen_width]
//#define boldNormalFont [UIFont fontWithName:@"Helvetica-Bold" size:0.04*tm_screen_width]
//
//#define smallFont [UIFont systemFontOfSize:0.035*tm_screen_width]
//#define boldSmallFont [UIFont fontWithName:@"Helvetica-Bold" size:0.035*tm_screen_width]

/**
 *      图片比例
 */
#define zw16B9ImageScale 0.5625



#endif /* YPchAction_h */
