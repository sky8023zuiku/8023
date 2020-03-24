//
//  ZWMainTabBarController.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMainTabBarController.h"
#import "ZWHomeVC.h"
#import "ZWMineVC.h"


#import "ZWServiceVC.h"//v0
#import "ZWExhibitionServerVC.h"//v1


#import "ZWExhibitionVC.h"
#import "ZWExhibitorsVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMainLoginVC.h"
#import "ZWMainSaveLocation.h"
#import <UIView+MJExtension.h>

#import "ZWLogOutRequest.h"

@interface ZWMainTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate,ZWHomeVCDelegate>
@property(nonatomic, assign)NSInteger oldSelectIndex;
@property(nonatomic, strong)UIButton *homeBtn;
@property(nonatomic, strong)ZWHomeVC *homeVC;

@property(nonatomic, strong)UIImageView *homeBGImage;

@property(nonatomic, assign)BOOL isRoll;
@property(nonatomic, assign)BOOL isTop;

@end

@implementation ZWMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBar];
    [self requestScreeningData];
    [self createNotice];
}
- (void)createNotice {
    //退出登陆时接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout:) name:@"beBroughtUp" object:nil];
    //刷新本地个人信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestUserInfo) name:@"requestUserInfo" object:nil];
    //获取首页列表滑动的位置
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homeTableViewRollLocation:) name:@"homeTableViewRollLocation" object:nil];
    
}
- (void)logout:(NSNotification *)notice {
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"登陆失效，请重新登录" confirmTitle:@"确认" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        ZWMainTabBarController *tabbar = [[ZWMainTabBarController alloc]init];
        strongSelf.view.window.rootViewController = tabbar;
        [strongSelf logOutRequest];
    } showInView:self];
    
}

-(void)logOutRequest {
    //删除本地数据
    [self clearAllUserDefaultsData];
}

- (void)clearAllUserDefaultsData{
    
    [[ZWSaveDataAction shareAction]removeLocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user"];
    [defaults synchronize];
    
}

- (void)zwHomeTableRollValue:(CGFloat)value {
    
    CGFloat itemHeight = (0.95*kScreenWidth-5)/2+0.15*kScreenWidth;
    CGFloat rollHeight = itemHeight*2+0.81*kScreenWidth;
    
    if (value >= rollHeight) {
        if (self.isTop == YES) {
            self.isTop = NO;
            self.isRoll = YES;
            [self.homeScrollView setContentOffset:CGPointMake(0, 43) animated:YES];
        }
    }else {
        if (self.isTop == NO) {
            self.isTop = YES;
            self.isRoll = NO;
            [self.homeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"beBroughtUp" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"requestUserInfo" object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"homeTableViewRollLocation" object:nil];
    
}

- (void)createTabBar {
    
    self.delegate = self;
    
    self.isRoll = NO;
    self.isTop = YES;
    
    self.homeVC = [[ZWHomeVC alloc]init];
    self.homeVC.navigationItem.title = @"首页";
    self.homeVC.delegate = self;
    [self createVC:self.homeVC Title:@"首页" imageName:@"home_icon.png" selectImage:@"home_icon.png"];
    UINavigationController *homeN = [[UINavigationController alloc]initWithRootViewController:self.homeVC];
    homeN.navigationBar.barTintColor = skinColor;
    homeN.navigationBar.tintColor = [UIColor whiteColor];
    homeN.navigationBar.translucent = NO;
    [homeN.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    ZWExhibitionVC *oneVC = [[ZWExhibitionVC alloc]init];
    oneVC.title = @"在线展会";
    [self createVC:oneVC Title:@"在线展会" imageName:@"zai_icon_dibu_zaixian_no" selectImage:@"zai_icon_dibu_zaixian_click"];
    UINavigationController *navOne = [[UINavigationController alloc]initWithRootViewController:oneVC];
    navOne.navigationBar.barTintColor = skinColor;
    navOne.navigationBar.translucent = NO;
    [navOne.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    ZWExhibitorsVC *twoVC = [[ZWExhibitorsVC alloc]init];
    twoVC.title = @"行业展商";
    [self createVC:twoVC Title:@"行业展商" imageName:@"zai_icon_dibu_hangye_no" selectImage:@"zai_icon_dibu_hangye_click"];
    UINavigationController *navTwo = [[UINavigationController alloc]initWithRootViewController:twoVC];
    navTwo.navigationBar.barTintColor = skinColor;
    navTwo.navigationBar.tintColor = [UIColor whiteColor];
    navTwo.navigationBar.translucent = NO;
    [navTwo.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    ZWExhibitionServerVC *threeVC = [[ZWExhibitionServerVC alloc]init];
    
//    ZWServiceVC *threeVC = [[ZWServiceVC alloc]init];
    threeVC.title = @"会展服务";
    [self createVC:threeVC Title:@"会展服务" imageName:@"zai_icon_dibu_fuwu_no" selectImage:@"zai_icon_dibu_fuwu_click"];
    UINavigationController *navThree = [[UINavigationController alloc]initWithRootViewController:threeVC];
    navThree.navigationBar.barTintColor = skinColor;
    navThree.navigationBar.tintColor = [UIColor whiteColor];
    navThree.navigationBar.translucent = NO;
    [navThree.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    ZWMineVC *fourVC = [[ZWMineVC alloc]init];
    fourVC.title = @"个人中心";
    [self createVC:fourVC Title:@"个人中心" imageName:@"zai_icon_dibu_geren_no" selectImage:@"zai_icon_dibu_geren_click"];
    UINavigationController *navFour = [[UINavigationController alloc]initWithRootViewController:fourVC];
    navFour.navigationBar.barTintColor = skinColor;
    navFour.navigationBar.tintColor = [UIColor whiteColor];
    navFour.navigationBar.translucent = NO;
    [navFour.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.viewControllers = @[homeN,navOne,navTwo,navThree,navFour];
    self.tabBar.tintColor = skinColor;
    
    self.homeBGImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43,43)];
    self.homeBGImage.image = [UIImage imageNamed:@"home_back"];
    self.homeBGImage.center = CGPointMake(kScreenWidth/10, 26.5);
    self.homeBGImage.layer.cornerRadius = 21.5;
    self.homeBGImage.layer.masksToBounds = YES;
    self.homeBGImage.userInteractionEnabled = YES;
    [self.tabBar addSubview:self.homeBGImage];
    
    self.homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 43,43)];
    self.homeScrollView.contentSize = CGSizeMake(43, 86);
    self.homeScrollView.showsVerticalScrollIndicator = NO;
    self.homeScrollView.alwaysBounceVertical = NO;
    self.homeScrollView.bounces = NO;
    [self.homeBGImage addSubview:self.homeScrollView];

    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];
    logoImage.image = [UIImage imageNamed:@"home_logo"];
    [self.homeScrollView addSubview:logoImage];

    UIImageView *paoDImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 43, 43)];
    paoDImage.image = [UIImage imageNamed:@"rockets_icon"];
    [self.homeScrollView addSubview:paoDImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.homeScrollView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.homeScrollView addGestureRecognizer:pan];

}

-(void)tapClick:(UIGestureRecognizer *)gesture{
    self.isRoll = !self.isRoll;
    if (self.isRoll) {
        [self.homeScrollView setContentOffset:CGPointMake(0, 43) animated:YES];
        [self postNoticeWithType:1];
    }else {
        [self.homeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self postNoticeWithType:0];
    }
}

- (void)postNoticeWithType:(NSInteger)type {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rollingTableView" object:[NSString stringWithFormat:@"%ld",type]];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController API_AVAILABLE(ios(3.0)) {
    self.oldSelectIndex = tabBarController.selectedIndex;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.selectedIndex != 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"user"];
        ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([user.uuid isEqualToString:@""]||!user.uuid) {
            tabBarController.selectedIndex = self.oldSelectIndex;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
            [self yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
                if (presented) {
                    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
                }else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTheStatusBarColor" object:nil];
                }
            }];
            return;
        }
        [self.homeBGImage removeFromSuperview];
    }else {
        tabBarController.title = @"";
        [self.tabBar addSubview:self.homeBGImage];
        [self animationWithView:self.homeBGImage];
    }
    [self animationWithIndex:tabBarController.selectedIndex];
    
}
- (void)animationWithView:(UIView *)view {
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.1;
    pulse.repeatCount= 1;
//    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1];
    [[view layer] addAnimation:pulse forKey:nil];
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
//    pulse.duration = 0.1;
    pulse.repeatCount= 1;
//    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}

- (void)requestScreeningData {
    [self requestCountriesList];
    [self requestCitiesList];
    [self requestIndustriesList];
    
}
- (void)requestCountriesList {
    
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeCountriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveCountroiesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}
- (void)requestCitiesList {
    
    [[ZWDataAction sharedAction]postReqeustWithURL:zwTakeCitiesList parametes:@{@"parentId":@"1"} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveCitiesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestIndustriesList {
    NSDictionary *mydic = @{@"level":@"2"};
//    NSDictionary *mydic = @{};
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeIndustriesList parametes:mydic successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWMainSaveLocation shareAction]saveIndustriesList:data[@"data"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


- (void)requestUserInfo {
    
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeUserInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSDictionary *myDic = data[@"data"];
            if (myDic) {
                [[ZWSaveDataAction shareAction]saveUserInfoData:myDic];
            }
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}



@end
