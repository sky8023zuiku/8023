//
//  ZWScanResultVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWScanResultVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMainLoginVC.h"

@interface ZWScanResultVC ()
@property(nonatomic, strong)UIView *toolView;
@property(nonatomic, strong)UIImageView *headImage;
@end

@implementation ZWScanResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createRequst];
}


- (void)createRequst {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwInviterInformation parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            [strongSelf createBtnWithData:myData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
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

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *myScanDic = [self dictionaryWithJsonString:self.QrCodeStr];
    if (myScanDic) {
        if ([myScanDic[@"zw_status"] isEqualToString:@"0"]) {
            [self createScanInvitation:myScanDic];
        }
    }
}

- (void)createScanInvitation:(NSDictionary *)data {
    
    
    self.view.backgroundColor = zwGrayColor;
    
    self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth ,zwNavBarHeight+0.05*kScreenWidth, 0.9*kScreenWidth, 0.7*kScreenWidth)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    self.toolView.layer.cornerRadius = 5;
    self.toolView.layer.masksToBounds = YES;
    [self.view addSubview:self.toolView];
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth ,0.15*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    self.headImage.layer.cornerRadius = 0.075*kScreenWidth;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,data[@"zw_content"][@"headImages"]]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
    [self.toolView addSubview:self.headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+0.03*kScreenWidth, CGRectGetMinY(self.headImage.frame)+5, 0.6*kScreenWidth, 0.05*kScreenWidth)];
    nameLabel.text = [NSString stringWithFormat:@"昵称：%@",data[@"zw_content"][@"userName"]];
    nameLabel.font = boldNormalFont;
    [self.toolView addSubview:nameLabel];
    
    
    NSString *companyStr = data[@"zw_content"][@"merchantName"];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(self.headImage.frame)-0.05*kScreenWidth-10, CGRectGetWidth(nameLabel.frame), 0.06*kScreenWidth)];
    if (companyStr.length != 0) {
        companyLabel.text = [NSString stringWithFormat:@"所属公司：%@",companyStr];
    }
    companyLabel.font = smallFont;
    companyLabel.numberOfLines = 2;
    companyLabel.textColor = [UIColor grayColor];
    [self.toolView addSubview:companyLabel];
    

}

- (void)createBtnWithData:(NSDictionary *)myData {
    
    NSLog(@"我的手机号码：%@",myData[@"phone"]);
    
    NSDictionary *myScanDic = [self dictionaryWithJsonString:self.QrCodeStr];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(self.headImage.frame)+0.2*kScreenWidth, 0.8*kScreenWidth, 0.08*kScreenWidth);
    submitBtn.layer.cornerRadius = 5;
    submitBtn.titleLabel.font = normalFont;
    [self.toolView addSubview:submitBtn];
    
    if ([myData[@"phone"] isEqualToString:myScanDic[@"zw_content"][@"phone"]]) {
        [submitBtn setImage:[UIImage imageNamed:@"have _accepted_icon"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"已接受邀请" forState:UIControlStateNormal];
        [submitBtn setTitleColor:skinColor forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor whiteColor];
    }else {
        [submitBtn setTitle:@"接受邀请" forState:UIControlStateNormal];
        submitBtn.backgroundColor = skinColor;
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)submitBtnClick:(UIButton *)btn {
    NSDictionary *userInfo = [[ZWSaveDataAction shareAction]takeUserInfoData];
    if (userInfo) {
        NSLog(@"这个方法执行了吗");
        NSDictionary *myScanDic = [self dictionaryWithJsonString:self.QrCodeStr];
        NSDictionary *myDic = @{@"recommend":myScanDic[@"zw_content"][@"phone"],@"userName":myScanDic[@"zw_content"][@"userName"]};
        if (myDic) {
             [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwSetInviter parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
                 if (zw_issuccess) {
                     [self createRequst];
                 }
             } failureBlock:^(NSError * _Nonnull error) {
                 
             } showInView:self.view];
        }
    } else {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"您还未登陆展网，是否前去登陆" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
            [strongSelf yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
                if (presented) {
                    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
                }else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTheStatusBarColor" object:nil];
                }
            }];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];
    }
    
    
    
    
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
