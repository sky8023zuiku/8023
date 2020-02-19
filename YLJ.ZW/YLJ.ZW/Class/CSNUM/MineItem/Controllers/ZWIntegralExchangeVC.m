//
//  ZWIntegralExchangeVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIntegralExchangeVC.h"
#import "ZWIntegralRulesVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>

@interface ZWIntegralExchangeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@end

@implementation ZWIntegralExchangeVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    self.page = 1;
    [self createRequest:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequest:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:self.page];
    }];
}

- (void)createRequest:(NSInteger)page {
    ZWIntegralSubsidiaryRequest *request = [[ZWIntegralSubsidiaryRequest alloc]init];
    request.pageNo = page;
    request.pageSize = 10;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            NSLog(@"%@",respense.data);
            NSArray *myData = respense.data[@"list"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWIntegralSubsidiaryModel *model = [ZWIntegralSubsidiaryModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [self.dataSource addObjectsFromArray:myArray];
            [self.tableView reloadData];
            if (strongSelf.dataSource.count == 0) {
                [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无数据" withType:1];
            }
        }else {
//           [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
        }
    }];
}

- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.1*kScreenHeight, 0.8*kScreenWidth, 0.45*kScreenWidth)];
    imageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 30)];
    myLabel.text = ditail;
    myLabel.font = bigFont;
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myLabel];
    
//    if (type == 2) {
//        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        reloadBtn.frame = CGRectMake(0.3*kScreenWidth, CGRectGetMaxY(myLabel.frame)+25, 0.4*kScreenWidth, 0.1*kScreenWidth);
//        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//        reloadBtn.layer.borderColor = skinColor.CGColor;
//        reloadBtn.titleLabel.font = normalFont;
//        reloadBtn.layer.cornerRadius = 0.05*kScreenWidth;
//        reloadBtn.layer.masksToBounds = YES;
//        [reloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
//        reloadBtn.layer.borderWidth = 1;
//        [reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:reloadBtn];
//    }
}
//- (void)reloadBtnClick:(UIButton *)btn {
//
//}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"规则" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    if (self.status == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightItemClick:(UIBarButtonItem *)item {
    ZWIntegralRulesVC *integralRulesVC = [[ZWIntegralRulesVC alloc]init];
    integralRulesVC.title = @"规则";
    [self.navigationController pushViewController:integralRulesVC animated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
    ZWIntegralSubsidiaryModel *model = self.dataSource[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0.04*kScreenWidth, 0.6*kScreenWidth-20, 0.08*kScreenWidth)];
    titleLabel.text = [NSString stringWithFormat:@"%@",model.describe];
    titleLabel.font = bigFont;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *reducehIntegral = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), 0.4*kScreenWidth-10, CGRectGetHeight(titleLabel.frame))];
    reducehIntegral.text = [NSString stringWithFormat:@"%@会展币",model.integralCount];
    reducehIntegral.textAlignment = NSTextAlignmentRight;
    reducehIntegral.font = bigFont;
    reducehIntegral.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:reducehIntegral];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame ), CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
    dateLabel.text = [self getTimeFromTimestamp:[[NSString stringWithFormat:@"%@",model.createtime] doubleValue]];
    dateLabel.font = normalFont;
    dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:dateLabel];
    
    UILabel *remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(reducehIntegral.frame), CGRectGetMaxY(titleLabel.frame ), CGRectGetWidth(reducehIntegral.frame), CGRectGetHeight(reducehIntegral.frame))];
    remainLabel.text = [NSString stringWithFormat:@"剩余%@会展币",model.remaining];
    remainLabel.textAlignment = NSTextAlignmentRight;
    remainLabel.font = normalFont;
    remainLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:remainLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.2*kScreenWidth-1, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.2*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (NSString *)getTimeFromTimestamp:(double)time{
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}


@end
