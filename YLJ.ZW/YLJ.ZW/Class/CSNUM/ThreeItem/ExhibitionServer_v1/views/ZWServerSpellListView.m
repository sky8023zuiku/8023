//
//  ZWServerSpellListView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/17.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWServerSpellListView.h"

#import "ZWSpellListType01Cell.h"
#import "ZWSpellListType02Cell.h"
#import "ZWSpellListType03Cell.h"
#import "ZWSpellListType04Cell.h"

@interface ZWServerSpellListView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)ZWBaseEmptyTableView *rightTableVIew;
@property(nonatomic, assign)NSInteger selectType;

@property(nonatomic, strong)NSMutableArray *rightDataSource;

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, strong)NSMutableDictionary *saveDic;
@end


@implementation ZWServerSpellListView

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
    return _rightTableVIew;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableVIew];
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.leftTableView]) {
        return 7;
    }else {
        return self.rightDataSource.count;
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
    NSArray *titles = @[@"全部",@"木结构拼单",@"桁架拼单",@"型材铝料拼单",@"看管拼单",@"保险拼单",@"货车拼单"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 0.2*kScreenWidth-23, 0.13*kScreenWidth-1)];
    titleLabel.text = titles[index];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZWSpellListModel *model = self.rightDataSource[index];
   if ([model.type isEqualToString:@"4"]) {
        ZWSpellListType02Cell *T02Cell = [[ZWSpellListType02Cell alloc]initWithFrame:CGRectMake(10, 10, 0.8*kScreenWidth-20, 0.45*kScreenWidth-10) withFont:[UIFont systemFontOfSize:0.03*kScreenWidth]];
        T02Cell.backgroundColor = [UIColor whiteColor];
        T02Cell.model = model;
        [cell.contentView addSubview:T02Cell];
    }else if ([model.type isEqualToString:@"5"]) {
        ZWSpellListType03Cell *T03Cell = [[ZWSpellListType03Cell alloc]initWithFrame:CGRectMake(10, 10, 0.8*kScreenWidth-20, 0.4*kScreenWidth-10) withFont:[UIFont systemFontOfSize:0.03*kScreenWidth]];
        T03Cell.backgroundColor = [UIColor whiteColor];
        T03Cell.model = model;
        [cell.contentView addSubview:T03Cell];
    }else if ([model.type isEqualToString:@"6"]){
        ZWSpellListType04Cell *T04Cell = [[ZWSpellListType04Cell alloc]initWithFrame:CGRectMake(10, 10, 0.8*kScreenWidth-20, 0.45*kScreenWidth-10) withFont:[UIFont systemFontOfSize:0.03*kScreenWidth]];
        T04Cell.backgroundColor = [UIColor whiteColor];
        T04Cell.model = model;
        [cell.contentView addSubview:T04Cell];
    }else {
        ZWSpellListType01Cell *T01Cell = [[ZWSpellListType01Cell alloc]initWithFrame:CGRectMake(10, 10, 0.8*kScreenWidth-20, 0.55*kScreenWidth-10) withFont:[UIFont systemFontOfSize:0.03*kScreenWidth]];
        T01Cell.backgroundColor = [UIColor whiteColor];
        T01Cell.model = model;
        [cell.contentView addSubview:T01Cell];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        return 0.13*kScreenWidth;
    }else {
        ZWSpellListModel *model = self.rightDataSource[indexPath.row];
        if ([model.type isEqualToString:@"4"]) {
            return 0.45*kScreenWidth;
        }else if ([model.type isEqualToString:@"5"]) {
            return 0.4*kScreenWidth;
        }else if ([model.type isEqualToString:@"6"]) {
            return 0.45*kScreenWidth;
        }else {
            return 0.55*kScreenWidth;
        }
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
        [self.leftTableView reloadData];
        if (indexPath.row == 0) {
            [self.saveDic setValue:@"" forKey:@"type"];
        }else if (indexPath.row == 1) {
            [self.saveDic setValue:@"1" forKey:@"type"];
        }else if (indexPath.row == 2) {
            [self.saveDic setValue:@"2" forKey:@"type"];
        }else if (indexPath.row == 3) {
            [self.saveDic setValue:@"3" forKey:@"type"];
        }else if (indexPath.row == 4) {
            [self.saveDic setValue:@"4" forKey:@"type"];
        }else if (indexPath.row == 5) {
            [self.saveDic setValue:@"5" forKey:@"type"];
        }else {
            [self.saveDic setValue:@"6" forKey:@"type"];
        }
        [self createRequstWithParameters:self.saveDic withPage:1];
    }else {
        
        
        
    }
}

- (NSMutableArray *)rightDataSource {
    if (!_rightDataSource) {
        _rightDataSource = [NSMutableArray array];
    }
    return _rightDataSource;
}

-(void)setMySpellParameters:(NSMutableDictionary *)mySpellParameters {
    self.selectType = 0;
    [self.leftTableView reloadData];
    self.saveDic = mySpellParameters;
    [self refreshHeader];
    [self refreshFooter];
    [self createRequstWithParameters:mySpellParameters withPage:1];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.rightTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequstWithParameters:strongSelf.saveDic withPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.rightTableVIew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequstWithParameters:strongSelf.saveDic withPage:strongSelf.page];
    }];
}


- (void)createRequstWithParameters:(NSMutableDictionary *)parameters withPage:(NSInteger)page {
    
    NSDictionary *pageDic = @{
        @"pageNo":[NSString stringWithFormat:@"%ld",page],
        @"pageSize":@"5"
    };
    [parameters setValue:pageDic forKey:@"pageQuery"];
    [parameters setValue:@"" forKey:@"city"];
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetExhibitionServerSpellList parametes:parameters successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf.rightTableVIew.mj_header endRefreshing];
                [strongSelf.rightTableVIew.mj_footer endRefreshing];
                if (zw_issuccess) {
                    if (page == 1) {
                        [strongSelf.rightDataSource removeAllObjects];
                    }
                    NSLog(@"%@",data[@"data"][@"result"]);
                    NSArray *arry = data[@"data"][@"result"];
                    NSMutableArray *myArray = [NSMutableArray array];
                    for (NSDictionary *myDic in arry) {
                        ZWSpellListModel *model = [ZWSpellListModel parseJSON:myDic];
                        [myArray addObject:model];
                    }
                    [self.rightDataSource addObjectsFromArray:myArray];
                    [strongSelf.rightTableVIew reloadData];
                    if (strongSelf.rightDataSource.count == 0) {
//                        [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无数据" withType:1];
                    }
                }else {
        //            [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
                }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}



@end
