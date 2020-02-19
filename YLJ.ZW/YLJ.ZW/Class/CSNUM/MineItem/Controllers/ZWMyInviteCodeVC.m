//
//  ZWMyInviteCodeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInviteCodeVC.h"

@interface ZWMyInviteCodeVC ()

@end

@implementation ZWMyInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth)];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.image = [UIImage imageNamed:@"Qr_code_image"];
    [self.view addSubview:imageView];
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame), 0.5*kScreenWidth, 0.15*kScreenWidth)];
    scanLabel.text = @"扫一扫";
    scanLabel.font = [UIFont systemFontOfSize:0.065*kScreenWidth];
    scanLabel.textColor = [UIColor lightGrayColor];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scanLabel];
    
    
}
@end
