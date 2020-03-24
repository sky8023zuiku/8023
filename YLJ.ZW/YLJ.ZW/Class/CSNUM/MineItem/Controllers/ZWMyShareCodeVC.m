//
//  ZWMyShareCodeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/28.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareCodeVC.h"
#import "UIImage+ColorGradient.h"
#import "UIViewController+YCPopover.h"
#import "ZWMyShareCodeGetVC.h"

#define navLeftColor [UIColor colorWithRed:61/255.0 green:196/255.0 blue:255/255.0 alpha:1.0]
#define navRightColor [UIColor colorWithRed:54/255.0 green:154/255.0 blue:255/255.0 alpha:1.0]

@interface ZWMyShareCodeVC ()
@property(nonatomic, strong)UIButton *priceBtn;
@property(nonatomic, strong)UILabel *topLabel;
@property(nonatomic, strong)UILabel *priceLabel;
@property(nonatomic, strong)NSMutableArray *btnArray;
@property(nonatomic, strong)NSString *remainCoin;
@property(nonatomic, strong)UILabel *remainLabel;
@property(nonatomic, strong)NSString *shareCodeNum;
@end

@implementation ZWMyShareCodeVC
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setTranslucent:true];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createNotice];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"明细" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshNumberOfShareData) name:@"refreshNumberOfShareData" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshNumberOfShareData" object:nil];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    [self showOneAlertWithMessage:@"功能建设中，敬请期待"];
}
- (void)createUI {
    
    NSLog(@"我的分享次数 = %@",self.myData[@"unBindCount"]);
    
    self.shareCodeNum = self.myData[@"unBindCount"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
//    imageView.image = [UIImage gradientColorImageFromColors:@[navLeftColor,navRightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(kScreenWidth, zwNavBarHeight)];
    imageView.backgroundColor = skinColor;
    [self.view addSubview:imageView];
    
    self.remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 0.08*kScreenWidth)];
    self.remainLabel.textAlignment = NSTextAlignmentCenter;
    self.remainLabel.text = [NSString stringWithFormat:@"剩余次数%@次",self.myData[@"unBindCount"]];
    self.remainLabel.textColor = [UIColor whiteColor];
    self.remainLabel.font = normalFont;
    [self.view addSubview:self.remainLabel];
    
//    UIButton * bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    bindBtn.frame = CGRectMake(0.425*kScreenWidth, CGRectGetMaxY(self.remainLabel.frame), 0.15*kScreenWidth, 0.05*kScreenWidth);
//    bindBtn.backgroundColor = [UIColor whiteColor];
//    [bindBtn setTitle:@"分配" forState:UIControlStateNormal];
//    [bindBtn setTitleColor:skinColor forState:UIControlStateNormal];
//    bindBtn.layer.cornerRadius = 0.025*kScreenWidth;
//    bindBtn.layer.masksToBounds = YES;
//    bindBtn.titleLabel.font = smallFont;
//    [bindBtn addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bindBtn];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.remainLabel.frame)+15, kScreenWidth-30, 0.5*kScreenWidth)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1.0];
    contentView.layer.shadowColor = [UIColor colorWithRed:6/255.0 green:0/255.0 blue:1/255.0 alpha:0.07].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0,1);
    contentView.layer.shadowOpacity = 1;
    contentView.layer.shadowRadius = 4;
    contentView.layer.cornerRadius = 3;
    [self.view addSubview:contentView];
    
    CGFloat interval = 0.05*kScreenWidth;
    CGFloat itemW = (0.8*kScreenWidth-30)/3;
    CGFloat itemH = 0.18*kScreenWidth;
    
    self.btnArray = [NSMutableArray array];
    
    NSArray *dataArray = self.myData[@"list"];
    self.remainCoin = self.myData[@"score"];
    
    int count = 3;
    for (int i = 0; i<dataArray.count; i++) {
        int row = i / count;
        int col = i % count;
        
        NSDictionary *myDataDic = dataArray[i];
        
        self.priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.priceBtn.frame = CGRectMake(interval +(interval+itemW)*col, interval+(interval + itemH)*row, itemW, itemH);
        self.priceBtn.layer.borderColor = skinColor.CGColor;
        self.priceBtn.tag = i;
        self.priceBtn.layer.borderWidth = 0.8;
        self.priceBtn.layer.cornerRadius = 2;
        self.priceBtn.layer.masksToBounds = YES;
        self.priceBtn.tag = i;
        [self.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.priceBtn];
        
        self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.15*itemH, itemW, itemH/3)];
        self.topLabel.text = [NSString stringWithFormat:@"%@次",myDataDic[@"codeCount"]];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.font = normalFont;
        self.topLabel.textColor = skinColor;
        [self.priceBtn addSubview:self.topLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), itemW, itemH/3*2-10)];
        self.priceLabel.font = [UIFont systemFontOfSize:0.06*kScreenWidth];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.text = [NSString stringWithFormat:@"会展币：%@",myDataDic[@"score"]];
        self.priceLabel.font = smallFont;
        self.priceLabel.textColor = skinColor;
        [self.priceBtn addSubview:self.priceLabel];
        
        [self.btnArray addObject:self.priceBtn];
    }
}
//- (void)bindBtnClick:(UIButton *)btn {
//    ZWMyShareBindVC *shareBindVC = [[ZWMyShareBindVC alloc]init];
//    shareBindVC.title = @"绑定分享码";
//    shareBindVC.userId = self.userId;
//    [self.navigationController pushViewController:shareBindVC animated:YES];
//}

- (void)priceBtnClick:(UIButton *)btn {
    
    NSArray *dataArray = self.myData[@"list"];
    NSDictionary *dataDic = dataArray[btn.tag];
    
    ZWMyShareCodeGetVC *CodeGetVC = [[ZWMyShareCodeGetVC alloc]init];
    CodeGetVC.dataSource = dataDic;
    CodeGetVC.score = self.remainCoin;
    [self.navigationController yc_bottomPresentController:CodeGetVC presentedHeight:0.8*kScreenWidth completeHandle:^(BOOL presented) {

    }];
    
}

- (void)refreshNumberOfShareData {
    [self showOneAlertWithMessage:@"购买成功"];
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetShareCodeList parametes:@{@"userId":self.userId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            strongSelf.remainLabel.text = [NSString stringWithFormat:@"%@次",data[@"data"][@"unBindCount"]];
//            strongSelf.shareCodeNum = data[@"data"][@"unBindCount"];
            strongSelf.remainCoin = data[@"data"][@"score"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)showOneAlertWithMessage:(NSString *)str {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:str confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}
    

@end
