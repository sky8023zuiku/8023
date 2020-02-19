//
//  ZWMyAccountVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyAccountVC.h"
#import "ZWIntegralExchangeVC.h"
#import "ZWIntegralRulesVC.h"
#import "UIView+MJExtension.h"
#import "ZWApplePayAction.h"
#define backImageViewH 0.4*kScreenWidth+zwStatusBarHeight+zwNavBarHeight

@interface ZWMyAccountVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UILabel *amountLabel;

@end

@implementation ZWMyAccountVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -zwStatusBarHeight, kScreenWidth, kScreenHeight+zwStatusBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequset];
    [self createNotice];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshExhCion) name:@"refreshExhCion" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshExhCion" object:nil];
}

- (void)refreshExhCion {
    [self createRequset];
}

- (void)createNavigationBar {
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, zwNavBarHeight)];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, zwStatusBarHeight+7, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"zai_zxiang_icon_chanx"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, zwStatusBarHeight, 80, zwNavBarHeight-zwStatusBarHeight)];
    titleLabel.text = @"账户";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    
    CGFloat btnWidth = [[ZWToolActon shareAction]adaptiveTextWidth:@"规则" labelFont:[UIFont systemFontOfSize:17]];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kScreenWidth-15-btnWidth, zwStatusBarHeight, btnWidth, zwNavBarHeight-zwStatusBarHeight);
    [rightBtn setTitle:@"规则" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)backBtnClick:(UIButton *)btn {
    if (self.jumpType == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightBtnClick:(UIButton *)btn {
    
    ZWIntegralRulesVC *integralRulesVC = [[ZWIntegralRulesVC alloc]init];
    integralRulesVC.title = @"规则";
    [self.navigationController pushViewController:integralRulesVC animated:YES];
    
}

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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        UIImageView *bkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, backImageViewH)];
        bkImageView.image = [UIImage imageNamed:@"top-up-bg"];
        [cell.contentView addSubview:bkImageView];
        
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth+zwNavBarHeight, kScreenWidth, 0.1*kScreenWidth)];
        self.amountLabel.text = @"0";
        self.amountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.08*kScreenWidth];
        self.amountLabel.textColor = [UIColor whiteColor];
        self.amountLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:self.amountLabel];
        
        UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountLabel.frame), kScreenWidth, 0.05*kScreenWidth)];
        noticeLabel.text = @"当前会展币";
        noticeLabel.font = normalFont;
        noticeLabel.textColor = [UIColor whiteColor];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:noticeLabel];
        
        UIButton *mxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mxBtn.frame = CGRectMake(0.4*kScreenWidth, CGRectGetMaxY(noticeLabel.frame)+10, 0.2*kScreenWidth, 0.06*kScreenWidth);
        mxBtn.layer.cornerRadius = 0.025*kScreenWidth;
        mxBtn.layer.masksToBounds = YES;
        mxBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        mxBtn.layer.borderWidth = 1;
        [mxBtn setTitle:@"会展币明细" forState:UIControlStateNormal];
        mxBtn.titleLabel.font = smallMediumFont;
        [mxBtn addTarget:self action:@selector(mxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:mxBtn];
        
    }else {
                
        CGFloat interval = 0.05*kScreenWidth;
        CGFloat itemW = 0.8*kScreenWidth/3;
        CGFloat itemH = 0.18*kScreenWidth;
        
        int count = 3;
        for (int i = 0; i<self.models.count; i++) {
            int row = i / count;
            int col = i % count;
            
            UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            priceBtn.frame = CGRectMake(interval +(interval+itemW)*col, interval+(interval + itemH)*row, itemW, itemH);
            priceBtn.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:0.1];
            priceBtn.layer.borderColor = skinColor.CGColor;
            priceBtn.tag = i;
            priceBtn.layer.borderWidth = 1;
            priceBtn.layer.cornerRadius = 5;
            priceBtn.layer.masksToBounds = YES;
            [priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:priceBtn];
            
            UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, itemW, itemH/3)];
            topLabel.text = [NSString stringWithFormat:@"%@会展币",self.models[i].score];
            topLabel.textAlignment = NSTextAlignmentCenter;
            topLabel.font = smallMediumFont;
            [priceBtn addSubview:topLabel];
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame), itemW, itemH/3*2-10)];
            priceLabel.font = [UIFont systemFontOfSize:0.06*kScreenWidth];
            priceLabel.textAlignment = NSTextAlignmentCenter;
            priceLabel.textColor = [UIColor colorWithRed:239.0/255.0 green:143.0/255.0 blue:15.0/255.0 alpha:1];
            [priceBtn addSubview:priceLabel];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",self.models[i].phonePrice]];
            [string addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0 , 1)];
            priceLabel.attributedText = string;
            
        }
    }
}
- (void)priceBtnClick:(UIButton *)btn {
    NSDictionary * parameter = @{@"productId":[NSString stringWithFormat:@"com.zw.exhibition_coin_00%ld",(long)btn.tag+1],
                                @"applePriceId":self.models[btn.tag].ID};
    [[ZWApplePayAction shareIAPAction]requestProducts:parameter withViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return backImageViewH;
    }else {
        return 0.8*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)mxBtnClick:(UIButton *)btn {
    ZWIntegralExchangeVC * exchangeVC = [[ZWIntegralExchangeVC alloc]init];
    exchangeVC.title = @"会展币明细";
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

- (void)gzBtnClick:(UIButton *)btn {
    ZWIntegralRulesVC *VC = [[ZWIntegralRulesVC alloc]init];
    VC.title = @"积分规则";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)createRequset {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhRemainNum parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSNumber *num = data[@"data"][@"score"];
            strongSelf.amountLabel.text = [NSString stringWithFormat:@"%@",num];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }showInView:self.view];
}

@end
