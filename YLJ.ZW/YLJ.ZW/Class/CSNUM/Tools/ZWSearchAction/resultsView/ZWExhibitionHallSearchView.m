//
//  ZWExhibitionHallSearchView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionHallSearchView.h"
#import "ZWHallListModel.h"
#import "ZWHallTabbarCTR.h"
#import "ZWPavilionHallView.h"
@interface ZWExhibitionHallSearchView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)ZWBaseEmptyTableView *contentTableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSString *isSearchText;
@end
@implementation ZWExhibitionHallSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [NSMutableArray array];
        [self addSubview:self.contentTableView];
    }
    return self;
}

-(ZWBaseEmptyTableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.sectionHeaderHeight = 0;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0, 0 );
    return _contentTableView;
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
    [self.ff_navViewController pushViewController:tabbarVC animated:YES];
}

- (void)setSearchText:(NSString *)searchText {
    self.isSearchText = searchText;
    [self initWithDataWithText:searchText];
}

- (void)initWithDataWithText:(NSString *)text {
    self.page = 1;
    [self refreshDataWithText:text withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf refreshDataWithText:self.isSearchText withPage:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf refreshDataWithText:self.isSearchText withPage:self.page];
    }];
}
- (void)refreshDataWithText:(NSString *)text withPage:(NSInteger)page {
    
    NSDictionary *parametes = @{@"country":@"",
                                @"city":@"",
                                @"hallName":text,
                                @"pageQuery":@{
                                        @"pageNo":[NSString stringWithFormat:@"%ld",page],
                                        @"pageSize":@"10"
                                }};
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwHallList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
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
            [strongSelf.contentTableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
    }];
    
}

@end
