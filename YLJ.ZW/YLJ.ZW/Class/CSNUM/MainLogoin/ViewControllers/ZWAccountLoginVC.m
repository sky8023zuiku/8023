//
//  ZWAccountLoginVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAccountLoginVC.h"
#import "ZWChangePasswordVC.h"
#import "ZWAreaCodeVC.h"
#import "ZWAreaCodeModels.h"
@interface ZWAccountLoginVC ()<ZWAreaCodeVCDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)UILabel *codeLabel;

@property(nonatomic, strong)UITextField *phoneText;
@property(nonatomic, strong)UITextField *passText;
@end

@implementation ZWAccountLoginVC

-(TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.3*kScreenWidth, 0.1*kScreenWidth, 0.4*kScreenWidth, 0.3*kScreenWidth)];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.scrollView addSubview:logoImageView];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(logoImageView.frame)+0.1*kScreenWidth, 0.8*kScreenWidth, 0.05*kScreenWidth)];
    noticeLabel.text = @"账号密码登录";
    noticeLabel.font = normalFont;
    [self.scrollView addSubview:noticeLabel];
    
    UIView *leftOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.18*kScreenWidth, 0.1*kScreenWidth)];
    self.codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.13*kScreenWidth, 0.1*kScreenWidth)];
    self.codeLabel.text = @"+86";
    self.codeLabel.textAlignment = NSTextAlignmentCenter;
    self.codeLabel.font = normalFont;
    self.codeLabel.textColor = [UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0];
    [leftOne addSubview:self.codeLabel];
    
    UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.codeLabel.frame), 0.04*kScreenWidth, 0.03*kScreenWidth, 0.02*kScreenWidth)];
    downImage.image = [UIImage imageNamed:@"deng_icon_xia"];
    [leftOne addSubview:downImage];
    
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame)-5, CGRectGetMaxY(noticeLabel.frame)+0.05*kScreenWidth, CGRectGetWidth(noticeLabel.frame)+10, 0.1*kScreenWidth)];
    self.phoneText.placeholder = @"请输入手机号码";
    self.phoneText.leftView = leftOne;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.font = normalFont;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.phoneText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    [leftOne addGestureRecognizer:tap];
    
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineOne];
    
    UIView *leftTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.18*kScreenWidth, 0.1*kScreenWidth)];
    
    UIImageView *passImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.065*kScreenWidth, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
    passImage.image = [UIImage imageNamed:@"ren_zi_icon_mi"];
    [leftTwo addSubview:passImage];
    
    self.passText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame)+0.05*kScreenWidth, CGRectGetWidth(lineOne.frame), CGRectGetHeight(self.phoneText.frame))];
    self.passText.placeholder = @"请输入密码";
    self.passText.leftView = leftTwo;
    self.passText.leftViewMode = UITextFieldViewModeAlways;
    self.passText.font = normalFont;
    self.passText.secureTextEntry = YES;
    [self.scrollView addSubview:self.passText];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.passText.frame), CGRectGetMaxY(self.passText.frame), CGRectGetWidth(self.passText.frame), 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineTwo];
    
    CGFloat btnHeight = [[ZWToolActon shareAction]adaptiveTextWidth:@"验证码登录" labelFont:smallMediumFont];
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(CGRectGetMinX(lineTwo.frame), CGRectGetMaxY(lineTwo.frame), btnHeight, 0.08*kScreenWidth);
    [switchBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    switchBtn.titleLabel.font = smallMediumFont;
    [switchBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:switchBtn];
    
    
    CGFloat forgotWidth = [[ZWToolActon shareAction]adaptiveTextWidth:@"忘记密码" labelFont:smallMediumFont];
    UIButton *forgotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotBtn.frame = CGRectMake(CGRectGetMaxX(lineTwo.frame)-forgotWidth, CGRectGetMinY(switchBtn.frame), forgotWidth, CGRectGetHeight(switchBtn.frame));
    [forgotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = smallMediumFont;
    [forgotBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:forgotBtn];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(switchBtn.frame)+0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    loginBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = skinColor;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:loginBtn];
          
}
- (void)switchBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapGestureClick:(UITapGestureRecognizer *)tap {
    ZWAreaCodeVC *areaCodeVC = [[ZWAreaCodeVC alloc]init];
    areaCodeVC.delegate = self;
    [self.navigationController pushViewController:areaCodeVC animated:YES];
}
- (void)loginBtnClick:(UIButton *)btn {
    if (self.phoneText.text.length<11) {
        [self showOneAlertWithMessage:@"请输入正确的手机号码"];
        return;
    }
    if ([self.phoneText.text isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"密码不能为空"];
        return;
    }
    [self loginRequest];
}
- (void)forgotBtnClick:(UIButton *)btn {
    ZWChangePasswordVC *passwordVC = [[ZWChangePasswordVC alloc]init];
    passwordVC.title = @"修改密码";
    [self.navigationController pushViewController:passwordVC animated:YES];
}

-(void)ZWAreaCodeViewControllerDelegate:(ZWAreaCodeModels*)pres {
    self.codeLabel.text = pres.pretel;
}

-(void)loginRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwLogin parametes:@{@"phone":self.phoneText.text,@"password":self.passText.text} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            //存储登录信息
            ZWUserInfo *user = [ZWUserInfo ff_convertModelWithJsonDic:data[@"data"]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"user"];
            [[FFProgressHUD sharedProgressHUD] toastTitle:[NSString stringWithFormat:@"登录成功"]];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"requestUserInfo" object:nil];
        }else {
            [strongSelf showOneAlertWithMessage:@"登陆失败，请检查账号密码是否正确"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
}


- (void)showOneAlertWithMessage:(NSString *)message {
    
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
    
}


@end
