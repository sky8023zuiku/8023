//
//  ZWServerSpellListView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/17.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWServerSpellListView.h"
#import "ZWSpellListCell.h"

#import "ZWServerSpellListDetailVC.h"
#import "UButton.h"
#import "ZWMineReleaseSpelllistVC.h"

@interface ZWServerSpellListView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)ZWBaseEmptyTableView *rightTableVIew;
@property(nonatomic, assign)NSInteger selectType;

@property(nonatomic, strong)NSMutableArray *rightDataSource;

@property(nonatomic, assign)NSInteger page;

@property(nonatomic, strong)NSMutableDictionary *saveDic;

@property(nonatomic, strong)ZWSelectBtn *screenBtn;

@property(nonatomic, strong)NSString *spellStatus;

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
        _rightTableVIew = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0.2*self.frame.size.width, 0.1*kScreenWidth, 0.8*self.frame.size.width, self.frame.size.height-0.1*kScreenWidth) style:UITableViewStyleGrouped];
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
        
        [self createReleaseItem];
    }
    return self;
}

- (void)createReleaseItem {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0, 0.8*self.frame.size.width, 0.1*kScreenWidth)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 3;
    topView.layer.masksToBounds = NO;
    topView.layer.shadowOpacity=1;///不透明度
    topView.layer.shadowColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor;//阴影颜色
    topView.layer.shadowOffset = CGSizeMake(0, 0);//投影偏移
    topView.layer.shadowRadius = 4;//半径大小
    [self addSubview:topView];
    
    UIView *screenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(topView.frame)/2, 0.1*kScreenWidth)];
    [topView addSubview:screenView];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenItemClick:)];
    [screenView addGestureRecognizer:tap];
    
    self.screenBtn = [[ZWSelectBtn alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.0325*kScreenWidth, CGRectGetWidth(screenView.frame)-0.05*kScreenWidth, 0.035*kScreenWidth)];
    [self.screenBtn setTitle:@"只看拼单中" forState:UIControlStateNormal];
    [self.screenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.screenBtn setImage:[UIImage imageNamed:@"unselect_icon"] forState:UIControlStateNormal];
    self.screenBtn.titleLabel.font = smallMediumFont;
    self.screenBtn.userInteractionEnabled = NO;
    [screenView addSubview:self.screenBtn];
    
    UIView *releaseView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(screenView.frame), 0, CGRectGetWidth(screenView.frame), CGRectGetHeight(screenView.frame))];
    [topView addSubview:releaseView];
    
    CGFloat releaseW = [[ZWToolActon shareAction]adaptiveTextWidth:@"发布拼单" labelFont:smallFont]+20;
    UIButton *releaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(releaseView.frame)-releaseW-10, 0.025*kScreenWidth, releaseW, 0.05*kScreenWidth)];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseBtn setTitle:@"发布拼单" forState:UIControlStateNormal];
    releaseBtn.titleLabel.font = smallFont;
    releaseBtn.backgroundColor = skinColor;
    releaseBtn.layer.cornerRadius = 0.025*kScreenWidth;
    releaseBtn.layer.masksToBounds = YES;
    [releaseBtn addTarget:self action:@selector(releaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [releaseView addSubview:releaseBtn];

}
- (void)releaseBtnClick:(UIButton *)btn {
//    ZWReleaseSpelllistVC *listVC = [[ZWReleaseSpelllistVC alloc]init];
//    listVC.pageIndex = 2;
//    [self.ff_navViewController pushViewController:listVC animated:YES];
    
    ZWMineReleaseSpelllistVC *listVC = [[ZWMineReleaseSpelllistVC alloc]init];
    [self.ff_navViewController pushViewController:listVC animated:YES];
}

- (void)screenItemClick:(UITapGestureRecognizer *)gesture {
    self.screenBtn.selected = !self.screenBtn.selected;
    if (self.screenBtn.selected) {
        [self.screenBtn setImage:[UIImage imageNamed:@"message_guanli_selected"] forState:UIControlStateNormal];
        self.spellStatus = @"1";
    }else {
        [self.screenBtn setImage:[UIImage imageNamed:@"unselect_icon"] forState:UIControlStateNormal];
        self.spellStatus = @"";
    }
    [self.saveDic setValue:self.spellStatus forKey:@"spellStatus"];
    [self createRequstWithParameters:self.saveDic withPage:1];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.leftTableView]) {
        return 1;
    }else {
        return self.rightDataSource.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.leftTableView]) {
        return 7;
    }else {
        return 1;
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
        [self createRightTableWithCell:cell withIndex:indexPath.section];
    }
    
    return cell;
}

- (void)createLeftTableWithCell:(UITableViewCell *)cell withIndex:(NSInteger)index {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.13*kScreenWidth-1, 0.2*kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    NSArray *titles = @[@"全部",@"木结构拼单",@"桁架拼单",@"型材铝料拼单",@"看馆拼单",@"保险拼单",@"货车拼单"];
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
    
    ZWSpellListCell *listCell = [[ZWSpellListCell alloc]initWithFrame:CGRectMake(10, 0, 0.8*kScreenWidth-20, 0.25*kScreenWidth) withFont:smallMediumFont];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        return 0.13*kScreenWidth;
    }else {
        return 0.25*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.leftTableView]) {
        return 0.01;
    }else {
        return 0.03*kScreenWidth;
    }
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
        ZWSpellListModel *model = self.rightDataSource[indexPath.section];
        ZWServerSpellListDetailVC *spellDetailVC = [[ZWServerSpellListDetailVC alloc]init];
        spellDetailVC.model = model;
        [self.ff_navViewController pushViewController:spellDetailVC animated:YES];
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
        @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
        @"pageSize":@"10"
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
//                        ZWSpellListModel *model = [ZWSpellListModel parseJSON:myDic];
                        ZWSpellListModel *model = [ZWSpellListModel mj_objectWithKeyValues:myDic];
                        [myArray addObject:model];
                    }
                    [self.rightDataSource addObjectsFromArray:myArray];
                    [strongSelf.rightTableVIew reloadData];
                }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}


- (void)setTheRoundedCorners:(UIView *)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(0.04*kScreenWidth,0.04*kScreenWidth)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}



@end
