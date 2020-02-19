//
//  ZWCompanyDesignVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCompanyDesignVC.h"
#import "ZWCompanyDetailVC.h"

#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "CSSearchVC.h"

#import "ZWExhServiceListCell.h"

@interface ZWCompanyDesignVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@end

@implementation ZWCompanyDesignVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
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
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 1;
    searchVC.city = self.selectedCity;
    searchVC.parameterType = self.type;
    [self.navigationController pushViewController:searchVC animated:YES];
}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf.dataSource removeAllObjects];
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

    ZWServiceProvidersListRequst *requst = [[ZWServiceProvidersListRequst alloc]init];
    requst.status = 2;
    requst.merchantName = @"";
    requst.city = self.selectedCity;
    requst.type = self.type;
    requst.pageNo = (int)page;
    requst.pageSize = 10;
    
    __weak typeof(self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            NSLog(@"%@",[[ZWToolActon shareAction]transformDic:respense.data[@"result"]]);
            NSArray *array = respense.data[@"result"];
            NSMutableArray *myArr = [NSMutableArray array];
            for (NSDictionary *myDic in array) {
                ZWServiceProvidersListModel *model = [ZWServiceProvidersListModel parseJSON:myDic];
                [myArr addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArr];
            [strongSelf.tableView reloadData];
            if (strongSelf.dataSource.count == 0) {
                [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无数据" withType:1];
            }
        }else {
//            [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
        }
    }];
}

- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.1*kScreenHeight, 0.8*kScreenWidth, 0.5*kScreenWidth)];
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


- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWServiceProvidersListModel *model = self.dataSource[indexPath.row];
    
    ZWExhServiceListCell *showCell = [[ZWExhServiceListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    showCell.model = model;
    [cell.contentView addSubview:showCell];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0.3*kScreenWidth-1, kScreenWidth-30, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWServiceProvidersListModel *model = self.dataSource[indexPath.row];
    ZWCompanyDetailVC *companyDetailVC = [[ZWCompanyDetailVC alloc]init];
    companyDetailVC.serviceId = [NSString stringWithFormat:@"%@",model.providersId];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

@end
