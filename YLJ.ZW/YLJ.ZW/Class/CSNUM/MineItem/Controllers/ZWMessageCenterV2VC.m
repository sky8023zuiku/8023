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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tableView) {
        [self.tableView reloadData];
    }
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
    return 3;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *titleArray = @[@"审核通知",@"系统通知",@"名片投递"];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = boldNormalFont;
    
    UILabel *angleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.85*kScreenWidth, 0.075*kScreenWidth, 0.05*kScreenWidth, 0.05*kScreenWidth)];
    angleLabel.textColor = [UIColor whiteColor];
    angleLabel.textAlignment = NSTextAlignmentCenter;
    angleLabel.font = smallMediumFont;
    angleLabel.layer.cornerRadius = 0.025*kScreenWidth;
    angleLabel.layer.masksToBounds = YES;
    [cell.contentView addSubview:angleLabel];
    
    NSDictionary *messageNum = [[ZWSaveDataAction shareAction]takeMessageNum];
    if (messageNum) {
        if (indexPath.row == 0) {
            NSInteger systemNum = [messageNum[@"auditTotal"] integerValue];
            if (systemNum > 0) {
                if (systemNum >= 99) {
                    systemNum = 99;
                }
                angleLabel.text = [NSString stringWithFormat:@"%ld",(long)systemNum];
                angleLabel.backgroundColor = [UIColor redColor];
            }else {
                angleLabel.backgroundColor = [UIColor whiteColor];
            }
        }else if (indexPath.row == 1) {
            NSInteger activityNum = [messageNum[@"activityTotal"] integerValue];
            if (activityNum) {
                if (activityNum >= 99) {
                    activityNum = 99;
                }
                angleLabel.text = [NSString stringWithFormat:@"%ld",(long)activityNum];
                angleLabel.backgroundColor = [UIColor redColor];
            }else {
                angleLabel.backgroundColor = [UIColor whiteColor];
            }
        }else {
            NSInteger cardNum = [messageNum[@"cardTotal"] integerValue];
            if (cardNum) {
                if (cardNum >= 99) {
                    cardNum = 99;
                }
                angleLabel.text = [NSString stringWithFormat:@"%ld",(long)cardNum];
                angleLabel.backgroundColor = [UIColor redColor];
            }else {
                angleLabel.backgroundColor = [UIColor whiteColor];
            }
        }
    }
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
        messageSystemVC.title = @"审核通知";
        [self.navigationController pushViewController:messageSystemVC animated:YES];
    }else if (indexPath.row == 1) {
        ZWMessageActivitiesVC *messageActivitiesVC = [[ZWMessageActivitiesVC alloc]init];
        messageActivitiesVC.title = @"系统通知";
        [self.navigationController pushViewController:messageActivitiesVC animated:YES];
    }else {
        ZWMessageCardVC *messageCardVC = [[ZWMessageCardVC alloc]init];
        messageCardVC.title = @"名片收集";
        [self.navigationController pushViewController:messageCardVC animated:YES];
    }
}

@end
