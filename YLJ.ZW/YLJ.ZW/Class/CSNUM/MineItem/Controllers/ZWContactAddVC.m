//
//  ZWContactAddVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWContactAddVC.h"
#import "ZWMineRqust.h"

@interface ZWContactAddVC ()
@property(nonatomic, strong)UIScrollView *zwScrollView;
@property(nonatomic, strong)UITextField *nameText;
@property(nonatomic, strong)UITextField *positionText;
@property(nonatomic, strong)UITextField *phoneText;
@property(nonatomic, strong)UITextField *telText;
@property(nonatomic, strong)UITextField *weChatText;
@property(nonatomic, strong)UITextField *emailText;
@end

@implementation ZWContactAddVC
-(UIScrollView *)zwScrollView {
    if (!_zwScrollView) {
        _zwScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, kScreenHeight)];
    }
    return _zwScrollView;
}
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
    [self.view addSubview:self.zwScrollView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    nameLabel.text = @"姓名：";
    nameLabel.font = normalFont;
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.zwScrollView.frame)/2, 0.12*kScreenWidth)];
    self.nameText.leftView = nameLabel;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    self.nameText.placeholder = @"联系人姓名";
    self.nameText.font = normalFont;
    [self.zwScrollView addSubview:self.nameText];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    positionLabel.text = @"职务：";
    positionLabel.font = normalFont;
    self.positionText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameText.frame), 0, CGRectGetWidth(self.nameText.frame), 0.12*kScreenWidth)];
    self.positionText.leftView = positionLabel;
    self.positionText.leftViewMode = UITextFieldViewModeAlways;
    self.positionText.placeholder = @"联系人职务";
    self.positionText.font = normalFont;
    [self.zwScrollView addSubview:self.positionText];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameText.frame), CGRectGetWidth(self.zwScrollView.frame), 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.zwScrollView addSubview:lineOne];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    phoneLabel.text = @"手机：";
    phoneLabel.font = normalFont;
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineOne.frame), CGRectGetWidth(self.nameText.frame), 0.12*kScreenWidth)];
    self.phoneText.leftView = phoneLabel;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.placeholder = @"联系人手机号码";
    self.phoneText.font = normalFont;
    [self.zwScrollView addSubview:self.phoneText];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    telLabel.text = @"电话：";
    telLabel.font = normalFont;
    self.telText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneText.frame), CGRectGetMinY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 0.12*kScreenWidth)];
    self.telText.leftView = telLabel;
    self.telText.leftViewMode = UITextFieldViewModeAlways;
    self.telText.placeholder = @"联系人座机号码";
    self.telText.font = normalFont;
    [self.zwScrollView addSubview:self.telText];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.zwScrollView.frame), 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.zwScrollView addSubview:lineTwo];
    
    UILabel *weChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    weChatLabel.text = @"微信：";
    weChatLabel.font = normalFont;
    self.weChatText = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineTwo.frame), CGRectGetWidth(self.nameText.frame), 0.12*kScreenWidth)];
    self.weChatText.leftView = weChatLabel;
    self.weChatText.leftViewMode = UITextFieldViewModeAlways;
    self.weChatText.placeholder = @"联系人微信号码";
    self.weChatText.font = normalFont;
    [self.zwScrollView addSubview:self.weChatText];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.12*kScreenWidth, 0.12*kScreenWidth)];
    emailLabel.text = @"邮箱：";
    emailLabel.font = normalFont;
    self.emailText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.weChatText.frame), CGRectGetMinY(self.weChatText.frame), CGRectGetWidth(self.weChatText.frame), 0.12*kScreenWidth)];
    self.emailText.leftView = emailLabel;
    self.emailText.leftViewMode = UITextFieldViewModeAlways;
    self.emailText.placeholder = @"联系人邮箱";
    self.emailText.font = normalFont;
    [self.zwScrollView addSubview:self.emailText];
    
    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weChatText.frame), CGRectGetWidth(self.zwScrollView.frame), 1)];
    lineThree.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [self.zwScrollView addSubview:lineThree];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(lineThree.frame)+0.15*kScreenWidth, 0.8*kScreenWidth-30, 0.12*kScreenWidth);
    submitBtn.backgroundColor = skinColor;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 0.06*kScreenWidth;
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.masksToBounds = YES;
    [self.zwScrollView addSubview:submitBtn];
    
}
- (void)submitBtnClick:(UIButton *)btn {
    
    if ([self.nameText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"联系人姓名不能为空"];
        return;
    }
    
    if ([self.positionText.text isEqualToString:@""]) {
        [self showOneAlertWithTitle:@"联系人职务不能为空"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf uploadData];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}
- (void)uploadData {
    ZWContactAddRequest *request = [[ZWContactAddRequest alloc]init];
    request.contacts = self.nameText.text;
    request.post = self.positionText.text;
    request.phone = self.phoneText.text;
    request.telephone = self.telText.text;
    request.qq = self.weChatText.text;
    request.mail = self.emailText.text;
    request.exhibitorId = self.exhibitorId;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshContactList" object:nil];
            [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"联系人添加成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf.navigationController popViewControllerAnimated:YES];
            } showInView:self];
        }
    }];
}

-(void)showOneAlertWithTitle:(NSString *)title {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:title confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
