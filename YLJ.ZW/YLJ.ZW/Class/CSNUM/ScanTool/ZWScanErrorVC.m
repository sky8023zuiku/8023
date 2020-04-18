//
//  ZWScanErrorVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/19.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWScanErrorVC.h"

@interface ZWScanErrorVC ()

@end

@implementation ZWScanErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.QrCodeStr textFont:normalFont textWidth:kScreenWidth-20];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, zwNavBarHeight+10, kScreenWidth-20, height)];
    textLabel.text = self.QrCodeStr;
    textLabel.font = normalFont;
    textLabel.textColor = [UIColor blackColor];
    [self.view addSubview:textLabel];
}

- (void)createNavigationBar {
    
    UIView *navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, zwNavBarHeight)];
    navi.backgroundColor = skinColor;
    [self.view addSubview:navi];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, zwStatusBarHeight+10, 15, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"zai_dao_icon_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-50, CGRectGetMinY(backBtn.frame), 100, 20)];
    titleLabel.text = @"扫描结果";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:titleLabel];
}

- (void)backBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
