//
//  ZWSelectCertificationVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/31.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSelectCertificationVC.h"
#import "ZWEditCompanyInfoVC.h"
#import "ZWCertEnterpriseInfoVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"

@interface ZWSelectCertificationVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSString *demandID;//记录变更认证方式的id

@end

@implementation ZWSelectCertificationVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createNotice];
}

- (void)createNotice {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTheCertification:) name:@"refreshTheCertification" object:nil];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshTheCertification" object:nil];
    
}

- (void)refreshTheCertification:(NSNotification *)notice {
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCompanyCertification parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            strongSelf.authenticationStatus = [myData[@"authenticationStatus"] integerValue];
            strongSelf.identityId = [myData[@"identityId"] integerValue];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titles = @[@"展商",@"会展服务商"];
    
    NSArray *details = @[@"产品，展示",@"服务，道具，设计，搭建"];
    
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = normalFont;
    cell.detailTextLabel.text = details[indexPath.row];
    cell.detailTextLabel.font = smallFont;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == self.identityId-2) {
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.7*kScreenWidth, 0.075*kScreenWidth, 0.2*kScreenWidth, 0.05*kScreenWidth)];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.layer.cornerRadius = 0.025*kScreenWidth;
        tagLabel.layer.masksToBounds = YES;
        if (self.authenticationStatus == 0) {
            tagLabel.text = @"";
            tagLabel.backgroundColor = [UIColor whiteColor];
        }else if (self.authenticationStatus == 1) {
            tagLabel.text = @"审核中";
            tagLabel.backgroundColor = [UIColor lightGrayColor];
            tagLabel.textColor = zwGrayColor;
        }else if (self.authenticationStatus == 2) {
            tagLabel.text = @"已通过";
            tagLabel.backgroundColor = skinColor;
            tagLabel.textColor = [UIColor whiteColor];
        }else {
            tagLabel.text = @"审核失败";
            tagLabel.backgroundColor = [UIColor redColor];
            tagLabel.textColor = [UIColor whiteColor];
        }
        tagLabel.font = smallMediumFont;
        [cell.contentView addSubview:tagLabel];
    }
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.2*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str;
    if (indexPath.row == 0) {
        str = @"展商";
        self.demandID = @"2";
    }else {
        str = @"会展服务商";
        self.demandID = @"3";
    }
    if (self.authenticationStatus == 1) {
        [self showOneAlertWithMessage:@"您提交的认证信息正在审核中，请耐心等待"];
    }else if (self.authenticationStatus == 2) {
        if (indexPath.row !=self.identityId-2) {
            if (self.identityId == 1) {
                
            }else if (self.identityId == 2) {
                [self showOneAlertWithMessage:[NSString stringWithFormat:@"您的展商认证已通过审核，不能再认证%@信息",str]];
            }else {
                [self showOneAlertWithMessage:[NSString stringWithFormat:@"您的会展服务商认证已通过审核，不能再认证%@信息",str]];
            }
        }else {
            [self showOneAlertWithMessage:[NSString stringWithFormat:@"您的%@认证已通过审核，无需再次提交",str]];
        }
    }else if (self.authenticationStatus == 3) {
        if (indexPath.row !=self.identityId-2) {
            if (self.identityId == 1) {
                
            }else if (self.identityId == 2) {
                [self showTwoAlertWithMessage:[NSString stringWithFormat:@"您之前提交的是展商审核资料，是否确认变更为%@",str]];
            }else {
                [self showTwoAlertWithMessage:[NSString stringWithFormat:@"您之前提交的是服务商审核资料，是否确认变更为%@",str]];
            }
        }else {
            [self gotoCertification:1];
        }
    }else {
        ZWCertEnterpriseInfoVC *enterpriseInfoVC = [[ZWCertEnterpriseInfoVC alloc]init];
        enterpriseInfoVC.title = @"编辑企业信息";
        if (indexPath.row == 0) {
            enterpriseInfoVC.identityId = @"2";
        }else {
            enterpriseInfoVC.identityId = @"3";
        }
        [self.navigationController pushViewController:enterpriseInfoVC animated:YES];
    }  
}

-(void)showTwoAlertWithMessage:(NSString *)message {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"温馨提示" message:message cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf gotoCertification:2];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}

- (void)gotoCertification:(NSInteger )type {
    if (type == 1) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwAuthenticationFailedInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                ZWAuthenticationModel *model = [ZWAuthenticationModel parseJSON:data[@"data"]];
                ZWCertEnterpriseInfoVC *enterpriseInfoVC = [[ZWCertEnterpriseInfoVC alloc]init];
                enterpriseInfoVC.title = @"编辑企业信息";
                enterpriseInfoVC.merchantStatus = self.authenticationStatus;
                enterpriseInfoVC.identityId = self.demandID;
                enterpriseInfoVC.model = model;
                [strongSelf.navigationController pushViewController:enterpriseInfoVC animated:YES];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
        
    }else {
        NSLog(@"%@",self.demandID);
        ZWCertEnterpriseInfoVC *enterpriseInfoVC = [[ZWCertEnterpriseInfoVC alloc]init];
        enterpriseInfoVC.title = @"编辑企业信息";
        enterpriseInfoVC.identityId = self.demandID;
        [self.navigationController pushViewController:enterpriseInfoVC animated:YES];
    }
}

-(void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"温馨提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
