//
//  YNavigationBar.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YNavigationBar.h"
#import "UIImage+ColorGradient.h"
#define navLeftColor [UIColor colorWithRed:61.0/255.0 green:198.0/255.0 blue:255.0/255.0 alpha:1]
#define navRightColor [UIColor colorWithRed:54.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1]
@implementation YNavigationBar

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(void)createNavigationBarWithStatusBarStyle:(UIStatusBarStyle)style withType:(NSInteger)type {
    if (type == 0) {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage gradientColorImageFromColors:@[navLeftColor,navRightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(kScreenWidth, zwNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                               NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
        [UIApplication sharedApplication].statusBarStyle = style;
    }else {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                               NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
        [UIApplication sharedApplication].statusBarStyle = style;
    }
}


//导航左边图片按钮
-(void)createLeftBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    leftItem.tintColor = [UIColor whiteColor];
    item.leftBarButtonItems = @[leftItem];
}
//导航左边边字体按钮
-(void)createLeftBarWithTitle:(NSString *)title barItem:(UINavigationItem *)item target:(id)target action:(SEL)action{
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc]
                                initWithTitle:title
                                style:UIBarButtonItemStylePlain target:target action:action];
    nextBtn.tintColor = [UIColor whiteColor];
    [item setLeftBarButtonItem:nextBtn];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}
//导航右边图片按钮
-(void)createRightBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    rightItem.tintColor = [UIColor whiteColor];
    item.rightBarButtonItems = @[rightItem];
}
//导航右边图片按钮
-(void)createCustomRightBarWithImage:(UIImage *)image barItem:(UINavigationItem *)item target:(id)target action:(SEL)action{
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [nextBtn setBackgroundImage:image forState:UIControlStateNormal];
    [nextBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    nextBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:nextBtn];
    rightItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    item.rightBarButtonItems = @[negativeSpacer,rightItem];
}
//导航右边字体按钮
-(void)createRightBarWithTitle:(NSString *)title barItem:(UINavigationItem *)item target:(id)target action:(SEL)action{
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc]
                                initWithTitle:title
                                style:UIBarButtonItemStylePlain target:target action:action];
    nextBtn.tintColor = [UIColor whiteColor];
    [item setRightBarButtonItem:nextBtn];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

@end
