//
//  ZWMyIndustriesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyIndustriesVC.h"
#import "ZWMyInvolveIndustesVC.h"
#import "ZWMyExhibitionIndustriesVC.h"
#import "ZWMyInterestIndustriesVC.h"
#import "ZWSelectCertificationVC.h"

@interface ZWMyIndustriesVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ZWMyIndustriesVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    return _tableView;
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
    self.view.backgroundColor = zwGrayColor;
    
    NSLog(@"------%@",self.roleId);
    
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    NSArray *titles = @[@"我感兴趣的行业",@"我涉及的行业",@"我查看的行业（展会）"];
    NSArray *detailTexts = @[@"观众、展商、会展服务商",@"展商、会展服务商",@"展商vip"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = normalFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = detailTexts[indexPath.row];
    cell.detailTextLabel.font = smallMediumFont;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.1*kScreenHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        ZWMyInterestIndustriesVC *industriesVC = [[ZWMyInterestIndustriesVC alloc]init];
        [self.navigationController pushViewController:industriesVC animated:YES];
        
    }else if (indexPath.row == 1) {
        if ([self.roleId integerValue] == 1||[self.roleId integerValue] == 12||[self.roleId integerValue] == 13) {
            __weak typeof (self) weakSelf = self;
            [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"您还不是未认证企业，是否前去认证？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf goToTheCertification];
            } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
                
            } showInView:self];
        } else {
            ZWMyInvolveIndustesVC *industesVC = [[ZWMyInvolveIndustesVC alloc]init];
            industesVC.title = @"我涉及的行业";
            industesVC.roleId = self.roleId;
            [self.navigationController pushViewController:industesVC animated:YES];
        }
    }else {
        if ([self.roleId integerValue] == 3) {
            ZWMyExhibitionIndustriesVC *industesVC = [[ZWMyExhibitionIndustriesVC alloc]init];
            industesVC.title = @"展会行业";
            [self.navigationController pushViewController:industesVC animated:YES];
        } else if ([self.roleId integerValue] == 4) {
            [self showOneAlertWithMessage:@"尊敬的展商svip，您已经可以查看所有在线展会的信息了，所以无需设置能查看的展会行业"];
        } else {
            [self showOneAlertWithMessage:@"抱歉，该功能只对展商vip开放"];
        }
    }
}
- (void)goToTheCertification {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCompanyCertification parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            ZWSelectCertificationVC *selectVC = [[ZWSelectCertificationVC alloc]init];
            selectVC.title = @"选择企业类型";
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.authenticationStatus = [myData[@"authenticationStatus"] integerValue];
            selectVC.identityId = [myData[@"identityId"] integerValue];
            [strongSelf.navigationController pushViewController:selectVC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
