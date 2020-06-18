//
//  ZWPayVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWPayVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMineRqust.h"
#import "ZWIntegralRulesVC.h"
#import "ZWIntegralExchangeVC.h"
#import "ZWPayRequest.h"
#import "ZWMyAccountVC.h"
#import "ZWTopUpModel.h"

@interface ZWPayVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *payTypeBtn;//显示支付方式
@property(nonatomic, strong)UILabel *payPrice;//最终支付价格
@property(nonatomic, strong)UILabel *deductionIntegral;//抵扣的积分
@property(nonatomic, strong)UILabel *preferentialLabel;//已经优惠
@property(nonatomic, strong)UITextField *addSubtract;//显示抵扣积分的份数值，100积分为一份
@property(nonatomic, assign)int number;//抵扣的份数
@property(nonatomic, strong)UILabel *deductionLabel;//第一个抵扣会展币显示
@property(nonatomic, strong)UIButton *rulesBtn;//规则按钮
@property(nonatomic, strong)UILabel *deductionPrice;//
@property(nonatomic, assign)int maxNumber;//会展币能够抵扣的最大份数
@property(nonatomic, assign)int maxIntegralNumber;//拥有的会展币可抵扣最大的份数
@property(nonatomic, strong)UILabel *totalLabel;//显示实际要支付多会展币
@property(nonatomic, assign)int score;//会展币数量
@property(nonatomic, strong)UIButton *submitBtn;

@end

@implementation ZWPayVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
}
- (void)createRequest {
    ZWCheckIntegralRequest *request = [[ZWCheckIntegralRequest alloc]init];
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            
            int scoreNum = [respense.data[@"score"] intValue];
            
            strongSelf.maxIntegralNumber = scoreNum/100;
            
            NSInteger myPrice;
            int conut;
            if (self.status == 1) {
                conut = [self.orderModel.count intValue];
                myPrice = [self.orderModel.price intValue]*conut*10;
                
            }else {
                conut = [self.model.count intValue];
                myPrice = [self.model.price intValue]*conut*10;
            }
            
            if (scoreNum<myPrice) {
                [self.submitBtn setTitle:@"余额不足，去充值" forState:UIControlStateNormal];
                self.submitBtn.titleLabel.font = smallMediumFont;
            }else {
                [self.submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    if (self.status==1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.number = 0;
    self.score = 0;
    if (self.status == 1) {
        self.maxNumber = [self.orderModel.price floatValue]/10;
    }else {
        self.maxNumber = [self.model.price floatValue]/10;
    }
    NSLog(@"我能够抵扣的最大份数%d",self.maxNumber);
    self.title = @"确认订单";
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-zwTabBarHeight-zwNavBarHeight, kScreenWidth, zwTabBarHeight)];
    bottomView.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, 1)];
    lineView.backgroundColor = skinColor;
    [bottomView addSubview:lineView];
    
    NSInteger myPrice;
    int conut;
    if (self.status == 1) {
        conut = [self.orderModel.count intValue];
        myPrice = [self.orderModel.price integerValue]*conut*10;
        
    }else {
        conut = [self.model.count intValue];
        myPrice = [self.model.price integerValue]*conut*10;
        
    }
    self.payPrice = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, kScreenWidth/3-11, zwTabBarHeight)];
    self.payPrice.text = [NSString stringWithFormat:@"%ld会展币",(long)myPrice];
    self.payPrice.font = boldBigFont;
    [bottomView addSubview:self.payPrice];
            
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(kScreenWidth-kScreenWidth/3, 0, kScreenWidth/3, zwTabBarHeight);
    self.submitBtn.backgroundColor = skinColor;
    [self.submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = normalFont;
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.submitBtn];

}
- (void)submitBtnClick:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"立即支付"]) {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认购买" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf payOrder];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];
    }else {
        [[ZWDataAction sharedAction]getReqeustWithURL:zwTopUpList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
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

- (void)payOrder {
    NSString *orderNum;
    NSInteger myPrice;
    int conut;
    if (self.status == 1) {
        orderNum = self.orderModel.orderNum;
        conut = [self.orderModel.count intValue];
        myPrice = [self.orderModel.price integerValue]*conut*10;
    }else {
        orderNum = self.model.order_num;
        conut = [self.model.count intValue];
        myPrice = [self.model.price integerValue]*conut*10;
    }
    ZWPayRequest *request = [[ZWPayRequest alloc]init];
    request.orderNum = orderNum;
    request.score = [NSString stringWithFormat:@"%ld",(long)myPrice];
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [strongSelf showOneAlertWithMassage:@"购买成功"];
        }
    }];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.25*kScreenWidth-1, kScreenWidth-20, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
            [cell.contentView addSubview:lineView];
            
            UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 0.25*kScreenWidth+10, 0.25*kScreenWidth-20)];
            [cell.contentView addSubview:titleImage];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+10, CGRectGetMinY(titleImage.frame), kScreenWidth-CGRectGetWidth(titleImage.frame)-30, CGRectGetHeight(titleImage.frame)/2)];
            titleLabel.font = normalFont;
            titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            titleLabel.numberOfLines = 2;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *attributeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), 0.2*CGRectGetHeight(titleImage.frame))];
            attributeLabel.font = smallMediumFont;
            attributeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
            [cell.contentView addSubview:attributeLabel];
            
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(attributeLabel.frame), CGRectGetMaxY(attributeLabel.frame), 0.5*kScreenWidth, 0.3*CGRectGetHeight(titleImage.frame))];
            priceLabel.font = boldBigFont;
            priceLabel.textColor = [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
            [cell.contentView addSubview:priceLabel];
            
            if (self.status == 1) {
                [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.orderModel.url]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
                titleLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.name];
                attributeLabel.text = [NSString stringWithFormat:@"属性：电子会刊 X%@",self.orderModel.count];
                CGFloat myPrice = [self.orderModel.price floatValue];
                int conut = [self.orderModel.count intValue];
                
                NSLog(@"======我的钱%f",myPrice);
                NSLog(@"======我的钱%@",self.orderModel.price);
                
                priceLabel.text = [NSString stringWithFormat:@"¥ %0.2f",myPrice*conut];
                               
            }else {
                
                [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.model.cover_images]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
                titleLabel.text = [NSString stringWithFormat:@"%@",self.model.name];
                attributeLabel.text = [NSString stringWithFormat:@"属性：电子会刊 X%@",self.model.count];
                
                int conut = [self.model.count intValue];
                NSInteger myPrice = [self.model.price integerValue]*10*conut;
                priceLabel.text = [NSString stringWithFormat:@"%ld会展币",(long)myPrice];
                
            }
        }else {

            
        }
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 0.25*kScreenWidth;
        }else {
            return 0.1*kScreenWidth;
        }
    }else {
        return 0.1*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.03*kScreenWidth;
}
- (void)showOneAlertWithMassage:(NSString *)message {
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        if ([message isEqualToString:@"购买成功"]) {
            if (self.status == 1) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } showInView:self];
    
}

@end
