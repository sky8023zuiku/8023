//
//  ZWDeliverMessageVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDeliverMessageVC.h"
#import "ZWTextView.h"
#import <TPKeyboardAvoidingScrollView.h>
@interface ZWDeliverMessageVC ()<UITextViewDelegate>

@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)ZWTextView *instructions;
@property(nonatomic, strong)UITextField *nameText;
@property(nonatomic, strong)UITextField *phoneText;
@property(nonatomic, strong)UITextField *mailText;
@property(nonatomic, strong)UITextField *wechatText;
@property(nonatomic, strong)UITextField *companyText;
@property(nonatomic, strong)UITextField *addressText;

@end

@implementation ZWDeliverMessageVC

- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight)];
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 1.18*kScreenWidth+100);
    _scrollView.backgroundColor = [UIColor clearColor];
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
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓名： ";
    nameLabel.font = normalFont;
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 0.08*kScreenWidth)];
    self.nameText.placeholder = @"点击输入姓名";
    self.nameText.leftView = nameLabel;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    self.nameText.font = normalFont;
    [self.scrollView addSubview:self.nameText];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nameText.frame), CGRectGetMaxY(self.nameText.frame), CGRectGetWidth(self.nameText.frame), 1)];
    lineOne.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [self.scrollView addSubview:lineOne];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"电话： ";
    phoneLabel.font = normalFont;
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineOne.frame), CGRectGetMaxY(lineOne.frame)+15, CGRectGetWidth(lineOne.frame), CGRectGetHeight(self.nameText.frame))];
    self.phoneText.placeholder = @"点击输入电话号码";
    self.phoneText.leftView = phoneLabel;
    self.phoneText.leftViewMode = UITextFieldViewModeAlways;
    self.phoneText.font = normalFont;
    [self.scrollView addSubview:self.phoneText];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.phoneText.frame), CGRectGetMaxY(self.phoneText.frame), CGRectGetWidth(self.phoneText.frame), 1)];
    lineTwo.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [self.scrollView addSubview:lineTwo];
    
//    UILabel *mailLabel = [[UILabel alloc]init];
//    mailLabel.text = @"邮箱： ";
//    mailLabel.font = normalFont;
//    self.mailText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineTwo.frame), CGRectGetMaxY(lineTwo.frame)+15, CGRectGetWidth(lineTwo.frame), CGRectGetHeight(self.nameText.frame))];
//    self.mailText.placeholder = @"点击输入邮箱";
//    self.mailText.leftView = mailLabel;
//    self.mailText.leftViewMode = UITextFieldViewModeAlways;
//    self.mailText.font = normalFont;
//    [self.scrollView addSubview:self.mailText];
    
//    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.mailText.frame), CGRectGetMaxY(self.mailText.frame), CGRectGetWidth(self.mailText.frame), 1)];
//    lineThree.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
//    [self.scrollView addSubview:lineThree];
    
//    UILabel *wechatLabel = [[UILabel alloc]init];
//    wechatLabel.text = @"微信： ";
//    wechatLabel.font = normalFont;
//    self.wechatText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineThree.frame), CGRectGetMaxY(lineThree.frame)+15, CGRectGetWidth(lineThree.frame), CGRectGetHeight(self.nameText.frame))];
//    self.wechatText.placeholder = @"点击输入微信账号";
//    self.wechatText.leftView = wechatLabel;
//    self.wechatText.leftViewMode = UITextFieldViewModeAlways;
//    self.wechatText.font = normalFont;
//    [self.scrollView addSubview:self.wechatText];
    
//    UIView *lineFour = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.wechatText.frame), CGRectGetMaxY(self.wechatText.frame), CGRectGetWidth(self.wechatText.frame), 1)];
//    lineFour.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
//    [self.scrollView addSubview:lineFour];
    
    UILabel *companyLabel = [[UILabel alloc]init];
    companyLabel.text = @"公司： ";
    companyLabel.font = normalFont;
    self.companyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineTwo.frame), CGRectGetMaxY(lineTwo.frame)+15, CGRectGetWidth(lineTwo.frame), CGRectGetHeight(self.nameText.frame))];
    self.companyText.placeholder = @"点击输入公司名称";
    self.companyText.leftView = companyLabel;
    self.companyText.leftViewMode = UITextFieldViewModeAlways;
    self.companyText.font = normalFont;
    [self.scrollView addSubview:self.companyText];
    
//    UIView *lineFive = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyText.frame), CGRectGetMaxY(self.companyText.frame), CGRectGetWidth(self.companyText.frame), 1)];
//    lineFive.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
//    [self.scrollView addSubview:lineFive];
    
//    UILabel *addressLabel = [[UILabel alloc]init];
//    addressLabel.text = @"地址： ";
//    addressLabel.font = normalFont;
//    self.addressText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lineFive.frame), CGRectGetMaxY(lineFive.frame)+15, CGRectGetWidth(lineFive.frame), CGRectGetHeight(self.nameText.frame))];
//    self.addressText.placeholder = @"点击输入公司地址";
//    self.addressText.leftView = addressLabel;
//    self.addressText.leftViewMode = UITextFieldViewModeAlways;
//    self.addressText.font = normalFont;
//    [self.scrollView addSubview:self.addressText];
    
    UIView *lineSix = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.companyText.frame), CGRectGetMaxY(self.companyText.frame), CGRectGetWidth(self.companyText.frame), 1)];
    lineSix.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [self.scrollView addSubview:lineSix];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineSix.frame)+15, 0.12*kScreenWidth, 0.08*kScreenWidth)];
    detailLabel.text = @"说明： ";
    detailLabel.font = normalFont;
    [self.scrollView addSubview:detailLabel];
    
    self.instructions = [[ZWTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(detailLabel.frame), CGRectGetMinY(detailLabel.frame), 0.88*kScreenWidth-30, 0.5*kScreenWidth)];
    self.instructions.placeHolderLabel.text = @"请输入来意";
    self.instructions.font = normalFont;
    self.instructions.delegate = self;
    [self.scrollView addSubview:self.instructions];
    
    UIButton *submitMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    submitMessage.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(self.instructions.frame)+0.1*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    submitMessage.backgroundColor = skinColor;
    [submitMessage setTitle:@"确认投递" forState:UIControlStateNormal];
    submitMessage.titleLabel.font = normalFont;
    submitMessage.layer.cornerRadius = 10;
    submitMessage.layer.masksToBounds = YES;
    [submitMessage addTarget:self action:@selector(submitMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitMessage];
}

- (BOOL)textView:(ZWTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text == nil||[textView.text isEqualToString:@""]) {
        self.instructions.placeHolderLabel.text = @"请输入来意";
    }else {
        self.instructions.placeHolderLabel.text = @"";
    }
    return YES;
}

- (void)submitMessageClick:(UIButton *)btn {
    if ([self.nameText.text isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"姓名不能为空"];
        return;
    }
    if ([self.phoneText.text isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"电话号码不能为空"];
        return;
    }
//    if ([self.mailText.text isEqualToString:@""]) {
//        [self showOneAlertWithMessage:@"邮箱不能为空"];
//        return;
//    }
//    if ([self.wechatText.text isEqualToString:@""]) {
//        [self showOneAlertWithMessage:@"微信不能为空"];
//        return;
//    }
//    if ([self.companyText.text isEqualToString:@""]) {
//        [self showOneAlertWithMessage:@"公司名称不能为空"];
//        return;
//    }
//    if ([self.addressText.text isEqualToString:@""]) {
//        [self showOneAlertWithMessage:@"公司地址不能为空"];
//        return;
//    }
    if ([self.instructions.text isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"请填写来意"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf submitData];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}

- (void)submitData {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwDeliverMessage parametes:[self takeParametes] successBlock:^(NSDictionary * _Nonnull data) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [strongSelf showOneAlertWithMessage:@"投递成功"];
        }else {
            [strongSelf showOneAlertWithMessage:@"投递失败，请检查网络或稍后再试"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}

- (NSDictionary *)takeParametes {
    NSDictionary *parametes;
    if (self.merchantId) {
        parametes = @{@"name":self.nameText.text,
                      @"phone":self.phoneText.text,
//                      @"email":self.mailText.text,
//                      @"wechart":self.wechatText.text,
                      @"company":self.companyText.text,
//                      @"address":self.addressText.text,
                      @"demand":self.instructions.text,
                      @"merchantId":self.merchantId};
    }
    return parametes;
}


- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
