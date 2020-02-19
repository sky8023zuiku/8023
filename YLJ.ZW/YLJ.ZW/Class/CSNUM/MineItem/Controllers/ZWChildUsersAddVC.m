//
//  ZWChildUsersAddVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWChildUsersAddVC.h"
#import "ZWMineRqust.h"

@interface ZWChildUsersAddVC ()
@property(nonatomic, strong)UITextField *phoneText;//手机号码
@property(nonatomic, strong)UITextField *passwordText;//密码
@property(nonatomic, strong)UITextField *validationText;//验证码
@end

@implementation ZWChildUsersAddVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**手机号码**/
    UIView *phoneLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UIButton *areaCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    areaCodeBtn.frame = CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth);
    [areaCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
    [areaCodeBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    areaCodeBtn.titleLabel.font = normalFont;
    [phoneLeftView addSubview:areaCodeBtn];
    
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth)];
    self.phoneText.leftView = phoneLeftView;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.placeholder = @"请输入您的手机号码";
    self.phoneText.font = normalFont;
    [self.view addSubview:self.phoneText];
    
    UIView *lineV01 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 1)];
    lineV01.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:lineV01];
    
    /**密码**/
    UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UIImageView *passWordImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.075*kScreenWidth-CGRectGetHeight(passwordLeftView.frame)/3, 0.05*kScreenWidth-CGRectGetHeight(passwordLeftView.frame)/3, CGRectGetHeight(passwordLeftView.frame)/3*2, CGRectGetHeight(passwordLeftView.frame)/3*2)];
    passWordImage.image = [UIImage imageNamed:@"ren_she_icon_mi"];
    [passwordLeftView addSubview:passWordImage];
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame)+20, CGRectGetWidth(self.phoneText.frame), CGRectGetHeight(self.phoneText.frame))];
    self.passwordText.leftView = passwordLeftView;
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    self.passwordText.placeholder = @"请输入8-12为英文或数字的新密码";
    self.passwordText.font = normalFont;
    [self.view addSubview:self.passwordText];
    
    UIView *lineV02 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.passwordText.frame), CGRectGetMaxY(self.passwordText.frame), CGRectGetWidth(self.passwordText.frame), 1)];
    lineV02.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:lineV02];
    
    /**验证码**/
    UIView *validationLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UIImageView *validationImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.075*kScreenWidth-CGRectGetHeight(passwordLeftView.frame)/3, 0.05*kScreenWidth-CGRectGetHeight(passwordLeftView.frame)/3, CGRectGetHeight(passwordLeftView.frame)/3*2, CGRectGetHeight(passwordLeftView.frame)/3*2)];
    validationImage.image = [UIImage imageNamed:@"ren_she_icon_yan"];
    [validationLeftView addSubview:validationImage];
    
    
    UIView *obtainCodeRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.1*kScreenWidth)];
    
    UIButton *obtainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    obtainBtn.frame = CGRectMake(0, 0.01*kScreenWidth, 0.2*kScreenWidth, 0.07*kScreenWidth);
    [obtainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtainBtn setTitleColor: [UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    obtainBtn.layer.cornerRadius = 5;
    obtainBtn.titleLabel.font = smallMediumFont;
    obtainBtn.layer.borderColor = [UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0].CGColor;
    obtainBtn.layer.borderWidth = 1;
    [obtainBtn addTarget:self action:@selector(obtainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [obtainCodeRightView addSubview:obtainBtn];
    
    self.validationText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.passwordText.frame), CGRectGetMaxY(self.passwordText.frame)+20, CGRectGetWidth(self.passwordText.frame), CGRectGetHeight(self.passwordText.frame))];
    self.validationText.leftView = validationLeftView;
    self.validationText.leftViewMode = UITextFieldViewModeAlways;
    self.validationText.rightView = obtainCodeRightView;
    self.validationText.rightViewMode = UITextFieldViewModeAlways;
    self.validationText.placeholder = @"请输入验证码";
    self.validationText.font = normalFont;
    [self.view addSubview:self.validationText];
    UIView *lineV03 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.validationText.frame), CGRectGetMaxY(self.validationText.frame), CGRectGetWidth(self.validationText.frame), 1)];
    lineV03.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:lineV03];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(CGRectGetMinX(self.validationText.frame), CGRectGetMaxY(self.validationText.frame)+0.2*kScreenWidth, CGRectGetWidth(self.validationText.frame), 0.1*kScreenWidth);
    addBtn.backgroundColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
    addBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = normalFont;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}

-(void)obtainBtnClick:(UIButton *)btn {
    ZWSendSMSRequst *request = [[ZWSendSMSRequst alloc]init];
    BOOL isPhone = [[ZWToolActon shareAction]valiMobile:self.phoneText.text];
    if (!isPhone) {
        [self showOneAlertWithTitle:@"手机号码格式错误，请确认"];
        return;
    }
    request.phone = self.phoneText.text;
    request.pre_phone = @"86";
    request.type = @"1";
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"验证码发送成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                [[ZWToolActon shareAction]theCountdownforTime:60 whthColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] withButton:btn];
            } showInView:strongSelf];
            NSLog(@"%@",respense.data);
        }else {
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"验证码发送失败，请检查网络或稍后再试" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                
            } showInView:strongSelf];
        }
    }];
}

- (void)addBtnClick:(UIButton *)btn {
    
    if ([self.phoneText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"手机号码不能为空"];
        return;
    }
    if ([self.passwordText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"密码不能为空"];
        return;
    }
    if ([self.validationText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"验证码不能为空"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认添加" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf childAddByRequest];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}

- (void)childAddByRequest {
    ZWChildUserAddRequst *requst = [[ZWChildUserAddRequst alloc]init];
    requst.phone = self.phoneText.text;
    requst.password = self.passwordText.text;
    requst.checkCode = self.validationText.text;
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = self;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"子用户添加成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                __strong typeof (weakSelf) strongSelf = self;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWChildUserManagerVC" object:nil];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } showInView:strongSelf];
        }else {
            [self showOneAlertWithTitle:@"子用户添加失败"];
        }
    }];
}



-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ZWChildUserManagerVC" object:nil];
}
@end
