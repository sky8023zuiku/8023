//
//  UIColor+FFHEX.h
//  Funmily
//
//  Created by kevin on 16/8/23.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FFHEX)

/**
 *  六位16进制：0xff00cc
 *  @param hex 六位16进制
 *  @return UIColor
 */
+ (UIColor *)ff_colorWithHex:(UInt32)hex;
+ (UIColor *)ff_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/**
 *  返回十六进制字符串颜色对象
 *
 *  @param hexStr 十六进制字符串颜色
 *
 *  @return 十六进制字符串Color
 */
+ (UIColor *)ff_colorWithHexString:(NSString *)hexStr;

/**
 *    随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)ff_randomColor;
@end
