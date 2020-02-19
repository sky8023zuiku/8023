//
//  ZWMyInvitationVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInvitationVC.h"
#import "ZWMyInviteCodeVC.h"
#import "UIViewController+YCPopover.h"
#import "UIImage+ColorGradient.h"

#define navLeftColor [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1]
#define navRightColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]

@interface ZWMyInvitationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ZWMyInvitationVC
-(UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.25*kScreenWidth, kScreenWidth, kScreenHeight-0.3*kScreenWidth-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"邀请" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    ZWMyInviteCodeVC *inviteCodeVC  = [[ZWMyInviteCodeVC alloc]init];
    [self yc_centerPresentController:inviteCodeVC presentedSize:CGSizeMake(0.6*kScreenWidth, 0.7*kScreenWidth) completeHandle:^(BOOL presented) {
        
    }];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *toolImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    toolImage.image = [UIImage gradientColorImageFromColors:@[navLeftColor,navRightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(kScreenWidth, 0.5*kScreenWidth)];
    toolImage.backgroundColor = skinColor;
    [self.view addSubview:toolImage];
    
    UIView *crowdView = [[UIView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.05*kScreenWidth, 0.3*kScreenWidth, 0.15*kScreenWidth)];
    crowdView.backgroundColor = [UIColor whiteColor];
    crowdView.layer.cornerRadius = 5;
    [self.view addSubview:crowdView];
    
    UILabel *crowTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(crowdView.frame), CGRectGetHeight(crowdView.frame)/2)];
    crowTitle.text = @"成员数量";
    crowTitle.textAlignment = NSTextAlignmentCenter;
    crowTitle.font = normalFont;
    [crowdView addSubview:crowTitle];
    
    UILabel *crowNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(crowTitle.frame)-10, CGRectGetWidth(crowdView.frame), CGRectGetHeight(crowdView.frame)/2)];
    crowNumber.text = @"399";
    crowNumber.font = normalFont;
    crowNumber.textAlignment = NSTextAlignmentCenter;
    [crowdView addSubview:crowNumber];
    
    UIView *enterpriseView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(crowdView.frame)+0.2*kScreenWidth, CGRectGetMinY(crowdView.frame), 0.3*kScreenWidth, 0.15*kScreenWidth)];
    enterpriseView.backgroundColor = [UIColor whiteColor];
    enterpriseView.layer.cornerRadius = 5;
    [self.view addSubview:enterpriseView];
    
    UILabel *enterpriseTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(crowdView.frame), CGRectGetHeight(crowdView.frame)/2)];
    enterpriseTitle.text = @"企业数量";
    enterpriseTitle.textAlignment = NSTextAlignmentCenter;
    enterpriseTitle.font = normalFont;
    [enterpriseView addSubview:enterpriseTitle];
    
    UILabel *enterpriseNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(crowTitle.frame)-10, CGRectGetWidth(crowdView.frame), CGRectGetHeight(crowdView.frame)/2)];
    enterpriseNumber.text = @"200";
    enterpriseNumber.font = normalFont;
    enterpriseNumber.textAlignment = NSTextAlignmentCenter;
    [enterpriseView addSubview:enterpriseNumber];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenHeight-1, kScreenWidth, 1)];
    lineView.backgroundColor = zwGrayColor;
    [cell.contentView addSubview:lineView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.1*kScreenHeight;
}

@end
