//
//  ZWExhibitionBuyActionsheetVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/22.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionBuyActionsheetVC.h"
#import "ZWApplePayAction.h"
#import "ZWMineRqust.h"
#import "ZWPayVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMyAccountVC.h"
#import "ZWPayRequest.h"
@interface ZWExhibitionBuyActionsheetVC ()
@property(nonatomic, assign)NSInteger exhCionNum;//需要支付的会展币数量
@property(nonatomic, assign)NSInteger totalExhCionNum;//总会展币数量
@property(nonatomic, strong)UILabel *balanceLB;

@property(nonatomic, strong)UIButton *buyNow;
@end

@implementation ZWExhibitionBuyActionsheetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self takeTotalExhCionNum];
    
    NSLog(@"-----------%@",self.exhibitionId);
}
- (void)createUI {
    
    CGFloat kHeight = kScreenWidth;
    
    self.exhCionNum = [self.price integerValue]*10;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0.05*kHeight, kScreenWidth-30, 0.15*kHeight)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"解锁更多展商，需购买此服务";
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.05*kScreenWidth];
    titleLable.numberOfLines = 2;
    [self.view addSubview:titleLable];
    
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMaxY(titleLable.frame), CGRectGetWidth(titleLable.frame), 0.05*kScreenWidth)];
//    noticeL.text = @"(10个会展币=人民币1元)";
    noticeL.textColor = [UIColor grayColor];
    noticeL.textAlignment = NSTextAlignmentCenter;
    noticeL.font = smallMediumFont;
    [self.view addSubview:noticeL];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, CGRectGetMaxY(titleLable.frame)+0.1*kHeight, 0.6*kScreenWidth, 0.08*kScreenWidth)];
//    priceLabel.text = [NSString stringWithFormat:@"需支付：%@会展币",self.price];
    priceLabel.font = smallMediumFont;
    priceLabel.textColor = [UIColor redColor];
    [self.view addSubview:priceLabel];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需支付：%ld(会展币)",(long)self.exhCionNum]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:0.045*kScreenWidth] range:NSMakeRange(0 , 4)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0 , 4)];
    priceLabel.attributedText = string;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(priceLabel.frame), CGRectGetMaxY(priceLabel.frame), CGRectGetWidth(priceLabel.frame), 1.5)];
    lineView.backgroundColor = zwGrayColor;
    [self.view addSubview:lineView];
    
    self.balanceLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(lineView.frame), CGRectGetWidth(lineView.frame), 0.05*kScreenWidth)];
    self.balanceLB.text = @"剩余会展币：8000个";
    self.balanceLB.textColor = [UIColor grayColor];
    self.balanceLB.font = smallFont;
    [self.view addSubview:self.balanceLB];
    
    self.buyNow = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyNow.frame = CGRectMake(0.1*kScreenWidth, 0.55*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    [self.buyNow addTarget:self action:@selector(buyNowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyNow setTitle:@"立即购买" forState:UIControlStateNormal];
    self.buyNow.backgroundColor = skinColor;
    self.buyNow.titleLabel.font = boldNormalFont;
    self.buyNow.layer.cornerRadius = 0.05*kScreenWidth;
    [self.view addSubview:self.buyNow];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMinY(self.buyNow.frame)-20, CGRectGetWidth(titleLable.frame), 20)];
    detailLabel.text = @"(购买后，可查看此展会全部展商)";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = smallFont;
    detailLabel.textColor = [UIColor grayColor];
    [self.view addSubview:detailLabel];
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-0.2*kHeight, kScreenWidth, 0.2*kHeight)];
//    image.image = [UIImage imageNamed:@"bottom_image"];
//    [self.view addSubview:image];

}
- (void)buyNowClick:(UIButton *)btn {
    
    NSLog(@"%@",self.exhibitionId);
    if ([btn.titleLabel.text isEqualToString:@"立即购买"]) {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认购买" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf createOrder];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];
    }else {
        
        [[ZWDataAction sharedAction]getReqeustWithURL:zwTopUpList parametes:@{@"type":@"0"} successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                
                NSArray *myData = data[@"data"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWTopUpModel *model = [ZWTopUpModel parseJSON:myDic];
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

- (void)createOrder {
    if (self.exhibitionId) {
        NSDictionary *parametes = @{@"goodsId":self.exhibitionId,
                                    @"type":@"1",
                                    @"count":@"1"};
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitionCreateOrder parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                NSDictionary *myDic = data[@"data"];
                ZWCreateOrderModel *model = [ZWCreateOrderModel parseJSON:myDic];
                [strongSelf buyAlreading:model];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self.view];
    }else {
        [self showOneAlertWithMessage:@"购买失败"];
    }
}

- (void)takeTotalExhCionNum {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhRemainNum parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSInteger num = [data[@"data"][@"score"] integerValue];
//            NSInteger num = 1000;
            strongSelf.balanceLB.text = [NSString stringWithFormat:@"剩余会展币：%ld个",(long)num];
            if (strongSelf.exhCionNum > num) {
                [strongSelf.buyNow setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
            }else {
                [strongSelf.buyNow setTitle:@"立即购买" forState:UIControlStateNormal];
            }
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }showInView:self.view];
}

- (void)buyAlreading:(ZWCreateOrderModel *)model {
    NSInteger price = [model.price integerValue]*10;
    ZWPayRequest *request = [[ZWPayRequest alloc]init];
    request.orderNum = model.orderNum;
    request.score = [NSString stringWithFormat:@"%ld",(long)price];
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [strongSelf showOneAlertWithMessage:@"购买成功"];
        }
    }];
}
- (void)showOneAlertWithMessage:(NSString *)message {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([message isEqualToString:@"购买成功"]) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTheLeftList" object:nil];
        }
    } showInView:self];
}



@end
