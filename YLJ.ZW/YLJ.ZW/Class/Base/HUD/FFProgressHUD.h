//
//  FFProgressHUD.h
//  Funmily
//
//  Created by Kuroky on 16/8/18.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  提示框
 */
@interface FFProgressHUD : NSObject

+ (FFProgressHUD *)sharedProgressHUD;

/**
 *  显示简单的HUD
 *
 *  @param title 提示的title
 *  @param bHold @YES, 停止UI操作; @NO, 允许用户其他UI操作
 */
- (void)showProgressHUDWithTitle:(NSString *)title
            shouldHoldMainThread:(BOOL)bHold;

/**
 *  隐藏HUD
 */
- (void)hideProgressHUD;

/**
 *  显示有title的toast (在view底部)
 *
 *  @param title 提示的title
 */
- (void)toastTitle:(NSString *)title;

/**
 *  显示有在中间的toast
 *
 *  @param title 提示的title
 */
- (void)toastTitleAtMiddle:(NSString *)title;

- (void)toastTitleAtMiddle:(NSString *)title inView:(UIView *)view;


- (void)toastHideAll;

/**
 一直显示的toast

 @param title 提示标题
 */
- (void)toastAlwaysTitle:(NSString *)title;

/**
 *  返回一个带标题的alertController, 无响应事件
 *
 *  @param title       标题
 *  @param buttonTitle 按钮
 *
 *  @return UIAlertController (UIAlertControllerStyleAlert)
 */
- (UIAlertController *)showAlertTitle:(NSString *)title
                           withButton:(NSString *)buttonTitle;

/**
 *  带有响应事件的alertController
 *
 *  @param title             标题
 *  @param message           提示信息
 *  @param cancelButtonTitle 取消按钮
 *  @param otherButtonTitle  确定按钮
 *  @param handler           事件handler
 *
 *  @return UIAlertController (UIAlertControllerStyleAlert)
 */
- (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                            actionHandler:(void(^)(UIAlertAction *action))handler;

/**
 *  带有响应事件的ActionSheet
 *
 *  @param title                  标题
 *  @param message                提示信息
 *  @param cancelButtonTitle      取消按钮
 *  @param destructiveButtonTitle 相消按钮
 *  @param handler                事件handler
 *  @param otherButtonTitles      其他按钮
 *
 *  @return UIAlertController (UIAlertControllerStyleActionSheet)
 */
- (UIAlertController *)showActionSheetWithTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(UIAlertAction *action))handler
                              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


-(void)showHUDWithProgress:(CGFloat)pro;
-(void)hideHUDWithProgress;

@end
