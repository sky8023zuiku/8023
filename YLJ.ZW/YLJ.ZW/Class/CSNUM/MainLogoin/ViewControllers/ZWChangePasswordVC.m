//
//  ZWChangePasswordVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWChangePasswordVC.h"
#import "ZWAreaCodeVC.h"
#import "ZWAreaCodeModels.h"
#import "SecureCodeTimerManager.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ZWChangePasswordVC ()<ZWAreaCodeVCDelegate,UITextFieldDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)ZWAreaCodeModels *models;
@property(nonatomic, strong)UILabel *codeLabel;
@property(nonatomic, strong)UITextField *phoneText;
@property(nonatomic, strong)UITextField *passText;
@property(nonatomic, strong)UITextField *validationText;
@property(nonatomic, strong)UIButton *obtainBtn;
@end

@implementation ZWChangePasswordVC
- (TPKeyboardAvoidingScrollView *)scrollView {
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
    noticeLabel.text = @"设置新密码";
    noticeLabel.font = normalFont;
    [self.scrollView addSubview:noticeLabel];
    
    UIView *leftOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [leftOne addGestureRecognizer:tap];
    
    self.codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.1*kScreenWidth, 0.1*kScreenWidth)];
    self.codeLabel.text = @"+86";
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
    [self.scrollView addSubview:self.phoneText];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineOne];
    
    UIView *leftTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    UIImageView *passImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
    passImage.image = [UIImage imageNamed:@"ren_zi_icon_mi"];
    [leftTwo addSubview:passImage];
    
    self.passText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame)+0.05*kScreenWidth, CGRectGetWidth(lineOne.frame), CGRectGetHeight(self.phoneText.frame))];
    self.passText.placeholder = @"请输入新密码（8到16位）";
    self.passText.leftView = leftTwo;
    self.passText.leftViewMode = UITextFieldViewModeAlways;
    self.passText.font = normalFont;
    self.passText.keyboardType = UIKeyboardTypeASCIICapable;
    self.passText.delegate = self;
    self.passText.secureTextEntry = YES;
    [self.passText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.passText];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.passText.frame), CGRectGetMaxY(self.passText.frame), CGRectGetWidth(self.passText.frame), 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineTwo];
    
    UIView *leftThree = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    UIImageView *validationImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
    validationImage.image = [UIImage imageNamed:@"ren_she_icon_yan"];
    [leftThree addSubview:validationImage];
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.2*kScreenWidth, 0.1*kScreenWidth)];
        
    self.obtainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.obtainBtn.frame = CGRectMake(0, 0.02*kScreenWidth, 0.2*kScreenWidth, 0.06*kScreenWidth);
    self.obtainBtn.layer.cornerRadius = 0.03*kScreenWidth;
    self.obtainBtn.layer.masksToBounds = YES;
    self.obtainBtn.layer.borderWidth = 1;
    self.obtainBtn.layer.borderColor = [UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0].CGColor;
    [self.obtainBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.obtainBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.obtainBtn.titleLabel.font = smallFont;
    [self.obtainBtn addTarget:self action:@selector(obtainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.obtainBtn];
    
    self.validationText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.passText.frame), CGRectGetMaxY(self.passText.frame)+0.05*kScreenWidth, CGRectGetWidth(lineOne.frame), CGRectGetHeight(self.passText.frame))];
    self.validationText.placeholder = @"请输验证码";
    self.validationText.leftView = leftThree;
    self.validationText.leftViewMode = UITextFieldViewModeAlways;
    self.validationText.rightView = rightView;
    self.validationText.rightViewMode = UITextFieldViewModeAlways;
    self.validationText.font = normalFont;
    [self.scrollView addSubview:self.validationText];
    
    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.validationText.frame), CGRectGetMaxY(self.validationText.frame), CGRectGetWidth(self.validationText.frame), 1)];
    lineThree.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.scrollView addSubview:lineThree];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(lineThree.frame)+0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    confirmBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = skinColor;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:confirmBtn];
    
    self.models = [ZWAreaCodeModels parseJSON:[NSDictionary dictionaryWithObjectsAndKeys:
                                               @"中国大陆", @"country",
                                               @"Z" , @"initial",
                                               @"+86" , @"pretel", nil]];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownExecutingWithTimeOut:) name:kLoginCountDownExecutingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownCompleted) name:kLoginCountDownCompletedNotification object:nil];
}
#pragma mark - NSNotification 处理倒计时事件
- (void)loginTimerCountDownExecutingWithTimeOut:(NSNotification *)notification {
    self.obtainBtn.enabled = NO;
    NSInteger timeOut = [notification.object integerValue];
    [self.obtainBtn setTitle: [NSString stringWithFormat:@"重新发送(%ld)",(long)timeOut] forState:(UIControlStateNormal)];
    
}

- (void)loginTimerCountDownCompleted {
    self.obtainBtn.enabled = YES;
    [self.obtainBtn setTitle:  @"获取验证码" forState:(UIControlStateNormal)];
    [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
}

- (void)obtainBtnClick:(UIButton *)btn {
    if (self.phoneText.text.length<11) {
        [self showOneItemAlertWithMessage:@"请输入正确的手机号码"];
        return;
    }
    [self getSMSRequest];
}

- (void)confirmBtnClick:(UIButton *)btn {
    if (self.phoneText.text.length<11) {
        [self showOneItemAlertWithMessage:@"请输入正确的手机号码"];
        return;
    }
    if (self.passText.text.length<6) {
        [self showOneItemAlertWithMessage:@"请输入8到16位密码"];
        return;
    }
    if (self.validationText.text.length<4) {
        [self showOneItemAlertWithMessage:@"请输入正确的验证码"];
        return;
    }
    [self forgetPWRequest];
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


// 只能输入字母和数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
// 小写字母转大写字母
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text uppercaseString];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = 16;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange) {
        if (toBeString.length > maxLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:maxLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}

- (void)getSMSRequest {
    if (self.models) {
        NSDictionary *parametes = @{@"phone":self.phoneText.text,
                                    @"type":@"1",
                                    @"pre_phone":[self.models.pretel substringFromIndex:1],
                                    @"countryName":self.models.country};
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeVerificationCode parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSlef = weakSelf;
            if (zw_issuccess) {
                strongSlef.obtainBtn.enabled = NO;
                // 创建定时器
                [[SecureCodeTimerManager sharedInstance] timerCountDownWithType:kCountDownTypeLogin];
                [strongSlef showOneItemAlertWithMessage:@"验证码发送成功"];
            }else {
                [strongSlef showOneItemAlertWithMessage:@"验证码发送失败"];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            __strong typeof (weakSelf) strongSlef = weakSelf;
            [strongSlef showOneItemAlertWithMessage:@"验证码发送失败"];
        }];
    }
}
-(void)forgetPWRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwForgotPassword parametes:@{@"phone":self.phoneText.text,@"password":self.passText.text,@"checkCode":self.validationText.text} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [strongSelf showOneItemAlertWithMessage:@"密码修改成功"];
        }else {
            [strongSelf showOneItemAlertWithMessage:@"密码修改失败"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (void)showOneItemAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

    
@end
