//
//  ZWIntegralRulesVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIntegralRulesVC.h"

@interface ZWIntegralRulesVC ()

@end

@implementation ZWIntegralRulesVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    if (self.status == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0.35*kScreenWidth)];
    NSMutableAttributedString * tncString = [[NSMutableAttributedString alloc]initWithString:@"1、用户邀请新用户注册后，可获得50会展币\n2、会展币可在该平台产生消费时可用做抵扣\n3、会展币永不清零。\n4、该规则最终解释权归上海展网网络科技有限公司所有。"];
    myLabel.font = normalFont;
    myLabel.lineBreakMode = NSLineBreakByWordWrapping;
    myLabel.attributedText = tncString;
    myLabel.numberOfLines = 0;
    [self.view addSubview:myLabel];
    

}
@end
