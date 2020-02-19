//
//  ZWPlanExhibitionSearchView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPlanExhibitionSearchView.h"
#import "ZWExhPlanListModel.h"
#import "ZWPlansListCell.h"
#import "ZWPlansDetailVC.h"
#import "ZWExhibitionListRequsetAction.h"
@interface ZWPlanExhibitionSearchView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property (nonatomic, strong) ZWExhibitionListRequsetAction *action;

@end
@implementation ZWPlanExhibitionSearchView

- (instancetype)initWithFrame:(CGRect)frame withSearchText:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray array];
        [self addSubview:self.contentTableView];
    }
    return self;
}

-(ZWExhibitionListRequsetAction *)action {
    if (!_action) {
        _action = [[ZWExhibitionListRequsetAction alloc]init];
    }
    return _action;
}

-(UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.sectionHeaderHeight = 0;
    _contentTableView.sectionFooterHeight = 0;
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0 );
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
    ZWExhPlanListModel *model = self.dataArray[indexPath.row];
    ZWPlansListCell *plansListCell = [[ZWPlansListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    plansListCell.tag = indexPath.section;
    plansListCell.model = model;
    [cell.contentView addSubview:plansListCell];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count-1) {
        return 0.01*kScreenWidth;
    } else {
        return 0.1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExhPlanListModel *model = self.dataArray[indexPath.row];
    ZWPlansDetailVC *detailVC = [[ZWPlansDetailVC alloc]init];
    detailVC.ID = model.ID;
    detailVC.title = @"计划展会详情";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:detailVC animated:YES];
}


-(void)setSearchText:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    [self createData:searchText];
}
-(void)createData:(NSString *)text {
    NSLog(@"我的搜索值 = %@",text);
    self.page = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:text forKey:@"name"];
    [self requestPianExhibitionList:dic withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }];
}

/**
 * 网络请求获取计划展会列表
*/
- (void)requestPianExhibitionList:(NSDictionary *)parametes withPage:(NSInteger)page {
    NSLog(@"我的搜索值 = %@",parametes);
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwPlanExhibitionList parametes:[self takeParameters:parametes withPage:page] successBlock:^(NSDictionary * _Nonnull data) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExhPlanListModel *model = [ZWExhPlanListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.contentTableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
       __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
    }];
}

-(NSDictionary *)takeParameters:(NSDictionary *)dic withPage:(NSInteger)page  {
    
    NSLog(@"我的搜索值 = %@",dic);
    self.action.name = dic[@"name"];
    NSLog(@"%@",self.action.name);
    self.action.pageQuery = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                              @"pageSize":@"10"};
    return self.action.mj_keyValues;
}

@end
