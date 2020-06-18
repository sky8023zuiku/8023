//
//  ZWMyCollectionVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyCollectionVC.h"
#import "ZWExhibitionListsCell.h"
#import "ZWExhibitionMerchantCell.h"
#import "ZWIndustryMerchantCell.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>
#import "ZWPayVC.h"
#import "UIView+MJExtension.h"

#import "ZWTopSelectView.h"

#import "ZWMyCatalogueCell.h"

#import "ZWExhibitionNaviVC.h"
#import "ZWEditExhibitionVC.h"
#import "ZWBoothPictureVC.h"

#import "ZWExhibitorsDetailsVC.h"
#import "ZWExExhibitorsDetailsVC.h"
#import "ZWExhibitionDelayCell.h"

@interface ZWMyCollectionVC ()<UITableViewDelegate,UITableViewDataSource,ZWExhibitionListsCellDelegate,ZWIndustryMerchantCellDelegate,ZWExhibitionMerchantCellDelegate,ZWTopSelectViewDelegate,ZWExhibitionDelayCellDelegate>

@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;

@property(nonatomic, strong)UIView *lineBlue;

@property(nonatomic, assign)NSInteger type;//类型0为展会，1为展会展商，2为行业展商

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, strong)NSMutableArray *exhibitionDataSource;
@property(nonatomic, strong)NSMutableArray *exhibitorsDataSource;
@property(nonatomic, strong)NSMutableArray *industryDataSource;

@property(nonatomic, strong)NSString *exhibitionId;//展会id

@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)NSMutableArray * titleBtns;
@property(nonatomic, strong)UIView *lineView;
@property (nonatomic, weak) UIButton *selectButton;


@end

@implementation ZWMyCollectionVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0.08*kScreenWidth, kScreenWidth, kScreenHeight-zwNavBarHeight-0.08*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    self.page = 1;
    [self createRequst:self.type withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
    
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    
    self.type = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.exhibitionDataSource = [NSMutableArray array];
    self.exhibitorsDataSource = [NSMutableArray array];
    self.industryDataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
//    [self createSeg];
    ZWTopSelectView *selectView = [[ZWTopSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.08*kScreenWidth) withTitles:@[@"展会",@"展会展商",@"行业展商"]];
    selectView.delegate = self;
    [self.view addSubview:selectView];
    
}

-(void)clickItemWithIndex:(NSInteger)index {
    if (index == 0) {
        self.type = 0;
        [self.exhibitionDataSource removeAllObjects];
        self.page = 1;
        [self createRequst:self.type withPage:self.page];
    }else if(index == 1) {
        self.type = 1;
        [self.exhibitorsDataSource removeAllObjects];
        self.page = 1;
        [self createRequst:self.type withPage:self.page];
    }else {
        self.type = 2;
        [self.industryDataSource removeAllObjects];
        self.page = 1;
        [self createRequst:self.type withPage:self.page];
    }
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 0) {
        return self.exhibitionDataSource.count;
    }else if (self.type == 1) {
        return self.exhibitorsDataSource.count;
    }else {
        return self.industryDataSource.count;
    }
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
    if (self.type == 0) {
        ZWExhibitionListModel *model = self.exhibitionDataSource[indexPath.row];
        if ([model.developingState isEqualToString:@"1"]) {
            ZWExhibitionDelayCell *delayCell = [[ZWExhibitionDelayCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
            delayCell.delegate = self;
            delayCell.model = model;
            delayCell.collectionBtn.tag = indexPath.row;
            [cell.contentView addSubview:delayCell];
        }else {
            ZWExhibitionListsCell *exhibitionCell = [[ZWExhibitionListsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
            exhibitionCell.model = model;
            exhibitionCell.delegate = self;
            exhibitionCell.collectionBtn.tag = indexPath.row;
            [cell.contentView addSubview:exhibitionCell];
        }
        
        
    }else if (self.type == 1) {
        ZWExExhibitorsModel *model = self.exhibitorsDataSource[indexPath.row];
        model.JumpType = 1;
        ZWExhibitionMerchantCell *merchantCell = [[ZWExhibitionMerchantCell alloc]initWithFrame:CGRectMake(0, 0.01*kScreenWidth, kScreenWidth, 0.3*kScreenWidth-1)];
        merchantCell.tag = indexPath.row;
        merchantCell.model = model;
        merchantCell.delegate = self;
        [cell.contentView addSubview:merchantCell];
    }else {
        ZWIndustryExhibitorsListModel *model = self.industryDataSource[indexPath.row];
        ZWIndustryMerchantCell *merchantCell = [[ZWIndustryMerchantCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth-1)];
        merchantCell.tag = indexPath.row;
        merchantCell.model = model;
        merchantCell.delegate = self;
        [cell.contentView addSubview:merchantCell];
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        ZWExhibitionListModel *model = self.exhibitionDataSource[indexPath.row];
        if ([model.developingState isEqualToString:@"1"]) {
            return 0.32*kScreenWidth;
        }else {
            return 0.28*kScreenWidth;
        }
    }else if (self.type == 1) {
        return 0.3*kScreenWidth;
    }else {
        return 0.3*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        
        ZWExhibitionNaviVC *vc = [[ZWExhibitionNaviVC alloc]init];
        ZWExhibitionListModel *model = self.exhibitionDataSource[indexPath.row];
        vc.exhibitionId = model.listId;
        vc.price = model.price;
        vc.title = @"展会导航";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.type == 1) {
        
        ZWExExhibitorsModel *model = self.exhibitorsDataSource[indexPath.row];
        ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
        detailsVC.title = @"展商详情";
        detailsVC.shareModel = model;
        [self.navigationController pushViewController:detailsVC animated:YES];

    }else {
        
        ZWIndustryExhibitorsListModel *model = self.industryDataSource[indexPath.row];
        ZWExhibitorsDetailsVC *detailsVC = [[ZWExhibitorsDetailsVC alloc]init];
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.title = @"展商详情";
        detailsVC.merchantId = [NSString stringWithFormat:@"%@",model.merchantId];
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
}

-(void)clickBtnWithIndex:(NSInteger)index {
    ZWExExhibitorsModel *model = self.exhibitorsDataSource[index];
    ZWBoothPictureVC *vc = [[ZWBoothPictureVC alloc]init];
    vc.imageUrl = model.expositionUrl;
    vc.title = @"展位图";
    [self.navigationController pushViewController:vc animated:YES];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        if (strongSelf.type == 0) {
            [strongSelf.exhibitionDataSource removeAllObjects];
        }else if (strongSelf.type == 1) {
            [strongSelf.exhibitorsDataSource removeAllObjects];
        }else {
            [strongSelf.industryDataSource removeAllObjects];
        }
        [strongSelf createRequst:strongSelf.type withPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequst:strongSelf.type withPage:strongSelf.page];
    }];
}

-(void)createRequst:(NSInteger)type withPage:(NSInteger)page {
    if (type == 0) {
        ZWExhibitionListRequst *request = [[ZWExhibitionListRequst alloc]init];
        request.pageNo = [NSString stringWithFormat:@"%ld",(long)page];
        request.pageSize = @"8";
        __weak typeof (self) weakSelf = self;
        [request postRequestCompleted:^(YHBaseRespense *respense) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            if (respense.isFinished) {
                NSLog(@"展会数据：%@",respense.data);
                NSArray *dataArr = respense.data;
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in dataArr) {
                    ZWExhibitionListModel *model = [ZWExhibitionListModel mj_objectWithKeyValues:myDic];
                    [myArray addObject:model];
                }
                [strongSelf.exhibitionDataSource addObjectsFromArray:myArray];
                [strongSelf.tableView reloadData];

            }else {

            }
        }];
    }else if (type == 1) {
        ZWExhibitorsListRequst *request = [[ZWExhibitorsListRequst alloc]init];
        request.pageNo = [NSString stringWithFormat:@"%ld",(long)page];
        request.pageSize = @"8";
        __weak typeof (self) weakSelf = self;
        [request postRequestCompleted:^(YHBaseRespense *respense) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
    
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];

            if (respense.isFinished) {
                NSLog(@"展会展商数据：%@",respense.data);
                NSArray *dataArr = respense.data;
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in dataArr) {
                    ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                [strongSelf.exhibitorsDataSource addObjectsFromArray:myArray];
                [strongSelf.tableView reloadData];

            }else {

            }
        }];
    }else {
        ZWIndustryExhibitorsListRequst *request = [[ZWIndustryExhibitorsListRequst alloc]init];
        request.pageNo = [NSString stringWithFormat:@"%ld",(long)page];
        request.pageSize = @"8";
        __weak typeof (self) weakSelf = self;
        [request postRequestCompleted:^(YHBaseRespense *respense) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            if (respense.isFinished) {
                NSLog(@"行业展商数据：%@",respense.data);
                NSArray *dataArr = respense.data;
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in dataArr) {
                    ZWIndustryExhibitorsListModel *model = [ZWIndustryExhibitorsListModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                [strongSelf.industryDataSource addObjectsFromArray:myArray];
                [strongSelf.tableView reloadData];
            }else {

            }
        }];
    }
}
#pragma ZWExhibitionCellDelegate
-(void)collectionItemWithIndex:(ZWExhibitionListsCell *)cell withIndex:(NSInteger)index {
    [self deleteCollectionWithIndex:index];
}
#pragma ZWExhibitionDelayCellDelegate
-(void)collectionItemWithCell:(ZWExhibitionDelayCell *)cell withIndex:(NSInteger)index {
    [self deleteCollectionWithIndex:index];
}
- (void)deleteCollectionWithIndex:(NSInteger)index {
    NSLog(@"--我的索引--%ld",(long)index);
    ZWExhibitionListModel *model = self.exhibitionDataSource[index];
    ZWCancelCollectionRequst *requst = [[ZWCancelCollectionRequst alloc]init];
    requst.exhibitionId = model.listId;
    __weak typeof (self) weakSelf = self;
    [requst getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"取消成功");
            [strongSelf.exhibitionDataSource removeObjectAtIndex:index];
            [strongSelf.tableView reloadData];
        }else {
            NSLog(@"取消失败");
        }
    }];
}


#pragma ZWExhibitionMerchantCellDelegate
-(void)exhibitorsItemWithIndex:(ZWExhibitionMerchantCell *)cell withIndex:(NSInteger)index {
    NSLog(@"22222");
    ZWExExhibitorsModel *model = self.exhibitorsDataSource[index];
    ZWCancelExhibitorsCollectionRequst *request = [[ZWCancelExhibitorsCollectionRequst alloc]init];
    request.exhibitorId = model.exhibitorId;
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"取消成功");
            [strongSelf.exhibitorsDataSource removeObjectAtIndex:index];
            [strongSelf.tableView reloadData];
        }else {
            
        }
    }];
}
#pragma ZWIndustryMerchantCellDelegate
-(void)industryCancelTheCollection:(ZWIndustryMerchantCell *)cell withIndex:(NSInteger)index {
    NSLog(@"33333");
    ZWIndustryExhibitorsListModel *model = self.industryDataSource[index];
    ZWCancelIndustryCollectionRequst *request = [[ZWCancelIndustryCollectionRequst alloc]init];
    request.merchantId = model.merchantId;
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"取消成功");
            [strongSelf.industryDataSource removeObjectAtIndex:index];
            [strongSelf.tableView reloadData];
        }else {
            
        }
    }];
}

@end
