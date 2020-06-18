//
//  ZWMyShareCodeGetVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/4.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareCodeGetVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMyAccountVC.h"


@interface ZWMyShareCodeGetVC ()
@property(nonatomic, strong)UILabel *balanceLB;
@property(nonatomic, strong)UIButton *buyNow;
@property(nonatomic, assign)NSInteger exhCionNum;
@end

@implementation ZWMyShareCodeGetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat kHeight = kScreenWidth;
    
    self.exhCionNum = 100;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0.05*kHeight, kScreenWidth-30, 0.15*kHeight)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = [NSString stringWithFormat:@"您将购买%@个分享码（请确认）",self.dataSource[@"codeCount"]];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.05*kScreenWidth];
    titleLable.numberOfLines = 2;
    [self.view addSubview:titleLable];
    
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMaxY(titleLable.frame), CGRectGetWidth(titleLable.frame), 0.05*kScreenWidth)];
    noticeL.textColor = [UIColor grayColor];
    noticeL.textAlignment = NSTextAlignmentCenter;
    noticeL.font = smallMediumFont;
    [self.view addSubview:noticeL];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, CGRectGetMaxY(titleLable.frame)+0.1*kHeight, 0.6*kScreenWidth, 0.08*kScreenWidth)];
    priceLabel.font = smallMediumFont;
    priceLabel.textColor = [UIColor redColor];
    [self.view addSubview:priceLabel];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需支付：%@(会展币)",self.dataSource[@"score"]]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0.045*kScreenWidth] range:NSMakeRange(0 , 4)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0 , 4)];
    priceLabel.attributedText = string;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(priceLabel.frame), CGRectGetMaxY(priceLabel.frame), CGRectGetWidth(priceLabel.frame), 1.5)];
    lineView.backgroundColor = zwGrayColor;
    [self.view addSubview:lineView];
    
    self.balanceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(lineView.frame), CGRectGetWidth(lineView.frame), 0.05*kScreenWidth)];
    self.balanceLB.text = [NSString stringWithFormat:@"剩余会展币：%@个",self.score];
    self.balanceLB.textColor = [UIColor grayColor];
    self.balanceLB.font = smallFont;
    [self.view addSubview:self.balanceLB];
    
    self.buyNow = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyNow.frame = CGRectMake(0.1*kScreenWidth, 0.55*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    [self.buyNow addTarget:self action:@selector(buyNowClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buyNow.backgroundColor = skinColor;
    self.buyNow.titleLabel.font = boldNormalFont;
    self.buyNow.layer.cornerRadius = 0.05*kScreenWidth;
    [self.view addSubview:self.buyNow];
    
    
    NSInteger remainNum = [self.score integerValue];
    NSInteger needNum = [self.dataSource[@"score"] integerValue];
    
    if (remainNum < needNum) {
        [self.buyNow setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
    }else {
        [self.buyNow setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMinY(self.buyNow.frame)-20, CGRectGetWidth(titleLable.frame), 20)];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = smallFont;
//    detailLabel.text = @"购买分享码，分享无极限";
    detailLabel.textColor = [UIColor grayColor];
    [self.view addSubview:detailLabel];
            
}


- (void)buyNowClick:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"立即购买"]) {
        [self buyExhibitionCoin];
    }else {
        [[ZWDataAction sharedAction]getReqeustWithURL:zwTopUpList parametes:@{@"type":@"0"} successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                NSArray *myData = data[@"data"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
//                    ZWTopUpModel *model = [ZWTopUpModel parseJSON:myDic];
                    ZWTopUpModel *model = [ZWTopUpModel mj_objectWithKeyValues:myDic];
                    [myArray addObject:model];
                }
                ZWMyAccountVC *VC = [[ZWMyAccountVC alloc]init];
                VC.jumpType = 0;
                VC.title = @"充值";
                VC.models = myArray;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
                [self yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
                
                }];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
    
}

- (void)buyExhibitionCoin {
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwBuyShareCode parametes:@{@"codeCount":self.dataSource[@"codeCount"],@"integral":self.dataSource[@"score"]} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshNumberOfShareData" object:nil];
        }else {
            [strongSelf showOneAlertWithMessage:@"购买失败，请稍后再试或联系客服"];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

- (void)showOneAlertWithMessage:(NSString *)str {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:str confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
