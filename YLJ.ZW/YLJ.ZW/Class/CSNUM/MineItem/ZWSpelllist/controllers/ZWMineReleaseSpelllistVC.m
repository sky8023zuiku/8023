//
//  ZWMineReleaseSpelllistVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineReleaseSpelllistVC.h"
#import "ZWMineReleaseSpelllistOneVC.h"
#import "ZWMineReleaseSpelllistTwoVC.h"
#import "ZWMineReleaseSpelllistThreeVC.h"
#import "ZWMineReleaseSpelllistFourVC.h"
#import "ZWMineReleaseSpelllistFiveVC.h"
#import "ZWMineReleaseSpelllistSixVC.h"
#import "CKSlideMenu.h"
#import "ZWMineSpellListManager.h"

@interface ZWMineReleaseSpelllistVC ()<ZWMineSpellListManagerDelegate>

@end

@implementation ZWMineReleaseSpelllistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    
    self.title = @"发布拼单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [ZWMineSpellListManager shareManager].delegate = self;

    UIView *topTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1*kScreenWidth)];
    [self.view addSubview:topTool];

    NSArray *titles = @[@"木结构拼单",@"桁架拼单",@"型材铝料拼单",@"看馆拼单",@"保险拼单",@"货车拼单"];
    
    ZWMineReleaseSpelllistOneVC *oneVC = [[ZWMineReleaseSpelllistOneVC alloc]init];
    ZWMineReleaseSpelllistTwoVC *twoVC = [[ZWMineReleaseSpelllistTwoVC alloc]init];
    ZWMineReleaseSpelllistThreeVC *threeVC = [[ZWMineReleaseSpelllistThreeVC alloc]init];
    ZWMineReleaseSpelllistFourVC *fourVC = [[ZWMineReleaseSpelllistFourVC alloc]init];
    ZWMineReleaseSpelllistFiveVC *fiveVC = [[ZWMineReleaseSpelllistFiveVC alloc]init];
    ZWMineReleaseSpelllistSixVC *sixVC = [[ZWMineReleaseSpelllistSixVC alloc]init];

    NSArray *controllers = @[oneVC,twoVC,threeVC,fourVC,fiveVC,sixVC];
    CKSlideMenu *slideMenu = [[CKSlideMenu alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1*kScreenWidth) titles:titles controllers:controllers];
    slideMenu.bodyFrame = CGRectMake(0,  0.1*kScreenWidth+0.5, self.view.frame.size.width, kScreenHeight-zwNavBarHeight-0.5);
    slideMenu.bodySuperView = self.view;
    slideMenu.indicatorStyle = SlideMenuIndicatorStyleStretch;
    slideMenu.selectedColor = skinColor;
    slideMenu.indicatorColor = skinColor;
    slideMenu.lazyLoad = YES;
    slideMenu.titleStyle = SlideMenuTitleStyleTransfrom;
    slideMenu.font = smallMediumFont;
    slideMenu.indicatorAnimatePadding = 15;
    slideMenu.showLine = NO;
    [topTool addSubview:slideMenu];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth, kScreenWidth, 0.5)];
    lineView.backgroundColor = zwGrayColor;
    [self.view addSubview:lineView];
    
}

-(void)popToViewControllers:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSepllListData" object:nil];
    [self.navigationController popViewControllerAnimated:animated];
}

@end
