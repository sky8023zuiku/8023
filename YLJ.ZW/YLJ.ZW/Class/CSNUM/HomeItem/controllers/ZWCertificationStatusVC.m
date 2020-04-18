//
//  ZWCertificationStatusVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWCertificationStatusVC.h"
#import "ZWEditCompanyInfoVC.h"

@interface ZWCertificationStatusVC ()

@end

@implementation ZWCertificationStatusVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YNavigationBar sharedInstance]createSkinNavigationBar:self.navigationController.navigationBar withBackColor:skinColor withTintColor:[UIColor whiteColor]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(backBtn:)];
}
- (void)backBtn:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.25*kScreenWidth, 0.15*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth)];
    
    if (self.merchantStatus == 1) {
        imageView.image = [UIImage imageNamed:@"reviewing_image"];
        imageView.frame = CGRectMake(0.25*kScreenWidth, 0.3*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth);
    }else if (self.merchantStatus == 2) {
        imageView.image = [UIImage imageNamed:@"review_successful_image"];
        imageView.frame = CGRectMake(0.25*kScreenWidth, 0.3*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth);
    }else if (self.merchantStatus == 3) {
        imageView.image = [UIImage imageNamed:@"audit_failure_image"];
    }else {
        
    }
    [self.view addSubview:imageView];
    
    
    if (self.merchantStatus == 3) {
        UILabel *myTitle = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(imageView.frame)+0.1*kScreenWidth, 0.9*kScreenWidth, 0.1*kScreenWidth)];
        myTitle.text = @"失败原因：";
        myTitle.font = boldBigFont;
        [self.view addSubview:myTitle];
        
        CGFloat detailHeight = [[ZWToolActon shareAction]adaptiveTextHeight:@"这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因" textFont:normalFont textWidth:CGRectGetWidth(myTitle.frame)];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(myTitle.frame), CGRectGetMaxY(myTitle.frame), CGRectGetWidth(myTitle.frame), detailHeight)];
        detailLabel.text = @"这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因这是失败原因";
        detailLabel.font = normalFont;
        detailLabel.numberOfLines = 0;
        [self.view addSubview:detailLabel];
        
        
        UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editorBtn.frame = CGRectMake(0.3*kScreenWidth, CGRectGetMaxY(detailLabel.frame)+0.1*kScreenWidth, 0.4*kScreenWidth, 0.085*kScreenWidth);
        [editorBtn setBackgroundImage:[UIImage imageNamed:@"modify_image"] forState:UIControlStateNormal];
        editorBtn.adjustsImageWhenHighlighted = NO;
        [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:editorBtn];
    }
    
}

- (void)editorBtnClick:(UIButton *)btn {
    
    ZWEditCompanyInfoVC *companyInfoVC = [[ZWEditCompanyInfoVC alloc]init];
    companyInfoVC.title = @"企业信息上传";
    companyInfoVC.merchantStatus = self.merchantStatus;
    [self.navigationController pushViewController:companyInfoVC animated:YES];

}

@end
