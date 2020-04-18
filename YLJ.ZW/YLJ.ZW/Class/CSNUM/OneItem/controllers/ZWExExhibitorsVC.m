//
//  ZWExExhibitorsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExExhibitorsVC.h"
#import "ZWTopSelectView.h"
#import "ZWExhibitionMerchantCell.h"
#import "ZWEditExhibitionVC.h"
#import "ZWExExhibitorsModel.h"
#import "ZWIndustrysModel.h"
#import "UIViewController+YCPopover.h"
#import "ZWExhibitionBuyActionsheetVC.h"
#import "ZWBoothPictureVC.h"
#import "CSSearchVC.h"
#import <MBProgressHUD.h>
#import "ZWExExhibitorsDetailsVC.h"
@interface ZWExExhibitorsVC ()<ZWTopSelectViewDelegate,UITableViewDelegate,UITableViewDataSource,ZWExhibitionMerchantCellDelegate>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)ZWBaseEmptyTableView *rightTableView;
@property(nonatomic, assign)NSInteger selectType;

@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *industryArray;

@property(nonatomic, strong)NSDictionary *dataParameters;
@property(nonatomic, strong)NSString *industryId;
@property(nonatomic, strong)NSString *isNewExhibitor;

@property(nonatomic, assign)NSInteger isRreadAll;//0为不能读取全部 1为能读取全部

@property(nonatomic, assign)NSInteger exhibitorsType;//0为全部展商 1为新品展商（但存记录不牵扯的数据）

@property(nonatomic, strong)ZWTopSelectView *selectView;

@end

@implementation ZWExExhibitorsVC
-(UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.09*kScreenWidth, 0.2*kScreenWidth, kScreenHeight-zwNavBarHeight-0.09*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.sectionHeaderHeight = 0;
    _leftTableView.sectionFooterHeight = 0;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _leftTableView;
}
-(ZWBaseEmptyTableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0.09*kScreenWidth, 0.8*kScreenWidth, kScreenHeight-zwNavBarHeight-0.09*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.sectionHeaderHeight = 0;
    _rightTableView.sectionFooterHeight = 0;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _rightTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    
    self.page = 1;
    self.industryId = @"";
    self.isNewExhibitor = @"";
    
    [self createRequest];
    [self createRequestIndustry];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTheLeftList) name:@"refreshTheLeftList" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshTheLeftList" object:nil];
}
- (void)refreshTheLeftList {
    [self createRequest];
}
- (void)createRequest {
    self.dataParameters = @{@"exhibitionId":self.exhibitionId,
                            @"industryId":self.industryId,
                            @"isNewExhibitor":self.isNewExhibitor,
                            @"merchantName":@""};
    [self takeParametes:self.dataParameters takePageNo:self.page];
    [self refreshHeader];
    [self refreshFooter];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClcik:)];
}

- (void)rightItemClcik:(UIBarButtonItem *)item {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 6;
    searchVC.exhibitionId = self.dataParameters[@"exhibitionId"];
    searchVC.isRreadAll = self.isRreadAll;
    searchVC.price = self.price;
    searchVC.isAnimation = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = zwTableBackColor;
    self.selectType = 0;
    self.exhibitorsType = 0;
    self.isRreadAll = 0;
    self.dataSource = [NSMutableArray array];
    self.selectView = [[ZWTopSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.08*kScreenWidth) withTitles:@[@"全部展商",@"新品展商"]];
    self.selectView.delegate = self;
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}

-(void)clickItemWithIndex:(NSInteger)index {
//    NSLog(@"%ld",(long)index);
    self.page = 1;
    if (index == 0) {
        self.isNewExhibitor = @"";
        self.exhibitorsType = 0;
    }else {
        self.isNewExhibitor = @"1";
        self.exhibitorsType = 1;
    }
    [self createRequest];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return self.industryArray.count;
    }else {
        return self.dataSource.count;
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
    if (tableView == _leftTableView) {
        [self createLeftTableViewCell:cell cellForRowAtIndexPath:indexPath];
    }else {
        [self createRightTableViewCell:cell cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}
- (void)createLeftTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.13*kScreenWidth-1, 0.2*kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    ZWIndustrysModel *model = self.industryArray[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 0.2*kScreenWidth-16, 0.13*kScreenWidth-1)];
    titleLabel.text = model.industryName;
    titleLabel.font = smallMediumFont;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row == self.selectType) {
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
- (void)createRightTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.25*kScreenWidth-1, 0.8*kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    ZWExExhibitorsModel *model = self.dataSource[indexPath.row];
    model.selectType = self.selectType;
    model.exhibitorsType = self.exhibitorsType;
    model.JumpType = 0;
    model.isRreadAll = self.isRreadAll;
    ZWExhibitionMerchantCell *merchantCell = [[ZWExhibitionMerchantCell alloc]initWithFrame:CGRectMake(0, 0, 0.8*kScreenWidth, 0.25*kScreenWidth-1)];
    merchantCell.delegate = self;
    merchantCell.titleLabel.font = boldSmallMediumFont;
    merchantCell.mainBusiness.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.demandLabel.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.boothNumber.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
    merchantCell.tag = indexPath.row;
    merchantCell.model = model;
    [cell.contentView addSubview:merchantCell];

}

-(void)exhibitorsItemWithIndex:(ZWExhibitionMerchantCell *)cell withIndex:(NSInteger)index {
    ZWExExhibitorsModel *model = self.dataSource[index];
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
-(void)clickBtnWithIndex:(NSInteger)index {
    
    ZWExExhibitorsModel *model = self.dataSource[index];
    ZWBoothPictureVC *vc = [[ZWBoothPictureVC alloc]init];
    vc.imageUrl = model.expositionUrl;
    vc.title = @"展位图";
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 0.13*kScreenWidth;
    }else {
        return 0.25*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        self.selectType = indexPath.row;
        [self.leftTableView reloadData];
        ZWIndustrysModel *model = self.industryArray[indexPath.row];
        self.page = 1;
        self.industryId = model.industryId;
        [self createRequest];
    }else {
        if (self.isRreadAll == 0) {
            if (self.selectType == 0 && self.exhibitorsType == 0) {
                if (indexPath.row < 5) {
                    ZWExExhibitorsModel *model = self.dataSource[indexPath.row];
                    [self jumpToExExhibitorsDetails:model];
                }else {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    ZWExhibitionBuyActionsheetVC *actionsheetVC = [[ZWExhibitionBuyActionsheetVC alloc]init];
                    actionsheetVC.price = self.price;
                    actionsheetVC.exhibitionId = self.exhibitionId;
                    [self yc_bottomPresentController:actionsheetVC presentedHeight:0.8*kScreenWidth completeHandle:^(BOOL presented) {
                        if (presented) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }else {
                            
                        }
                    }];
                }
            }else {

                ZWExhibitionBuyActionsheetVC *actionsheetVC = [[ZWExhibitionBuyActionsheetVC alloc]init];
                actionsheetVC.price = self.price;
                actionsheetVC.exhibitionId = self.exhibitionId;
                [self yc_bottomPresentController:actionsheetVC presentedHeight:0.8*kScreenWidth completeHandle:^(BOOL presented) {
                    
                }];

            }
        }else {
            ZWExExhibitorsModel *model = self.dataSource[indexPath.row];
            [self jumpToExExhibitorsDetails:model];
        }
    }
}

- (void)jumpToExExhibitorsDetails:(ZWExExhibitorsModel *)model {
//    ZWEditExhibitionVC *exhibitionVC = [[ZWEditExhibitionVC alloc]init];
//    exhibitionVC.title = @"展商详情";
//    exhibitionVC.exhibitorId = model.exhibitorId;
//    exhibitionVC.enterType = 0;
//    [self.navigationController pushViewController:exhibitionVC animated:YES];
    
    ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
    detailsVC.title = @"展商详情";
//    detailsVC.exhibitorId = model.exhibitorId;
//    detailsVC.merchantId = model.merchantId;
    detailsVC.shareModel = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
//        [strongSelf createRequestWithParametes:strongSelf.dataParameters takePageNo:strongSelf.page];
        [strongSelf takeParametes:strongSelf.dataParameters takePageNo:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
//        [strongSelf createRequestWithParametes:strongSelf.dataParameters takePageNo:strongSelf.page];
        [strongSelf takeParametes:strongSelf.dataParameters takePageNo:strongSelf.page];
    }];
}

- (void)takeParametes:(NSDictionary *)parametes takePageNo:(NSInteger)page {
    NSDictionary *myparametes = @{@"exhibitionId":parametes[@"exhibitionId"],
                                @"industryId":parametes[@"industryId"],
                                @"isNewExhibitor":parametes[@"isNewExhibitor"],
                                @"merchantName":parametes[@"merchantName"],
                                @"pageQuery":@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                               @"pageSize":@"10"}};
    [self createRequestWithParametes:myparametes takePageNo:page];
}

- (void)createRequestWithParametes:(NSDictionary *)parametes takePageNo:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwExhibitionExhibitorList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.rightTableView.mj_header endRefreshing];
        [strongSelf.rightTableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            NSMutableArray *titlesArray = [NSMutableArray array];
            NSString *allNumText = [NSString stringWithFormat:@"全部展商(%@)",data[@"data"][@"allExhibitorSize"]];
            NSString *newNumText = [NSString stringWithFormat:@"新品展商(%@)",data[@"data"][@"newExhibitorSize"]];
            [titlesArray addObject:allNumText];
            [titlesArray addObject:newNumText];
            strongSelf.selectView.titles = titlesArray;
            NSArray *myData = data[@"data"][@"exhibitorList"];
            NSArray *myShareData = data[@"data"][@"shareList"];
            strongSelf.isRreadAll = [data[@"data"][@"isReadAll"] integerValue];
            NSMutableArray *myArray = [NSMutableArray array];
            
            NSMutableArray *myShareArray = [NSMutableArray array];
            
            for (NSDictionary *shareDic in myShareData) {
                ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:shareDic];
                [myShareArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myShareArray];
                        
            for (NSDictionary *myDic in myData) {
                ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.rightTableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)createRequestIndustry {
    NSDictionary *parametes;
    if (self.exhibitionId) {
        parametes = @{@"exhibitionId":self.exhibitionId};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhibitionExhibitorIndustryList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            ZWIndustrysModel *model = [ZWIndustrysModel alloc];
            model.industryId = @"";
            model.industryName = @"全部";
            model.listId = @"";
            model.exhibitionId = @"";
            [myArray addObject:model];
            for (NSDictionary *myDic in myData) {
                model = [ZWIndustrysModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.industryArray = myArray;
            [strongSelf.leftTableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
