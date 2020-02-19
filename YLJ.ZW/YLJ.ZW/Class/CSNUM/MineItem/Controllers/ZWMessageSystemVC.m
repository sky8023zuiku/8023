//
//  ZWMessageSystemVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageSystemVC.h"

@interface ZWMessageSystemVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ZWMessageSystemVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0,0.2*kScreenWidth+5, 0, 0);
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    titleImage.backgroundColor = zwDarkGrayColor;
    titleImage.layer.cornerRadius = 0.075*kScreenWidth;
    titleImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:titleImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, CGRectGetMinY(titleImage.frame), 0.2*kScreenWidth, CGRectGetHeight(titleImage.frame)/3)];
    titleLabel.text = @"审核结果";
    titleLabel.font = boldNormalFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *deteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.45*kScreenWidth, CGRectGetMinY(titleLabel.frame), 0.5*kScreenWidth, CGRectGetHeight(titleLabel.frame))];
    deteLabel.font = smallFont;
    deteLabel.textColor = [UIColor grayColor];
    deteLabel.text = @"2018-08-08 22:22";
    deteLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:deteLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), 0.75*kScreenWidth-5, CGRectGetHeight(titleImage.frame)/3*2)];
    detailLabel.text = @"审核不通过或是通过的原因审核不通过审核不通过或是通过的原因审核不通过或是通过的原因";
    detailLabel.numberOfLines = 2;
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = smallMediumFont;
    [cell.contentView addSubview:detailLabel];
    
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
@end
