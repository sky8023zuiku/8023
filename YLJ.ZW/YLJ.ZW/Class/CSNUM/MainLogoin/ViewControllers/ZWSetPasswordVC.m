//
//  ZWSetPasswordVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSetPasswordVC.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ZWSetPasswordVC ()<UITextFieldDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic, strong)UITextField *passText;
@end

@implementation ZWSetPasswordVC

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
    noticeLabel.text = @"请设置登陆密码";
    noticeLabel.font = smallMediumFont;
    [self.scrollView addSubview:noticeLabel];
    
    UILabel *noticeDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeLabel.frame), CGRectGetMaxY(noticeLabel.frame), CGRectGetWidth(noticeLabel.frame), CGRectGetHeight(noticeLabel.frame))];
    noticeDetail.text = @"初次登陆请设置密码";
    noticeDetail.font = smallFont;
    noticeDetail.textColor = [UIColor grayColor];
    [self.scrollView addSubview:noticeDetail];
    
    UIView *leftTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
    UIImageView *passImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
    passImage.image = [UIImage imageNamed:@"ren_zi_icon_mi"];
    [leftTwo addSubview:passImage];
    
    self.passText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(noticeDetail.frame), CGRectGetMaxY(noticeDetail.frame)+0.05*kScreenWidth, CGRectGetWidth(noticeDetail.frame), 0.1*kScreenWidth)];
    self.passText.placeholder = @"请设置密码（长度6到18位）";
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
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0.1*kScreenWidth, CGRectGetMaxY(lineTwo.frame)+0.2*kScreenWidth, 0.8*kScreenWidth, 0.1*kScreenWidth);
    nextBtn.layer.cornerRadius = 0.05*kScreenWidth;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = skinColor;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
       
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
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


- (void)nextBtnClick:(UIButton *)btn {
    if (self.passText.text.length < 8) {
        [self showOneAlertWithMessage:@"密码需在8到16位之间"];
        return;
    }
    [self registerSMSRequest];
}


-(void)registerSMSRequest {
    
    if (self.phoneStr) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwRegister parametes:@{@"phone":self.phoneStr,@"password":self.passText.text} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                //存储登录信息
                ZWUserInfo *user = [ZWUserInfo ff_convertModelWithJsonDic:data[@"data"]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:data forKey:@"user"];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"requestUserInfo" object:nil];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
    
}


- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
