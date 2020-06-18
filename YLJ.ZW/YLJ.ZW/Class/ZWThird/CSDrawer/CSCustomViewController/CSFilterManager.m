//
//  CSFilterManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "CSFilterManager.h"
#import "CSFilterViewController.h"
#import "CSExhibitorsFilterVC.h"
#import "CSPlanExhibitionFilterVC.h"
#import "REFrostedViewController.h"


@interface CSFilterManager()
//@property(nonatomic, strong)NSDictionary *selectDictionary;

@end


@implementation CSFilterManager

static CSFilterManager *shareManager = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (void)showFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data {

    CSFilterViewController *filterVC = [[CSFilterViewController alloc]init];
    filterVC.selcetDictionary = data;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:filterVC];
    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:viewController.tabBarController menuViewController:navC];
    frostedVC.direction = REFrostedViewControllerDirectionRight;
    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
    frostedVC.animationDuration = 0.2;
    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    viewController.view.window.rootViewController = frostedVC;
    [viewController.frostedViewController presentMenuViewController];
    
}

//展商筛选
- (void)showExhibitorsFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data {
    CSExhibitorsFilterVC *filterVC = [[CSExhibitorsFilterVC alloc]init];
    filterVC.selcetDictionary = data;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:filterVC];
    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:viewController.tabBarController menuViewController:navC];
    frostedVC.direction = REFrostedViewControllerDirectionRight;
    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
    frostedVC.animationDuration = 0.2;
    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    viewController.view.window.rootViewController = frostedVC;
    [viewController.frostedViewController presentMenuViewController];
}

//计划展会筛选
- (void)showPlanExhibitionFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data {
    
    CSPlanExhibitionFilterVC *filterVC = [[CSPlanExhibitionFilterVC alloc]init];
    filterVC.selcetDictionary = data;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:filterVC];
    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:viewController.tabBarController menuViewController:navC];
    frostedVC.direction = REFrostedViewControllerDirectionRight;
    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
    frostedVC.animationDuration = 0.2;
    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    viewController.view.window.rootViewController = frostedVC;
    [viewController.frostedViewController presentMenuViewController];
}

@end
