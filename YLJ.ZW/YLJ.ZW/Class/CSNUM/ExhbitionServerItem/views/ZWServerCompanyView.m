//
//  ZWServerCompanyView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWServerCompanyView.h"
#import "ZWExhServiceListCell.h"
#import "ZWExhibitionServerDetailVC.h"
#import "ZWExhibitinServerSecondaryIndustryModel.h"
#import "ZWExhibitionServerListModel.h"

@interface ZWServerCompanyView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)ZWBaseEmptyTableView *rightTableVIew;
@property(nonatomic, assign)NSInteger selectType;
@property(nonatomic, strong)NSArray *industryArray;

@property(nonatomic, strong)NSMutableArray *rightDataArray;

@property(nonatomic, strong)NSMutableDictionary *saveParameters;

@property(nonatomic, assign)NSInteger page;

@end
@implementation ZWServerCompanyView

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0.2*self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    }
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.sectionFooterHeight = 0;
    _leftTableView.sectionHeaderHeight = 0;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _leftTableView;
}

- (ZWBaseEmptyTableView *)rightTableVIew {
    if (!_rightTableVIew) {
        _rightTableVIew = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0.2*self.frame.size.width, 0, 0.8*self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    }
    _rightTableVIew.dataSource = self;
    _rightTableVIew.delegate = self;
    _rightTableVIew.sectionHeaderHeight = 0;
    _rightTableVIew.sectionFooterHeight = 0;
    _rightTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableVIew.showsHorizontalScrollIndicator = NO;
    _rightTableVIew.backgroundColor = [UIColor clearColor];
    _rightTableVIew.tableFooterView = [UIView new];
    return _rightTableVIew;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 1;
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableVIew];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma UITableViewDataSource;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.leftTableView]) {
        NSLog(@"11111-11111-11111=%ld",(long)self.industryArray.count);
        return self.industryArray.count;
    }else {
        return self.rightDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if ([tableView isEqual:self.leftTableView]) {
        [self createLeftTableWithCell:cell withIndex:indexPath.row];
    }else {
        [self createRightTableWithCell:cell withIndex:indexPath.row];
    }
    
    return cell;
}

- (void)createLeftTableWithCell:(UITableViewCell *)cell withIndex:(NSInteger)index {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.13*kScreenWidth-1, 0.2*kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    
    NSLog(@"22222-22222-22222=%ld",(long)self.industryArray.count);
    
    ZWExhibitinServerSecondaryIndustryModel *model = self.industryArray[index];
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 0.2*kScreenWidth-23, 0.13*kScreenWidth-1)];
    titleLabel.text = model.name;
    titleLabel.font = smallMediumFont;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    if (index == self.selectType) {
        cell.backgroundColor = [UIColor whiteColor];
        UIView *lineVertical = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 0.13*kScreenWidth-1)];
        lineVertical.backgroundColor = skinColor;
        [cell.contentView addSubview:lineVertical];
        titleLabel.textColor = skinColor;
        titleLabel.font = [UIFont systemFontOfSize:0.035*kScreenWidth];
    }else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)createRightTableWithCell:(UITableViewCell *)cell withIndex:(NSInteger)index {
    ZWExhibitionServerListModel *model = self.rightDataArray[index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZWExhServiceListCell *showCell = [[ZWExhServiceListCell alloc]initWithFrame:CGRectMake(0, 0, 0.8*kScreenWidth, 0.2*kScreenWidth)];
    showCell.titleLabel.font = boldSmallMediumFont;
    showCell.detailLabel.font = smallFont;
    showCell.model = model;
    [cell.contentView addSubview:showCell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        return 0.13*kScreenWidth;
    }else {
        return 0.2*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.leftTableView]) {
        if (self.selectType == indexPath.row) {
            return;
        }
        self.selectType = indexPath.row;
        ZWExhibitinServerSecondaryIndustryModel *model = self.industryArray[indexPath.row];
        [self.saveParameters setValue:model.industryId forKey:@"secondIndustry"];
        [self createGetListWithParameter:self.saveParameters withPage:1];
        [self.leftTableView reloadData];
    }else {
        ZWExhibitionServerListModel *model = self.rightDataArray[indexPath.row];
        ZWExhibitionServerDetailVC *VC = [[ZWExhibitionServerDetailVC alloc]init];
        VC.merchantId = [NSString stringWithFormat:@"%@",model.providersId];
        VC.shareModel = model;
        [self.ff_navViewController pushViewController:VC animated:YES];
    }
}

- (void)setParameters:(NSMutableDictionary *)parameters {
    
    self.saveParameters = parameters;
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwGetExhibitionServerSecondaryIndustryList parametes:@{@"ParentId":parameters[@"firstIndustry"]} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            ZWExhibitinServerSecondaryIndustryModel *model = [[ZWExhibitinServerSecondaryIndustryModel alloc]init];
            model.industryId = @"";
            model.name = @"全部";
            [myArray addObject:model];
            for (NSDictionary *myDic in myData) {
//                ZWExhibitinServerSecondaryIndustryModel *model = [ZWExhibitinServerSecondaryIndustryModel parseJSON:myDic];
                ZWExhibitinServerSecondaryIndustryModel *model = [ZWExhibitinServerSecondaryIndustryModel mj_objectWithKeyValues:myDic];
                [myArray addObject:model];
            }
            strongSelf.selectType = 0;
            [strongSelf.saveParameters setValue:@"" forKey:@"secondIndustry"];
            strongSelf.industryArray = myArray;
            [strongSelf.leftTableView reloadData];
            [strongSelf createGetListWithParameter:parameters withPage:1];
            [strongSelf refreshHeader];
            [strongSelf refreshFooter];
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.rightTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createGetListWithParameter:self.saveParameters withPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.rightTableVIew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createGetListWithParameter:self.saveParameters withPage:strongSelf.page];
    }];
}


- (NSMutableArray *)rightDataArray {
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}


- (void)createGetListWithParameter:(NSDictionary *)myDic withPage:(NSInteger)page {
    
    NSDictionary *pageDic = @{
        @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
        @"pageSize":@"10"
    };
    NSMutableDictionary * myDictionary = [[NSMutableDictionary alloc] init];
    [myDictionary setValue:pageDic forKey:@"pageQuery"];
    [myDictionary addEntriesFromDictionary:myDic];
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetAllExhibitionServerList parametes:myDictionary successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.rightTableVIew.mj_header endRefreshing];
        [strongSelf.rightTableVIew.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.rightDataArray removeAllObjects];
            }
            NSArray *array = data[@"data"][@"providerList"];
            NSMutableArray *myArr = [NSMutableArray array];
            for (NSDictionary *myDic in array) {
//                ZWServiceProvidersListModel *model = [ZWServiceProvidersListModel parseJSON:myDic];
                ZWExhibitionServerListModel *model = [ZWExhibitionServerListModel mj_objectWithKeyValues:myDic];
                [myArr addObject:model];
            }
            [strongSelf.rightDataArray addObjectsFromArray:myArr];
            [strongSelf.rightTableVIew reloadData];
        }else {
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}


@end
