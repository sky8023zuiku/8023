//
//  ZWToolActon.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWToolActon : NSObject

+ (instancetype)shareAction;
/**
 *      Label自适应
 */
-(CGFloat)adaptiveTextHeight:(NSString *)text;
-(CGFloat)adaptiveTextHeight:(NSString *)text textFont:(UIFont *)font textWidth:(CGFloat)width;
//-(CGFloat)adaptiveTextHeight:(NSString *)text font:(UIFont *)font;
-(CGFloat)adaptiveTextWidth:(NSString *)text;
-(CGFloat)adaptiveTextWidth:(NSString *)labelText labelFont:(UIFont *)font;
/**
 *      转码
 */
- (NSString *)transformArr:(NSArray *)array;
- (NSString *)transformDic:(NSDictionary *)dic;
/**
 * 倒计时
 */
- (void)theCountdownforTime:(NSInteger)minutes whthColor:(UIColor *)color withButton:(UIButton *)btn;
/**
 * 判断是否是手机号码
 */
- (BOOL)valiMobile:(NSString *)mobile;
/**
 * 判断是否是手机号码(国际版)
 */
- (BOOL)isMobileGuoJi:(NSString *)mobileNumbel;
/**
 * 转换不规则的网络链接
 */
- (NSString *)transcodWithUrl:(NSString *)url;

/**
 * 时间戳转时间
 */
- (NSString *)getTimeFromTimestamp:(NSNumber *)stamp withDataStr:(NSString *)format;
/**
 *  设置两端对齐
*/
- (NSMutableAttributedString *)createBothEndsWithLabel:(UILabel *)label textAlignmentWith:(CGFloat)width;
/**
 *  字符串转数组
*/
- (NSArray *)strTurnArrayWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
