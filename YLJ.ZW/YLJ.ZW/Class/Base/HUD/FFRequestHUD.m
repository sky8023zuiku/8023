//
//  FFRequestHUD.m
//  Funmily
//
//  Created by kevin on 16/9/6.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import "FFRequestHUD.h"

#import "MBProgressHUD.h"
#import "MMIndicator.h"
#import "UIColor+FFHEX.h"

@interface FFRequestHUD()
{
    MBProgressHUD *_busyingHud;
    MBProgressHUD *_tipHud;
}
//@property (nonatomic, strong) MBProgressHUD *requetBusyHUD;

@end

@implementation FFRequestHUD

+ (instancetype)sharedRequestHUD
{
    static FFRequestHUD *ffRequestHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ffRequestHUD = [[FFRequestHUD alloc] init];
    });
    
    return ffRequestHUD;
}

-(void)clearAllHUD
{
    
}

-(void)showRequestBusying
{
    if (_busyingHud) {
        [_busyingHud hideAnimated:NO];
        _busyingHud = nil;
    }
    UIView *result = [[UIApplication sharedApplication] windows].firstObject;;
    _busyingHud = [[MBProgressHUD alloc] initWithView:result];
    _busyingHud.removeFromSuperViewOnHide = YES;
//    _busyingHud.userInteractionEnabled = NO;
    //    _busyingHud.dimBackground = YES;
    _busyingHud.bezelView.color = [UIColor clearColor];
    _busyingHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _busyingHud.mode = MBProgressHUDModeCustomView;
    MMIndicator *spinnerView = [[MMIndicator alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinnerView.progressColor = [UIColor ff_colorWithHex:0x57bde0];
    spinnerView.lineWidth = 3.0;
    
    [spinnerView startAnimating];
    _busyingHud.customView = spinnerView;
    
    [result addSubview:_busyingHud];
    [_busyingHud showAnimated:YES];
//    return _busyingHud;
}
-(void)hideRequestBusying
{
    [_busyingHud hideAnimated:YES];
    _busyingHud = nil;
}

-(void)showTipView:(UIView*)view
{
    if (_tipHud) {
        [_tipHud hideAnimated:NO];
        _tipHud = nil;
    }
    UIView *result = [[UIApplication sharedApplication] windows].firstObject;;
    _tipHud = [[MBProgressHUD alloc] initWithView:result];
    _tipHud.removeFromSuperViewOnHide = YES;
    _tipHud.bezelView.color = [UIColor clearColor];
    _tipHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _tipHud.mode = MBProgressHUDModeCustomView;
    _tipHud.customView = view;
    _tipHud.backgroundView.color = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    [result addSubview:_tipHud];
    [_tipHud showAnimated:YES];
    [_tipHud hideAnimated:YES afterDelay:3.0];
}
-(void)hideTipView
{
    
    
}

@end
