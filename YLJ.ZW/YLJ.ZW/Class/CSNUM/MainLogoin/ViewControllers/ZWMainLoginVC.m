//
//  ZWMainLoginVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMainLoginVC.h"
#import "ZWValidationSendVC.h"
#import "ZWAccountLoginVC.h"
#import "ZWAreaCodeVC.h"

#import "ZWAreaCodeModels.h"

#import "ZWSetPasswordVC.h"
#import "ZWAgreementVC.h"

@interface ZWMainLoginVC ()<ZWAreaCodeVCDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)UILabel *codeLabel;
@property(nonatomic, strong)UITextField *phoneText;
@property(nonatomic, strong)ZWAreaCodeModels *models;
@end

@implementation ZWMainLoginVC
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = skinColor;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"ren_bianji_icon_topshang"] barItem:self.navigationItem target:self action:@selector(backItemClick:)];
}
- (void)backItemClick:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.title = @"账号登录";
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.3*kScreenWidth, 0.1*kScreenWidth, 0.4*kScreenWidth, 0.3*kScreenWidth)];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.scrollView addSubview:logoImageView];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(logoImageView.frame)+0.1*kScreenWidth, 0.8*kScreenWidth, 0.05*kScreenWidth)];
    noticeLabel.text = @"请输入手机号码进行登录";
    noticeLabel.font = smallMediumFont;
    [self.scrollView addSubview:noticeLabel];
    
    UILabel *noticeDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame), CGRectGetMaxY(noticeLabel.frame), CGRectGetWidth(noticeLabel.frame), CGRectGetHeight(noticeLabel.frame))];
    noticeDetail.text = @" (提示:首次登录即为注册)";
    noticeDetail.font = smallFont;
    noticeDetail.textColor = [UIColor grayColor];
    [self.scrollView addSubview:noticeDetail];
    
    UIView *leftOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.18*kScreenWidth, 0.1*kScreenWidth)];
    self.codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.13*kScreenWidth, 0.1*kScreenWidth)];
    self.codeLabel.text = @"+86";
    self.codeLabel.font = normalFont;
    self.codeLabel.textAlignment = NSTextAlignmentCenter;
    self.codeLabel.textColor = [UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0];
    [leftOne addSubview:self.codeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [leftOne addGestureRecognizer:tap];
    
    UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.codeLabel.frame), 0.04*kScreenWidth, 0.03*kScreenWidth, 0.02*kScreenWidth)];
    downImage.image = [UIImage imageNamed:@"deng_icon_xia"];
    [leftOne addSubview:downImage];
    
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame)-5, CGRectGetMaxY(noticeDetail.frame)+0.05*kScreenWidth, CGRectGetWidth(noticeDetail.frame)+10, 0.1*kScreenWidth)];
    self.phoneText.placeholder = @"请输入手机号码";
    self.phoneText.leftView = leftOne;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.font = normalFont;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.phoneText];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineView];
    
    CGFloat btnHeight = [[ZWToolActon shareAction]adaptiveTextWidth:@"账号密码登录" labelFont:smallMediumFont];
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(lineView.frame), btnHeight, 0.08*kScreenWidth);
    [switchBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    switchBtn.titleLabel.font = smallMediumFont;
    [switchBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:switchBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(switchBtn.frame)+0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    nextBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = skinColor;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
    
    
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.frame = CGRectMake(0, CGRectGetMaxY(nextBtn.frame)+0.3*kScreenWidth, kScreenWidth, 0.2*kScreenWidth);
    tapBtn.titleLabel.font = smallMediumFont;
    tapBtn.titleLabel.numberOfLines = 2;
    tapBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [tapBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tapBtn];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击下一步代表同意\n《展网注册协议和隐私条款》"];
    [string addAttribute:NSFontAttributeName value:smallMediumFont range:NSMakeRange(0 , 9)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0 , 9)];
    [string addAttribute:NSForegroundColorAttributeName value:skinColor range:NSMakeRange(9, 14)];
    [tapBtn setAttributedTitle:string forState:UIControlStateNormal];
    
    self.models = [ZWAreaCodeModels parseJSON:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"中国大陆", @"country",
                                                    @"Z" , @"initial",
                                                    @"+86" , @"pretel", nil]];
    
}

- (void)tapBtnClick:(UIButton *)btn {
    ZWAgreementVC *VC = [[ZWAgreementVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)switchBtnClick:(UIButton *)btn {
    ZWAccountLoginVC *loginVC = [[ZWAccountLoginVC alloc]init];
    loginVC.title = @"账号登录";
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)nextBtnClick:(UIButton *)btn {
    
    if ([self.phoneText.text isEqualToString:@""]) {
        [self showOneItemAlertWithMessage:@"对不起，手机号码不能为空"];
        return;
    }
    ZWValidationSendVC *validationVC = [[ZWValidationSendVC alloc]init];
    validationVC.title = @"账号登录";
    validationVC.phoneStr = self.phoneText.text;
    validationVC.pres = self.models;
    [self.navigationController pushViewController:validationVC animated:YES];
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    ZWAreaCodeVC *areaVC = [[ZWAreaCodeVC alloc]init];
    areaVC.delegate = self;
    [self.navigationController pushViewController:areaVC animated:YES];
    
}

- (void)ZWAreaCodeViewControllerDelegate:(ZWAreaCodeModels*)pres {
    self.codeLabel.text = pres.pretel;
    self.models = pres;
}

- (void)showOneItemAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
