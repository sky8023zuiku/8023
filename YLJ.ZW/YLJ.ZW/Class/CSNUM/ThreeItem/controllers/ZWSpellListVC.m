//
//  ZWSpellListVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSpellListVC.h"
#import "ZWSpellListCell.h"
#import "CSSearchVC.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <MJRefresh.h>

#import "ZWSpellListType01Cell.h"
#import "ZWSpellListType02Cell.h"
#import "ZWSpellListType03Cell.h"
#import "ZWSpellListType04Cell.h"

#import "ZWSpellListModel.h"

@interface ZWSpellListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;
@end

@implementation ZWSpellListVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
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
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClcik:(UIBarButtonItem *)item {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 2;
    searchVC.city = self.selectedCity;
    searchVC.parameterType = self.type;
    searchVC.isAnimation = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
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

- (void)createRequest:(NSInteger)page  {
    ZWServiceSpellListRequst *requst = [[ZWServiceSpellListRequst alloc]init];
    requst.status = 2;
    requst.merchantName = @"";
    requst.city = self.selectedCity;
    requst.type = self.type;
    requst.pageNo = (int)page;
    requst.pageSize = 5;
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            NSLog(@"%@",respense.data[@"result"]);
            NSArray *arry = respense.data[@"result"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in arry) {
                ZWSpellListModel *model = [ZWSpellListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [self.dataSource addObjectsFromArray:myArray];
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
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
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
    cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWSpellListModel *model = self.dataSource[indexPath.row];
    if ([self.type isEqualToString:@"1"]) {
        ZWSpellListType01Cell *T01Cell = [[ZWSpellListType01Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.7*kScreenWidth-10)];
        T01Cell.backgroundColor = [UIColor whiteColor];
        T01Cell.model = model;
        [cell.contentView addSubview:T01Cell];
    }else if ([self.type isEqualToString:@"2"]) {
        ZWSpellListType02Cell *T02Cell = [[ZWSpellListType02Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.6*kScreenWidth-10)];
        T02Cell.backgroundColor = [UIColor whiteColor];
        T02Cell.model = model;
        [cell.contentView addSubview:T02Cell];
    }else if ([self.type isEqualToString:@"3"]) {
        ZWSpellListType03Cell *T03Cell = [[ZWSpellListType03Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.55*kScreenWidth-10)];
        T03Cell.backgroundColor = [UIColor whiteColor];
        T03Cell.model = model;
        [cell.contentView addSubview:T03Cell];
    }else {
        ZWSpellListType04Cell *T04Cell = [[ZWSpellListType04Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.6*kScreenWidth-10)];
        T04Cell.backgroundColor = [UIColor whiteColor];
        T04Cell.model = model;
        [cell.contentView addSubview:T04Cell];
    }
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.type isEqualToString:@"1"]) {
        return 0.7*kScreenWidth;
    }else if ([self.type isEqualToString:@"2"]) {
        return 0.6*kScreenWidth;
    }else if ([self.type isEqualToString:@"3"]) {
        return 0.55*kScreenWidth;
    }else {
        return 0.6*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end
