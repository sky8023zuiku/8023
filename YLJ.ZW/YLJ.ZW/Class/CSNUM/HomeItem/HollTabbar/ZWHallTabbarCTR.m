//
//  ZWHallTabbarCTR.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallTabbarCTR.h"
#import "ZWHallInfomationVC.h"
#import "ZWExhibitionTimelineVC.h"
#import "ZWHallFloorPlanVC.h"
#import "ZWHallMapVC.h"
@interface ZWHallTabbarCTR ()<UITabBarControllerDelegate>

@end

@implementation ZWHallTabbarCTR

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setModel:(ZWHallListModel *)model {
    [self createTabbarItem:model];
}


- (void)createTabbarItem:(ZWHallListModel *)model {
    self.delegate = self;
//    NSLog(@"我的ID=%@",self.hallId);
    ZWHallInfomationVC *infomationVC = [[ZWHallInfomationVC alloc]init];
    infomationVC.hallId = model.hallId;
    [self createVC:infomationVC Title:@"展馆信息" imageName:@"pavilion_information_icon" selectImage:@"pavilion_information_select"];
    
    ZWExhibitionTimelineVC *timelineVC = [[ZWExhibitionTimelineVC alloc]init];
    timelineVC.hallId = model.hallId;
    [self createVC:timelineVC Title:@"展会排期" imageName:@"exhibition_date_iocn" selectImage:@"exhibition_date_select"];
    
    ZWHallFloorPlanVC *planVC = [[ZWHallFloorPlanVC alloc]init];
    planVC.hallId = model.hallId;
    [self createVC:planVC Title:@"展厅平面图" imageName:@"hall_plane_icon" selectImage:@"hall_plane_select"];
    
    ZWHallMapVC *mapVC = [[ZWHallMapVC alloc]init];
    mapVC.model = model;
    [self createVC:mapVC Title:@"展馆位置" imageName:@"pavilion_location_icon" selectImage:@"pavilion_location_selcet"];
    
    self.viewControllers = @[infomationVC,timelineVC,planVC,mapVC];
}


- (void)createVC:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName selectImage:(NSString *)selectImage{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blue"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self animationWithIndex:tabBarController.selectedIndex];
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.repeatCount= 1;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}

@end
