//
//  ZWMyShareBindAlertVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareBindAlertVC.h"

@interface ZWMyShareBindAlertVC ()
@property(nonatomic, assign)NSInteger number;
@property(nonatomic, strong)UITextField *numText;
@end

@implementation ZWMyShareBindAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    
    self.number = 0;
    NSLog(@"我的分享次数%@",self.shareCodeNum);
        
    UILabel *titelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 0.7*kScreenWidth-20, 0.1*kScreenWidth)];
    titelLabel.text = [NSString stringWithFormat:@"您将要绑定分享码至%@",self.exhibitionName];
    titelLabel.numberOfLines = 2;
    titelLabel.font = smallMediumFont;
    [self.view addSubview:titelLabel];
    
    UIView *leftTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.06*kScreenWidth, 0.06*kScreenWidth)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"-" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, leftTool.bounds.size.width-1, leftTool.bounds.size.height);
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftTool addSubview:leftBtn];
    [self setBorderWithView:leftBtn top:NO left:NO bottom:NO right:YES borderColor:skinColor borderWidth:1];
    
    UIView *rightTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.06*kScreenWidth, 0.06*kScreenWidth)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(1, 0, rightTool.bounds.size.width-1, rightTool.bounds.size.height);
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightTool addSubview:rightBtn];
    [self setBorderWithView:rightBtn top:NO left:YES bottom:NO right:NO borderColor:skinColor borderWidth:1];
    
    self.numText = [[UITextField alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, CGRectGetMaxY(titelLabel.frame)+0.05*kScreenWidth, 0.25*kScreenWidth, 0.06*kScreenWidth)];
    self.numText.layer.borderColor = skinColor.CGColor;
    self.numText.layer.borderWidth = 1;
    self.numText.placeholder = @"10";
    self.numText.text = [NSString stringWithFormat:@"%ld",self.number];
    self.numText.textAlignment = NSTextAlignmentCenter;
    self.numText.font = smallMediumFont;
    self.numText.layer.masksToBounds = YES;
    self.numText.leftView = leftTool;
    self.numText.leftViewMode = UITextFieldViewModeAlways;
    self.numText.rightView = rightTool;
    self.numText.rightViewMode = UITextFieldViewModeAlways;
    [self.numText addTarget:self action:@selector(textFieldValue:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.numText];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numText.frame)+5, CGRectGetMinY(self.numText.frame), 0.2*kScreenWidth, CGRectGetHeight(self.numText.frame))];
    unitLabel.text = @"个分享码";
    unitLabel.font = smallMediumFont;
    [self.view addSubview:unitLabel];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(unitLabel.frame)+0.05*kScreenWidth, 0.6*kScreenWidth, 0.08*kScreenWidth);
    confirmBtn.backgroundColor = skinColor;
    [confirmBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = smallMediumFont;
    confirmBtn.layer.cornerRadius = 0.04*kScreenWidth;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(confirmBtn.frame)+0.03*kScreenWidth, 0.6*kScreenWidth, 0.08*kScreenWidth);
    cancelBtn.layer.borderColor = skinColor.CGColor;
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:skinColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = smallMediumFont;
    cancelBtn.layer.cornerRadius = 0.04*kScreenWidth;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

}

- (void)leftBtnClick:(UIButton *)btn {
    if (self.number >= 10) {
        self.number -= 10;
        self.numText.text = [NSString stringWithFormat:@"%ld",(long)self.number];
    }
}
- (void)rightBtnClick:(UIButton *)btn {
    if (self.number < [self.shareCodeNum integerValue]) {
        if (([self.shareCodeNum integerValue]-self.number)>=10) {
            self.number += 10;
        }else {
            NSInteger a = [self.shareCodeNum integerValue]%10;
            self.number += a;
        }
    }
    self.numText.text = [NSString stringWithFormat:@"%ld",(long)self.number];
}

- (void)textFieldValue:(UITextField *)text {
    NSInteger textNum = [text.text integerValue];
    if (textNum > [self.shareCodeNum integerValue]) {
        self.number = [self.shareCodeNum integerValue];
        self.numText.text = [NSString stringWithFormat:@"%@",self.shareCodeNum];
    }else {
        self.number = [text.text integerValue];
    }
}

- (void)confirmBtnClick:(UIButton *)btn {
    [self bindingSareCode];
}

- (void)cancelBtnClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

- (void)bindingSareCode {
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction] showTwoAlertTitle:@"提示" message:@"是否确认绑定" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        [[ZWDataAction sharedAction]postReqeustWithURL:zwBindShareCodeWithExhibition parametes:@{@"bindAmount":[NSString stringWithFormat:@"%ld",(long)self.number],@"exhibitionId":self.exhibitionId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheBindList" object:nil];
            }else {
                [strongSelf showOneAlertWithMessage:@"绑定失败，请稍后再试或联系客服"];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
