//
//  ZWValidationSendVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWValidationSendVC.h"
#import "PZXVerificationCodeView.h"
#import "SecureCodeTimerManager.h"
#import "ZWSetPasswordVC.h"
@interface ZWValidationSendVC ()
@property(nonatomic, strong)PZXVerificationCodeView *codeViewText;
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)UIButton *countdownBtn;
@end

@implementation ZWValidationSendVC

-(TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    }
    return _scrollView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITextField *textField = _codeViewText.textFieldArray[0];
    [textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createNotice];
    if (![SecureCodeTimerManager sharedInstance].loginTimer) {
        [self getSMSRequest];
    }
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownExecutingWithTimeOut:) name:kLoginCountDownExecutingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownCompleted) name:kLoginCountDownCompletedNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLoginCountDownExecutingNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLoginCountDownCompletedNotification object:nil];
}

#pragma mark - NSNotification 处理倒计时事件
- (void)loginTimerCountDownExecutingWithTimeOut:(NSNotification *)notification {
    self.countdownBtn.enabled = NO;
    NSInteger timeOut = [notification.object integerValue];
    [self.countdownBtn setTitle: [NSString stringWithFormat:@"重新发送(%ld)",(long)timeOut] forState:(UIControlStateNormal)];
}

- (void)loginTimerCountDownCompleted {
    self.countdownBtn.enabled = YES;
    [self.countdownBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
    [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
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
    self.title = @"账号登录";
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.3*kScreenWidth, 0.1*kScreenWidth, 0.4*kScreenWidth, 0.3*kScreenWidth)];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.scrollView addSubview:logoImageView];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(logoImageView.frame)+0.1*kScreenWidth, 0.8*kScreenWidth, 0.05*kScreenWidth)];
    noticeLabel.text = @"输短信验证码";
    noticeLabel.font = smallMediumFont;
    [self.scrollView addSubview:noticeLabel];
    
    UILabel *noticeDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame), CGRectGetMaxY(noticeLabel.frame), CGRectGetWidth(noticeLabel.frame), CGRectGetHeight(noticeLabel.frame))];
    noticeDetail.text = @"已发送验证码，请输入并进行登录";
    noticeDetail.font = smallFont;
    noticeDetail.textColor = [UIColor grayColor];
    [self.scrollView addSubview:noticeDetail];
    
    self.codeViewText = [[PZXVerificationCodeView alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame)-10, CGRectGetMaxY(noticeDetail.frame)+0.05*kScreenWidth, CGRectGetWidth(noticeDetail.frame)+20, 0.1*kScreenWidth)];
    self.codeViewText.selectedColor = [UIColor clearColor];
    self.codeViewText.deselectColor = [UIColor clearColor];
    self.codeViewText.VerificationCodeNum = 4;
    self.codeViewText.Spacing = 0;//每个格子间距属性
    [self.scrollView addSubview:self.codeViewText];
    
    self.countdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countdownBtn.frame = CGRectMake(0.35*kScreenWidth, CGRectGetMaxY(self.codeViewText.frame), 0.3*kScreenWidth, 0.1*kScreenWidth);
    [self.countdownBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:143/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.countdownBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    self.countdownBtn.titleLabel.font = smallMediumFont;
    [self.countdownBtn addTarget:self action:@selector(countdownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.countdownBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(self.countdownBtn.frame)+0.15*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    nextBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = skinColor;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
    
}

- (void)nextBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    if ((_codeViewText.vertificationCode.length < 4)) {
        [[FFProgressHUD sharedProgressHUD] toastTitle:[NSString stringWithFormat:@"请输入正确验证码"]];
        return;
    }
    [self checkSMSRequest];
}

- (void)countdownBtnClick:(UIButton *)btn {
    [self getSMSRequest];
}

- (void)getSMSRequest {
    if (self.phoneStr&&self.pres) {
        NSDictionary *parametes = @{@"phone":self.phoneStr,
                                    @"type":@"1",
                                    @"pre_phone":[self.pres.pretel substringFromIndex:1],
                                    @"countryName":self.pres.country};
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeVerificationCode parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSlef = weakSelf;
            if (zw_issuccess) {
                strongSlef.countdownBtn.enabled = NO;
                // 创建定时器
                [[SecureCodeTimerManager sharedInstance] timerCountDownWithType:kCountDownTypeLogin];
                [strongSlef showOneItemAlertWithMessage:@"验证码发送成功"];
            }else {
                [strongSlef showOneItemAlertWithMessage:@"验证码发送失败"];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            __strong typeof (weakSelf) strongSlef = weakSelf;
            [strongSlef showOneItemAlertWithMessage:@"验证码发送失败"];
        } showInView:self.view];
    }
}


-(void)checkSMSRequest {
    if (self.phoneStr) {
        NSDictionary *parametes = @{@"phone":self.phoneStr,
                                    @"checkCode":self.codeViewText.vertificationCode};
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwCheckVerificationCode parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) stongSelf = weakSelf;
            if (zw_issuccess) {
                [stongSelf loginSMSRequest];
            } else {
                [stongSelf showOneItemAlertWithMessage:@"验证码验证失败"];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
    
}

-(void)loginSMSRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwVerificationCodeLogin parametes:@{@"phone":self.phoneStr} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSString *str = data[@"msg"];
        if ([str isEqualToString:@"注册成功，请设置新密码"]) {
            [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
            ZWSetPasswordVC *passwordVC = [[ZWSetPasswordVC alloc]init];
            passwordVC.phoneStr = self.phoneStr;
            [strongSelf.navigationController pushViewController:passwordVC animated:YES];
            return;
        }
        if (zw_issuccess) {
            ZWUserInfo *user = [ZWUserInfo ff_convertModelWithJsonDic:data[@"data"]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"user"];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
//    typeof(self) __weak weakSelf = self;
//    ZWLoginSMSRequest *request =[ZWLoginSMSRequest new];
//    request.phone = self.phoneStr;
//
//    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
//        if (respense.isFinished) {
//
//            [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
//            if ([respense.message isEqualToString:@"注册成功，请设置新密码"]) {
//                ZWNewPasswordViewController *vc = [[ZWNewPasswordViewController alloc]init];
//                vc.phoneStr = weakSelf.phoneStr;
//                [weakSelf pushNewViewController:vc];
//            }else{
//                //存储登录信息
//                ZWUserInfo *user = [ZWUserInfo ff_convertModelWithJsonDic:respense.data];
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:data forKey:@"user"];
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//
//        }else{
//            NSLog(@"respense.msg  %@",respense.message);
//        }
//    }];
    
}


- (void)showOneItemAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
