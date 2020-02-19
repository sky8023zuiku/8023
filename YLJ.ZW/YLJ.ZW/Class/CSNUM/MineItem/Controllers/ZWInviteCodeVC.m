//
//  ZWInviteCodeVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWInviteCodeVC.h"
#import "ZWMineRqust.h"

@interface ZWInviteCodeVC ()
@property(nonatomic, strong)UITextField *inviteCodeText;
@property(nonatomic, strong)UITextField *userText;
@end

@implementation ZWInviteCodeVC

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
    
    
    //**邀请码**/
    UIView *inviteCodeLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UIImageView *inviteCodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.075*kScreenWidth-CGRectGetHeight(inviteCodeLeftView.frame)/3, 0.05*kScreenWidth-CGRectGetHeight(inviteCodeLeftView.frame)/3, CGRectGetHeight(inviteCodeLeftView.frame)/3*2, CGRectGetHeight(inviteCodeLeftView.frame)/3*2)];
    inviteCodeImage.image = [UIImage imageNamed:@"ren_she_icon_yao"];
    [inviteCodeLeftView addSubview:inviteCodeImage];
    
    self.inviteCodeText = [[UITextField alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth)];
    self.inviteCodeText.leftView = inviteCodeLeftView;
    self.inviteCodeText.leftViewMode = UITextFieldViewModeAlways;
    self.inviteCodeText.placeholder = @"请输入推荐人的手机号码";
    self.inviteCodeText.font = normalFont;
    [self.view addSubview:self.inviteCodeText];
    
    UIView *lineV01 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.inviteCodeText.frame), CGRectGetMaxY(self.inviteCodeText.frame), CGRectGetWidth(self.inviteCodeText.frame), 1)];
    lineV01.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:lineV01];
    
    /**推荐人**/
    UIView *refereesLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    
    UIImageView *refereesImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.075*kScreenWidth-CGRectGetHeight(refereesLeftView.frame)/3, 0.05*kScreenWidth-CGRectGetHeight(refereesLeftView.frame)/3, CGRectGetHeight(refereesLeftView.frame)/3*2, CGRectGetHeight(refereesLeftView.frame)/3*2)];
    refereesImage.image = [UIImage imageNamed:@"ren_she_icon_tui"];
    [refereesLeftView addSubview:refereesImage];
    
    self.userText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.inviteCodeText.frame), CGRectGetMaxY(self.inviteCodeText.frame)+20, CGRectGetWidth(self.inviteCodeText.frame), CGRectGetHeight(self.inviteCodeText.frame))];
    self.userText.leftView = refereesLeftView;
    self.userText.leftViewMode = UITextFieldViewModeAlways;
    self.userText.placeholder = @"推荐人用户名";
    self.userText.font = normalFont;
    [self.view addSubview:self.userText];
    
    UIView *lineV02 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userText.frame), CGRectGetMaxY(self.userText.frame), CGRectGetWidth(self.userText.frame), 1)];
    lineV02.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:lineV02];
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(CGRectGetMinX(self.userText.frame), CGRectGetMaxY(self.userText.frame)+0.2*kScreenWidth, CGRectGetWidth(self.userText.frame), 0.1*kScreenWidth);
    submitBtn.backgroundColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
    submitBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = normalFont;
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}
- (void)submitBtnClick:(UIButton *)btn {
    if ([self.inviteCodeText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"邀请码不能为空"];
        return;
    }
    if ([self.userText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"用户名不能为空"];
        return;
    }
    ZWInvitationCodeRequest *request = [[ZWInvitationCodeRequest alloc]init];
    request.recommend = self.inviteCodeText.text;
    request.userName = self.userText.text;
    
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        NSLog(@"%@",respense.data);
        if (respense.isFinished) {
            [self showOneAlertWithTitle:@"邀请码设置成功"];
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

@end
