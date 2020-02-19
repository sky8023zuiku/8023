//
//  ZWAboutUsVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAboutUsVC.h"

@interface ZWAboutUsVC ()

@end

@implementation ZWAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.25*kScreenWidth, 0.1*kScreenWidth, 0.5*kScreenWidth, 0.31*kScreenWidth)];
    titleImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:titleImageView];
    
    UITextView *contentView = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleImageView.frame)+40, kScreenWidth-40, 1.2*kScreenWidth)];
    contentView.text = @"上海展网网络科技有限公司成立于2015年01月14日，主要经营范围为从事网络科技、计算机软件、通信科技、自动化科技领域内的技术开发、技术咨询、技术服务、技术转让，计算机系统集成，计算机网络工程，网页设计，商务咨询（除经纪），会展服务，展台设计，礼仪服务，市场营销策划，公关活动策划，广告设计、制作，电脑图文设计，建筑装饰装修建设工程设计施工一体化，室内装潢设计，电子商务（不得从事增值电信、金融业务）等。";
    contentView.font = normalFont;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.view addSubview:contentView];
    
}

@end

