//
//  ZWSpellListSearchResultsView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSpellListSearchResultsView.h"
#import "ZWSpellListCell.h"
#import <MJRefresh.h>
#import "ZWSpellListModel.h"
#import "ZWServerSpellListDetailVC.h"

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
    NSDictionary *parameters = @{
        @"city":self.self.city,
        @"merchantName":text,
        @"type":@"",
        @"status":@"2",
        @"pageQuery":@{
                @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                @"pageSize":@"5"
        }
    };
    if (parameters) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwGetExhibitionServerSpellList parametes:parameters successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
                    [strongSelf.contentTableView.mj_header endRefreshing];
                    [strongSelf.contentTableView.mj_footer endRefreshing];
                    if (zw_issuccess) {
                        if (page == 1) {
                            [strongSelf.dataArray removeAllObjects];
                        }
                        NSArray *arry = data[@"data"][@"result"];
                        NSMutableArray *myArray = [NSMutableArray array];
                        for (NSDictionary *myDic in arry) {
//                            ZWSpellListModel *model = [ZWSpellListModel parseJSON:myDic];
                            ZWSpellListModel *model = [ZWSpellListModel mj_objectWithKeyValues:myDic];
                            [myArray addObject:model];
                        }
                        [self.dataArray addObjectsFromArray:myArray];
                        [strongSelf.contentTableView reloadData];
                    }else {
                        
                    }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (ZWBaseEmptyTableView *)contentTableView
{
    if (!_contentTableView) {
        self.contentTableView = [[ZWBaseEmptyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.sectionHeaderHeight = 0;
        _contentTableView.sectionFooterHeight = 0;
        _contentTableView.backgroundColor = [UIColor whiteColor];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    
    ZWSpellListModel *model = self.dataArray[indexPath.row];
    ZWSpellListCell *listCell = [[ZWSpellListCell alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0.25*kScreenWidth) withFont:smallMediumFont];
    listCell.backgroundColor = [UIColor whiteColor];
    listCell.model = model;
    listCell.layer.cornerRadius = 3;
    listCell.layer.masksToBounds = NO;
    listCell.layer.shadowOpacity=1;///不透明度
    listCell.layer.shadowColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor;//阴影颜色
    listCell.layer.shadowOffset = CGSizeMake(0, 0);//投影偏移
    listCell.layer.shadowRadius = 4;//半径大小
    [cell.contentView addSubview:listCell];
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.25*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.03*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWSpellListModel *model = self.dataArray[indexPath.section];
    ZWServerSpellListDetailVC *spellDetailVC = [[ZWServerSpellListDetailVC alloc]init];
    spellDetailVC.model = model;
    [self.ff_navViewController pushViewController:spellDetailVC animated:YES];
}
@end
