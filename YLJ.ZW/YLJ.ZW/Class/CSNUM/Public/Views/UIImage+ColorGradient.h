//
//  UIImage+ColorGradient.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/15.
//  Copyright © 2020 CHY. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};
@interface UIImage (ColorGradient)
#pragma colors 渐变颜色数组
#pragma gradientType 渐变样式
#pragma imgSize 图片大小
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
@end

NS_ASSUME_NONNULL_END
