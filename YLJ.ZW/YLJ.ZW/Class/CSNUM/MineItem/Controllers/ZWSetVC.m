//
//  ZWSetVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSetVC.h"
#import "ZWPasswordChangeVC.h"
#import "ZWAboutUsVC.h"
#import "ZWInviteCodeVC.h"
#import "ZWMainLoginVC.h"
#import "ZWShareVC.h"

#import "ZWLogOutRequest.h"
#import "ZWMainTabBarController.h"

#import <JPUSHService.h>

#import "ZWMineSaveSpellListAction.h"

@interface ZWSetVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *titles;

@end

@implementation ZWSetVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-44) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

-(NSArray *)titles {
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"修改密码",@"联系我们",@"关于我们",@"分享此APP",@"当前版本", nil];
    }
    return _titles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"我的uuid：%@",user.uuid);
    NSLog(@"我的userid：%ld",(long)user.userId);
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
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
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
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = normalFont;
    cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    cell.detailTextLabel.font = normalFont;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.12*kScreenWidth-1, 0.95*kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"+86-021-58599908";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
    }else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V %@",app_Version];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.12*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5*kScreenWidth;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tool = [[UIView alloc]init];
    
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.2*kScreenWidth, 0.8*kScreenWidth, 0.12*kScreenWidth)];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = normalFont;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.backgroundColor = skinColor;
    logoutBtn.layer.cornerRadius = 0.06*kScreenWidth;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:logoutBtn];
    return tool;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZWPasswordChangeVC *passwordChangeVC = [[ZWPasswordChangeVC alloc]init];
        passwordChangeVC.title = @"修改密码";
        [self.navigationController pushViewController:passwordChangeVC animated:YES];
    }else if (indexPath.row == 1) {
        NSString *telephoneNumber=@"+86-021-58599908";
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNumber];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:str];
        [application openURL:URL];
    }else if (indexPath.row == 2) {
        ZWAboutUsVC *aboutUsVC = [[ZWAboutUsVC alloc]init];
        aboutUsVC.title = @"关于我们";
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if (indexPath.row == 3) {
        ZWShareVC *shareVC = [[ZWShareVC alloc]init];
        shareVC.title = @"分享";
        [self.navigationController pushViewController:shareVC animated:YES];
    }else if (indexPath.row == 4) {
//        ZWInviteCodeVC *inviteCodeVC = [[ZWInviteCodeVC alloc]init];
//        inviteCodeVC.title = @"填写邀请码";
//        [self.navigationController pushViewController:inviteCodeVC animated:YES];
    }else {
        //站位
    }
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

- (void)logoutBtnClick:(UIButton *)btn {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"" message:@"是否确认退出登陆" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [[ZWMainTabManager sharedManager]zy_didSelectedIndex:0];
//        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//        [strongSelf logOutRequest];
        
        ZWMainTabBarController *tabbar = [[ZWMainTabBarController alloc]init];
        strongSelf.view.window.rootViewController = tabbar;
        [strongSelf logOutRequest];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
    
}
-(void)logOutRequest {
   
    ZWLogOutRequest *request =[ZWLogOutRequest new];
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        
    }];
    //删除本地数据
    [self clearAllUserDefaultsData];
    //删除本地所有拼单数据
    [[ZWMineSaveSpellListAction shareAction]removeAllSpellList];
    
}

- (void)clearAllUserDefaultsData{
    
    [[ZWSaveDataAction shareAction]removeLocation];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user"];
    [defaults synchronize];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
               
    } seq:120];
    
}

@end
