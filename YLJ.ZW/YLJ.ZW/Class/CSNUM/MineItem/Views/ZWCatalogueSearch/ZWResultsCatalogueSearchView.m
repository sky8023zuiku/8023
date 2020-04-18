//
//  ZWResultsCatalogueSearchView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/12.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWResultsCatalogueSearchView.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import "ZWExhibitionListsCell.h"
#import <MJRefresh.h>
#import "ZWExhibitionNaviVC.h"

@interface ZWResultsCatalogueSearchView ()<UITableViewDelegate, UITableViewDataSource ,ZWExhibitionListsCellDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
//@property (nonatomic, strong) NSArray<ZWMyCatalogueModel *> *dataSource;
@property (nonatomic, assign) BOOL isDoubleList;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *resultsText;

@end
@implementation ZWResultsCatalogueSearchView

- (instancetype)initWithFrame:(CGRect)frame withSearchText:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
//        self.dataSource = dataArr;
        _isDoubleList = YES;
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
        [strongSelf.dataArray removeAllObjects];
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
    
    NSLog(@"%@",text);
    
    ZWMyCatalogueListRequst *requst = [[ZWMyCatalogueListRequst alloc]init];
    requst.pageQuery = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"10"};
    requst.name = text;
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *dataArr = respense.data;
            NSMutableArray *myArray =[NSMutableArray array];
            for (NSDictionary *myDic in dataArr) {
                ZWExhibitionListModel *model = [ZWExhibitionListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.contentTableView reloadData];
        }
    }];
}


- (ZWBaseEmptyTableView *)contentTableView
{
    if (!_contentTableView) {
        self.contentTableView = [[ZWBaseEmptyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.sectionHeaderHeight = 0;
        _contentTableView.sectionFooterHeight = 0;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

- (void)refreshResultViewWithIsDouble:(BOOL)isDouble
{
    _isDoubleList = isDouble;
    [_contentTableView reloadData];
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
    
    if (self.dataArray.count != 0) {
        ZWExhibitionListModel *model = self.dataArray[indexPath.section];
        ZWExhibitionListsCell *exhibitionCell = [[ZWExhibitionListsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
        exhibitionCell.model = model;
        exhibitionCell.delegate = self;
        exhibitionCell.collectionBtn.tag = indexPath.section;
        [cell.contentView addSubview:exhibitionCell];
    }
}

-(void)collectionItemWithIndex:(ZWExhibitionListsCell *)cell withIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    ZWExhibitionListModel *model = self.dataArray[index];
    ZWCancelCollectionRequst *requst = [[ZWCancelCollectionRequst alloc]init];
    requst.exhibitionId = model.listId;
    __block ZWExhibitionListsCell *myCell = cell;
    [requst getRequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSLog(@"%@",cell.collectionBtnBackImageName);
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }else {
            NSLog(@"取消失败");
        }
    }];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.02*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count) {
        return 10;
    } else {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWExhibitionListModel *model = self.dataArray[indexPath.section];
    ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
    naviVC.hidesBottomBarWhenPushed = YES;
    naviVC.title = @"展会导航";
    naviVC.exhibitionId = model.listId;
    naviVC.price = model.price;
    [self.ff_navViewController pushViewController:naviVC animated:YES];
}

@end
