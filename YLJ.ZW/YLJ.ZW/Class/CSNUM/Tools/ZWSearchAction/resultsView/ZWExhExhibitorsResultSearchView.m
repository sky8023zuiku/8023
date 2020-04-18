//
//  ZWExhExhibitorsResultSearchView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhExhibitorsResultSearchView.h"
#import "ZWExhibitionMerchantCell.h"
#import "ZWBoothPictureVC.h"
#import "ZWEditExhibitionVC.h"
#import "ZWExhibitionBuyActionsheetVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWExExhibitorsDetailsVC.h"
@interface ZWExhExhibitorsResultSearchView ()<UITableViewDelegate, UITableViewDataSource,ZWExhibitionMerchantCellDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;

@property (nonatomic, assign) BOOL isDoubleList;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *resultsText;

@end
@implementation ZWExhExhibitorsResultSearchView

- (instancetype)initWithFrame:(CGRect)frame withParameter:(id)obj {
    self = [super initWithFrame:frame];
    if (self) {
        _isDoubleList = YES;
        self.isRreadAll = obj[@"isRreadAll"];
        self.exhibitionId = obj[@"exhibitionId"];
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
    NSDictionary *myparametes = @{@"exhibitionId":self.exhibitionId,
                                  @"industryId":@"",
                                  @"isNewExhibitor":@"",
                                  @"merchantName":text,
                                  @"pageQuery":@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                                 @"pageSize":@"10"}};
   [self createRequestWithParametes:myparametes takePageNo:page];
}
- (void)createRequestWithParametes:(NSDictionary *)parametes takePageNo:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwExhibitionExhibitorList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.contentTableView.mj_header endRefreshing];
        [strongSelf.contentTableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"][@"exhibitorList"];
//            self.isRreadAll = data[@"data"][@"isReadAll"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.contentTableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self];
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
    
    ZWExExhibitorsModel *model = self.dataArray[indexPath.section];
    model.selectType = 1;
    model.exhibitorsType = 1;
    model.JumpType = 0;
    model.isRreadAll = [self.isRreadAll integerValue];
    ZWExhibitionMerchantCell *merchantCell = [[ZWExhibitionMerchantCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.25*kScreenWidth-1)];
    merchantCell.delegate = self;
    merchantCell.titleLabel.font = boldSmallMediumFont;
    merchantCell.tag = indexPath.row;
    merchantCell.model = model;
    [cell.contentView addSubview:merchantCell];
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.02*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count-1) {
        return 0.02*kScreenWidth;
    } else {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.isRreadAll);
    if ([self.isRreadAll isEqualToString:@"0"]) {
        ZWExhibitionBuyActionsheetVC *actionsheetVC = [[ZWExhibitionBuyActionsheetVC alloc]init];
        actionsheetVC.price = self.price;
        actionsheetVC.exhibitionId = self.exhibitionId;
        [self.ff_navViewController yc_bottomPresentController:actionsheetVC presentedHeight:0.5*kScreenHeight completeHandle:^(BOOL presented) {
            if (presented) {
                NSLog(@"弹出了");
            }else{
                NSLog(@"消失了");
            }
        }];
    } else {
        ZWExExhibitorsModel *model = self.dataArray[indexPath.row];
        ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
        detailsVC.title = @"展商详情";
        detailsVC.shareModel = model;
        [self.ff_navViewController pushViewController:detailsVC animated:YES];
    }
}

#pragma ZWExhibitionMerchantCellDelegate

-(void)clickBtnWithIndex:(NSInteger)index {
    ZWExExhibitorsModel *model = self.dataArray[index];
    ZWBoothPictureVC *vc = [[ZWBoothPictureVC alloc]init];
    vc.imageUrl = model.expositionUrl;
    vc.title = @"展位图";
    [self.ff_navViewController pushViewController:vc animated:YES];
}

-(void)exhibitorsItemWithIndex:(ZWExhibitionMerchantCell *)cell withIndex:(NSInteger)index {
    ZWExExhibitorsModel *model = self.dataArray[index];
    __block ZWExhibitionMerchantCell *myCell = cell;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhibitionExhibitorCollectionCancel parametes:@{@"exhibitorId":model.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSLog(@"%@",cell.collectionBtnBackImageName);
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    }];
}

@end
