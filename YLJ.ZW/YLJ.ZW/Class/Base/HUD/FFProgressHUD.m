//
//  FFProgressHUD.m
//  Funmily
//
//  Created by Kuroky on 16/8/18.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import "FFProgressHUD.h"
#import "MBProgressHUD.h"
#import "SDWebImageCompat.h"
#import "FFToolsUtils.h"
#import "UIColor+FFHEX.h"

static CGFloat const KDefaultToastOffSetY       =   200;    // 默认y轴: >0中心点以下, <0中心点以上
static CGFloat const KDefaultToastHideDelay     =   1.0;    //  默认2.5s后消失

@interface FFProgressHUD ()<MBProgressHUDDelegate> {
    MBProgressHUD *_mbProgressHUD;
    MBProgressHUD *_bottomToastHUD;
    MBProgressHUD *_middleToastHUD;
    MBProgressHUD *_alwaysToastHUD;
    
    MBProgressHUD *_progressBarHUD;
    
    BOOL _keyboardIsVisible;
    NSMutableArray *_middleToastArray;
}

@end

@implementation FFProgressHUD

+ (FFProgressHUD *)sharedProgressHUD {
    static FFProgressHUD *ffProgressHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ffProgressHUD = [[FFProgressHUD alloc] init];
    });
    
    return ffProgressHUD;
}
- (instancetype)init
{
    self = [super init];
    [self setupDefault];
    return self;
}
- (void)setupDefault
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    _keyboardIsVisible = NO;
    _middleToastArray = [NSMutableArray arrayWithCapacity:1];
}
- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}


#pragma mark - 显示简单的HUD
- (void)showProgressHUDWithTitle:(NSString *)title
            shouldHoldMainThread:(BOOL)bHold {
    if (_mbProgressHUD) {
        [self hideProgressHUD];
    }
    
    UIView *pView = [self ff_rootWindow];
    dispatch_main_async_safe(^{
        _mbProgressHUD = [MBProgressHUD showHUDAddedTo:pView animated:YES];
    });
    
    _mbProgressHUD.contentColor = [UIColor whiteColor];
    _mbProgressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _mbProgressHUD.bezelView.backgroundColor = [[UIColor ff_colorWithHexString:@"010101"] colorWithAlphaComponent:0.7f];
    _mbProgressHUD.label.text = title;
    if (bHold) {
        _mbProgressHUD.userInteractionEnabled = YES;
    }
    else {
        _mbProgressHUD.userInteractionEnabled = NO;
    }
}

#pragma mark - 隐藏HUD
- (void)hideProgressHUD {
    [_mbProgressHUD hideAnimated:YES];
    _mbProgressHUD = nil;
    [_alwaysToastHUD hideAnimated:YES];
    _alwaysToastHUD = nil;
}

#pragma mark - 显示有title的HUD
- (void)toastTitle:(NSString *)title {
    if ([FFToolsUtils isNullOrSpaceString:title]) {
        return;
    }
    if (_keyboardIsVisible) {
        [self toastTitleAtMiddle:title];
        return;
    }
    
    if (_bottomToastHUD) {
        [_bottomToastHUD hideAnimated:YES];
        _bottomToastHUD = nil;
    }
    
    UIView *pView = [self ff_rootWindow];
    if(!pView)return;
    [self hideProgressHUD];
    _bottomToastHUD = [self createToastHUD:pView hideDelay:KDefaultToastHideDelay];
    _bottomToastHUD.detailsLabel.text = title;
    _bottomToastHUD.offset = CGPointMake(0.f, KDefaultToastOffSetY);
}

#pragma mark - 显示有在中间的toast
- (void)toastTitleAtMiddle:(NSString *)title {
    [self toastTitleAtMiddle:title inView:nil];
}
- (void)toastTitleAtMiddle:(NSString *)title inView:(UIView *)view
{
    if ([FFToolsUtils isNullOrSpaceString:title]) {
        return;
    }
    
    if (_alwaysToastHUD) {
        [_alwaysToastHUD hideAnimated:YES];
        _alwaysToastHUD = nil;
    }
    
    [_middleToastArray addObject:title];
    
    if (_middleToastArray.count == 1) {
        [self showMiddleToastTitle:title inView:view];
    }
}

- (void)showMiddleToastTitle:(NSString *)title inView:(UIView *)view;
{
    UIView *pView = view?:[self ff_rootWindow];
    if(!pView)return;
    [self hideProgressHUD];
    _middleToastHUD = [self createToastHUD:pView hideDelay:KDefaultToastHideDelay];
    _middleToastHUD.delegate = self;
    _middleToastHUD.detailsLabel.text = title;
}

- (void)toastHideAll
{
    [MBProgressHUD hideHUDForView:[self ff_rootWindow] animated:NO];
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    if ([hud isEqual:_middleToastHUD]) {
        if(_middleToastArray.count>0)
        [_middleToastArray removeObjectAtIndex:0];
        if (_middleToastArray.count > 0) {
            [self showMiddleToastTitle:[_middleToastArray firstObject] inView:nil];
        }
    }
}
#pragma mark - 显示一直的toast
- (void)toastAlwaysTitle:(NSString *)title {
    if ([FFToolsUtils isNullOrSpaceString:title]) {
        return;
    }
    
    if (_alwaysToastHUD) {
        [_alwaysToastHUD hideAnimated:YES];
        _alwaysToastHUD = nil;
    }
    
    UIView *pView = [self ff_rootWindow];
    if(!pView)return;
    [self hideProgressHUD];
    _alwaysToastHUD = [self createToastHUD:pView hideDelay:MAXFLOAT];
    _alwaysToastHUD.detailsLabel.text = title;
}

-(UIWindow *)ff_rootWindow
{
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    return window;
}

- (MBProgressHUD *)createToastHUD:(UIView *)pView
                        hideDelay:(CGFloat)delay {
    __block MBProgressHUD *hud;
    dispatch_main_async_safe(^{
        hud = [MBProgressHUD showHUDAddedTo:pView animated:YES];
    });
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.userInteractionEnabled = NO;
    hud.bezelView.backgroundColor = [[UIColor ff_colorWithHexString:@"010101"] colorWithAlphaComponent:0.7f];
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

#pragma mark - 返回一个带标题的alertController
- (UIAlertController *)showAlertTitle:(NSString *)title
                           withButton:(NSString *)buttonTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    if (!buttonTitle) {
        buttonTitle = @"好的";
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
    [alertController addAction:action];
    return alertController;
}

#pragma mark - 带有相应事件的alertController
- (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                            actionHandler:(void(^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButtonTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }
    
    if (otherButtonTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }
    
    return alertController;
}

#pragma mark - 带有相应事件的ActionSheet
- (UIAlertController *)showActionSheetWithTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                  actionHandler:(void(^)(UIAlertAction *action))handler
                              otherButtonTitles:(NSString *)otherButtonTitles, ... {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (cancelButtonTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arg
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }
    va_end(args);
    
    return alertController;
}












-(void)showHUDWithProgress:(CGFloat)pro
{
    UIView *pView = [self ff_rootWindow];
    if (!_progressBarHUD) {
        _progressBarHUD = [[MBProgressHUD alloc] initWithView:pView];
        _progressBarHUD.removeFromSuperViewOnHide = YES;
        _progressBarHUD.contentColor = [UIColor whiteColor];
        _progressBarHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressBarHUD.bezelView.backgroundColor = [[UIColor ff_colorWithHexString:@"010101"] colorWithAlphaComponent:0.7f];
        _progressBarHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    
    dispatch_main_async_safe(^{
        if (!_progressBarHUD.superview) {
            [pView addSubview:_progressBarHUD];
            [_progressBarHUD showAnimated:YES];
        }
        _progressBarHUD.progress = pro;
    });
}
-(void)hideHUDWithProgress
{
    dispatch_main_async_safe(^{
        [_progressBarHUD hideAnimated:YES];
    });
    
}

@end
