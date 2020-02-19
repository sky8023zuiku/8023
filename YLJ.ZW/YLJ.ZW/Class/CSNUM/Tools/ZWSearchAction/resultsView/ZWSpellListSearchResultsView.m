//
//  ZWSpellListSearchResultsView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSpellListSearchResultsView.h"
#import "ZWSpellListCell.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <MJRefresh.h>

#import "ZWSpellListModel.h"
#import "ZWSpellListType01Cell.h"
#import "ZWSpellListType02Cell.h"
#import "ZWSpellListType03Cell.h"
#import "ZWSpellListType04Cell.h"

@interface ZWSpellListSearchResultsView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *resultsText;

@property(nonatomic, strong) NSString *parameterType;//展会服务里面需要区分类别
@property(nonatomic, strong) NSString *city;//传入城市

@end
@implementation ZWSpellListSearchResultsView

- (instancetype)initWithFrame:(CGRect)frame withParameter:(id)obj
{
    if (self = [super initWithFrame:frame]) {
        self.parameterType = obj[@"type"];
        self.city = obj[@"city"];
        self.dataArray = [NSMutableArray array];
        [self addSubview:self.contentTableView];
        NSLog(@"----%@",self.searchText);
    }
    return self;
}

-(void)setSearchText:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    self.resultsText = searchText;
    [self createData:searchText];
}
-(void)createData:(NSString *)text {
    self.page = 1;
    [self createRequst:text withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequst:strongSelf.resultsText withPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequst:strongSelf.resultsText withPage:strongSelf.page];
    }];
}

- (void)createRequst:(NSString *)text withPage:(NSInteger)page{
    ZWServiceSpellListRequst *requst = [[ZWServiceSpellListRequst alloc]init];
    requst.status = 2;
    requst.merchantName = text;
    requst.city = self.city;
    requst.type = self.parameterType;
    requst.pageNo = (int)page;
    requst.pageSize = 5;
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSLog(@"%@",respense.data[@"result"]);
            NSArray *arry = respense.data[@"result"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in arry) {
                ZWSpellListModel *model= [ZWSpellListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [self.dataArray addObjectsFromArray:myArray];
            [strongSelf.contentTableView reloadData];
        }else {
          
        }
    }];
}
- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.sectionHeaderHeight = 0;
        _contentTableView.sectionFooterHeight = 0;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

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
//    ZWServiceSpellListModel *model = self.dataArray[indexPath.section];
//    model.type = self.parameterType;//获取拼单类型
//    ZWSpellListCell *spellListCell = [[ZWSpellListCell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.6*kScreenWidth-10)];
//    spellListCell.model = model;
//    spellListCell.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:spellListCell];
    
    ZWSpellListModel *model = self.dataArray[indexPath.row];
    if ([self.parameterType isEqualToString:@"1"]) {
        ZWSpellListType01Cell *T01Cell = [[ZWSpellListType01Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.7*kScreenWidth-10)];
        T01Cell.backgroundColor = [UIColor whiteColor];
        T01Cell.model = model;
        [cell.contentView addSubview:T01Cell];
    }else if ([self.parameterType isEqualToString:@"2"]) {
        ZWSpellListType02Cell *T02Cell = [[ZWSpellListType02Cell alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.6*kScreenWidth-10)];
        T02Cell.backgroundColor = [UIColor whiteColor];
        T02Cell.model = model;
        [cell.contentView addSubview:T02Cell];
    }else if ([self.parameterType isEqualToString:@"3"]) {
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
    if ([self.parameterType isEqualToString:@"1"]) {
        return 0.7*kScreenWidth;
    }else if ([self.parameterType isEqualToString:@"2"]) {
        return 0.6*kScreenWidth;
    }else if ([self.parameterType isEqualToString:@"3"]) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
