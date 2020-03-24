//
//  ZWMyReleaseVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyReleaseVC.h"
#import "ZWMyReleaseCell.h"
#import "ZWEditExhibitionVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>

@interface ZWMyReleaseVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger type;//记录值
@property(nonatomic, assign)NSInteger page;//页面

@end

@implementation ZWMyReleaseVC

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

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
//    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"管理" barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)rightItemClcik:(UIBarButtonItem *)item {
//    if ([item.title isEqualToString:@"管理"]) {
//        self.type = 1;
//        self.navigationItem.rightBarButtonItem.title = @"删除";
//    }else {
//        self.type = 0;
//        self.navigationItem.rightBarButtonItem.title = @"管理";
//    }
//    [self.tableView reloadData];
//}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf createRequest:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:strongSelf.page];
    }];
}
- (void)createRequest:(NSInteger)page {
    ZWMyReleaseListRequst *requst = [[ZWMyReleaseListRequst alloc]init];
    requst.pageNo = [NSString stringWithFormat:@"%ld",(long)page];
    requst.pageSize = @"5";
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            NSLog(@"----%@",respense.data);
            NSArray *myData = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMyReleaseListModel *model = [ZWMyReleaseListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
            if (strongSelf.dataSource == 0) {
                [self showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无发布" withType:1];
            }
        }else {
            NSLog(@"%@",respense.data);
            [self showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:1];
        }
    }];
}

- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenHeight, kScreenWidth, 0.5*kScreenWidth)];
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
    self.type = 0;
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
    
    ZWMyReleaseListModel *model = self.dataSource[indexPath.row];
    ZWMyReleaseCell *releaseCell = [[ZWMyReleaseCell alloc]initWithFrame:CGRectMake(0, 0.025*kScreenWidth, kScreenWidth, 0.3*kScreenWidth)];
    releaseCell.model = model;
    [cell.contentView addSubview:releaseCell];
    
    UIButton *selectdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectdBtn.frame = CGRectMake(15, 40, 20, 20);
    [selectdBtn setBackgroundImage:[UIImage imageNamed:@"ren_fabu_icon_xuan_no"] forState:UIControlStateNormal];
    if (self.type == 1) {
        [releaseCell addSubview:selectdBtn];
    }else {
        [selectdBtn removeFromSuperview];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.35*kScreenWidth-1, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];

}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.35*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWMyReleaseListModel *model = self.dataSource[indexPath.row];
    NSDictionary *shareData = @{@"exhibitionName":model.exhibitionName,
                                @"coverImages":model.coverImages};
    if (shareData) {
        ZWEditExhibitionVC *exhibitionVC = [[ZWEditExhibitionVC alloc]init];
        exhibitionVC.title = @"展商详情";
        exhibitionVC.exhibitorId = model.exhibitorId;
        exhibitionVC.merchantId = model.merchantId;
        exhibitionVC.shareData = shareData;
        [self.navigationController pushViewController:exhibitionVC animated:YES];
    }
}

@end
