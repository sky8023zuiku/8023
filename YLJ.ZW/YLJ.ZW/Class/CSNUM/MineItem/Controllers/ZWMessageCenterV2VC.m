//
//  ZWMessageCenterV2VC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageCenterV2VC.h"
#import "ZWMessageSystemVC.h"
#import "ZWMessageActivitiesVC.h"
#import "ZWMessageCardVC.h"
@interface ZWMessageCenterV2VC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ZWMessageCenterV2VC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0,0.05*kScreenWidth, 0, 0);
    [_tableView setSeparatorColor:zwDarkGrayColor];
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
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *titleArray = @[@"系统通知",@"活动消息",@"名片投递",@"反馈回复"];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = boldNormalFont;
    return cell;
    
}

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
    
    if (indexPath.row == 0) {
        ZWMessageSystemVC *messageSystemVC = [[ZWMessageSystemVC alloc]init];
        messageSystemVC.title = @"系统通知";
        [self.navigationController pushViewController:messageSystemVC animated:YES];
    }else if (indexPath.row == 1) {
        ZWMessageActivitiesVC *messageActivitiesVC = [[ZWMessageActivitiesVC alloc]init];
        messageActivitiesVC.title = @"活动通知";
        [self.navigationController pushViewController:messageActivitiesVC animated:YES];
    }else if (indexPath.row == 2) {
        ZWMessageCardVC *messageCardVC = [[ZWMessageCardVC alloc]init];
        messageCardVC.title = @"名片收集";
        [self.navigationController pushViewController:messageCardVC animated:YES];
    }else {
        
    }
}

@end
