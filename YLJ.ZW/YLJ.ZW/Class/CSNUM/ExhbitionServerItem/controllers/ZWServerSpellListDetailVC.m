//
//  ZWServerSpellListDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWServerSpellListDetailVC.h"
#import "ZWSpellListType01View.h"
#import "ZWSpellListType02View.h"
#import "ZWSpellListType03View.h"
#import "ZWSpellListType04View.h"
#import "UIViewController+YCPopover.h"
#import "ZWShareScreenshotsViewController.h"

@interface ZWServerSpellListDetailVC ()
@property(nonatomic, strong)ZWSpellListType01View *type01View;
@property(nonatomic, strong)ZWSpellListType02View *type02View;
@property(nonatomic, strong)ZWSpellListType03View *type03View;
@property(nonatomic, strong)ZWSpellListType04View *type04View;
@end

@implementation ZWServerSpellListDetailVC
-(ZWSpellListType01View *)type01View {
    if (!_type01View) {
        _type01View = [[ZWSpellListType01View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:0];
    }
    return _type01View;
}
-(ZWSpellListType02View *)type02View {
    if (!_type02View) {
        _type02View = [[ZWSpellListType02View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:0];
    }
    return _type02View;
}
-(ZWSpellListType03View *)type03View {
    if (!_type03View) {
        _type03View = [[ZWSpellListType03View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:0];
    }
    return _type03View;
}
-(ZWSpellListType04View *)type04View {
    if (!_type04View) {
        _type04View = [[ZWSpellListType04View alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) withModel:self.model withType:0];
    }
    return _type04View;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [self imageWithScreenshot];
    
    //添加显示
    UIImageView *imgvPhoto = [[UIImageView alloc]initWithImage:image_];
    imgvPhoto.frame = CGRectMake(kScreenWidth/2, kScreenHeight/2, kScreenWidth/2, kScreenHeight/2);
    //添加边框
    CALayer * layer = [imgvPhoto layer];
    layer.borderColor = [
        [UIColor whiteColor] CGColor];
    layer.borderWidth = 5.0f;
    //添加四个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 10.0;
    //添加两个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 2.0;

    [self.view.window addSubview:imgvPhoto];
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


- (void)createUI {
    self.title = @"拼单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.model.type isEqualToString:@"4"]) {
        [self.view addSubview:self.type02View];
    }else if ([self.model.type isEqualToString:@"5"]) {
        [self.view addSubview:self.type03View];
    }else if ([self.model.type isEqualToString:@"6"]) {
        [self.view addSubview:self.type04View];
    }else {
        [self.view addSubview:self.type01View];
    }
    
    if ([self.model.spellStatus isEqualToString:@"1"]) {
        UIButton *spellListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        spellListBtn.frame = CGRectMake(0.1*kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight-0.3*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
        [spellListBtn setTitle:@"我要拼单" forState:UIControlStateNormal];
        [spellListBtn addTarget:self action:@selector(spellListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        spellListBtn.backgroundColor = skinColor;
        spellListBtn.layer.cornerRadius = 5;
        spellListBtn.layer.masksToBounds = YES;
        [self.view addSubview:spellListBtn];
    }
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0.1*kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight-0.15*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    [shareBtn setTitle:@"截图分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:skinColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.borderColor = skinColor.CGColor;
    shareBtn.layer.borderWidth = 1;
    shareBtn.layer.cornerRadius = 5;
    shareBtn.layer.masksToBounds = YES;
    [self.view addSubview:shareBtn];

    
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)spellListBtnClick:(UIButton *)btn {
     [[ZWToolActon shareAction]dialTheNumber:self.model.telephone];
}


- (void)shareBtnClick:(UIButton *)btn {
    ZWShareScreenshotsViewController *screenshotsVC = [[ZWShareScreenshotsViewController alloc]init];
    screenshotsVC.screenshots = [self imageWithScreenshot];
    [self.navigationController yc_bottomPresentController:screenshotsVC presentedHeight:(kScreenHeight-zwNavBarHeight) completeHandle:^(BOOL presented) {
        
    }];
}

@end
