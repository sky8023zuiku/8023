//
//  YNavigationBar.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YNavigationBar : NSObject

+ (instancetype)sharedInstance;
//设置导航样式和颜色
-(void)createNavigationBarWithStatusBarStyle:(UIStatusBarStyle)style withType:(NSInteger)type;
//导航左边图片按钮
-(void)createLeftBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action;
//导航左边边字体按钮
-(void)createLeftBarWithTitle:(NSString *)title barItem:(UINavigationItem *)item target:(id)target action:(SEL)action;
//导航右边图片按钮
-(void)createRightBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action;
-(void)createRightBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action withColor:(UIColor *)color;
//导航右边图片按钮自定义
-(void)createCustomRightBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action;
//导航右边字体按钮
-(void)createRightBarWithTitle:(NSString *)title barItem:(UINavigationItem *)item target:(id)target action:(SEL)action;

//设置导航的皮肤颜色和标题颜色
-(void)createSkinNavigationBar:(UINavigationBar *)navitionBar withBackColor:(UIColor *)backColor withTintColor:(UIColor *)tintColor;
@end

NS_ASSUME_NONNULL_END
