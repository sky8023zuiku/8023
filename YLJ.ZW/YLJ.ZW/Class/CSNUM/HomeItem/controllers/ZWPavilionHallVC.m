//
//  ZWPavilionHallVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPavilionHallVC.h"
#import "ZWPavilionHallView.h"
#import "ZWHallTabbarCTR.h"
#import "ZWHallListModel.h"
#import "CSSearchVC.h"

@interface ZWPavilionHallVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation ZWPavilionHallVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0, 0 );
    return _tableView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationController.navigationBar.barTintColor = skinColor;
    [[YNavigationBar sharedInstance]createSkinNavigationBar:self.navigationController.navigationBar withBackColor:skinColor withTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self initWithData];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(backBtn:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(sreachItemClick:)];
}

- (void)backBtn:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sreachItemClick:(UIBarButtonItem *)item {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 8;
    searchVC.isAnimation = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    ZWHallListModel *model = self.dataArray[indexPath.row];
    ZWPavilionHallView *pavilionHallView = [[ZWPavilionHallView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    pavilionHallView.model = model;
    [cell.contentView addSubview:pavilionHallView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWHallListModel *model = self.dataArray[indexPath.row];
    ZWHallTabbarCTR *tabbarVC = [[ZWHallTabbarCTR alloc]init];
    tabbarVC.model = model;
    [self.navigationController pushViewController:tabbarVC animated:YES];
}


- (void)initWithData {
    self.page = 1;
    [self refreshData:self.page];
    [self refreshHeader];
    [self refreshFooter];
}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [self refreshData:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [self refreshData:self.page];
    }];
}
- (void)refreshData:(NSInteger)page {
    
    NSDictionary *parametes = @{@"country":@"",
                                @"city":@"",
                                @"hallName":@"",
                                @"pageQuery":@{
                                        @"pageNo":[NSString stringWithFormat:@"%ld",page],
                                        @"pageSize":@"10"
                                }};
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwHallList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWHallListModel *model = [ZWHallListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
    
}

@end
