//
//  ZWAddBusinessCardVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/22.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWAddBusinessCardVC.h"
#import <TPKeyboardAvoidingTableView.h>
#define kMaxLableLength 20
@interface ZWAddBusinessCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingTableView *tableView;
@end

@implementation ZWAddBusinessCardVC

-(TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0, 0);
        _tableView.separatorColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

-(ZWBusinessCardModel *)cardModel {
    if (!_cardModel) {
        _cardModel = [[ZWBusinessCardModel alloc]init];
    }
    return _cardModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createNotice];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"完成" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)createNotice {

}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    if (self.cardModel.contacts.length == 0) {
        [self showAlertWithMessage:@"名称不能为空"];
        return;
    }
    if (self.cardModel.phone.length == 0) {
        [self showAlertWithMessage:@"电话号码不能为空"];
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
    
    NSDictionary *parametes = [[ZWModelToolAction shareAction]dicFromObject:self.cardModel];
    if (parametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwAddBusinessCard parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBusinessCardData" object:nil];
                [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"名片上传成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                } showInView:self];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
       
}

- (void)createUI {
    self.title = @"添加名片";
    self.view.backgroundColor = zwGrayColor;
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *titleArray = @[@"姓名：",@"电话号码：",@"邮箱：",@"所在公司：",@"职称：",@"QQ：",@"地址：",@"需求："];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.2*kScreenWidth, 0.12*kScreenWidth)];
    myLabel.font = normalFont;
    myLabel.text = titleArray[indexPath.row];
    myLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:myLabel textAlignmentWith:CGRectGetWidth(myLabel.frame)];
    [cell.contentView addSubview:myLabel];
    
    NSArray *placeholderArray = @[@"请点击输入您的名称（必填）",@"请点击输入您的电话号码（必填）",@"请点击输入您的邮箱",@"请点击输入您所在的公司名称",@"请点击输入您的职称",@"请点击输入您的QQ号码",@"请点击输入您的地址",@"请点击输入您的需求(限20字)"];
    UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myLabel.frame), 0, 0.94*kScreenWidth, CGRectGetHeight(myLabel.frame))];
    valueText.font = normalFont;
    valueText.tag = indexPath.row;
    if (indexPath.row == 0) {
        valueText.text = self.cardModel.contacts;
    }else if (indexPath.row == 1) {
        valueText.text = self.cardModel.phone;
    }else if (indexPath.row == 2) {
        valueText.text = self.cardModel.mail;
    }else if (indexPath.row == 3) {
        valueText.text = self.cardModel.merchantName;
    }else if (indexPath.row == 4) {
        valueText.text = self.cardModel.post;
    }else if (indexPath.row == 5) {
        valueText.text = self.cardModel.qq;
    }else if (indexPath.row == 6) {
        valueText.text = self.cardModel.address;
    }else {
        valueText.text = self.cardModel.requirement;
    }
    valueText.placeholder = placeholderArray[indexPath.row];
    [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
    valueText.delegate = self;
    [cell.contentView addSubview:valueText];
    
}

- (void)valueText:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag == 0) {
        self.cardModel.contacts = textField.text;
    }else if (textField.tag == 1) {
        self.cardModel.phone = textField.text;
    }else if (textField.tag == 2) {
        self.cardModel.mail = textField.text;
    }else if (textField.tag == 3) {
        self.cardModel.merchantName = textField.text;
    }else if (textField.tag == 4) {
        self.cardModel.post = textField.text;
    }else if (textField.tag == 5) {
        self.cardModel.qq = textField.text;
    }else if (textField.tag == 6) {
        self.cardModel.address = textField.text;
    }else {
        self.cardModel.requirement = textField.text;
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length + string.length > 30) {
        return NO;
    }
    if (textField.text.length < range.location + range.length) {
        return NO;
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.12*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


- (void)validationText:(UITextField *)textField
{
    NSString *realString = [textField.text substringWithRange:NSMakeRange(0, 30)];
    if (realString.length >= 30){
        textField.text = [realString substringWithRange:NSMakeRange(0, 30)];
    }
}




@end
