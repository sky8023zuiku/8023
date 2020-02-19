//
//  ZWExhibitorsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsVC.h"
#import "ZWTopSelectView.h"
#import "ZWIndustryMerchantCell.h"
#import "ZWCompanyDetailsVC.h"
#import "ZWInduExhibitorsModel.h"
#import "ZWExhibitorIndustryModel.h"
#import "CSSearchVC.h"

#import "REFrostedViewController.h"

#import "ZWExhibitorsDetailsVC.h"
#import "CSMenuViewController.h"
#import "ZWSaveIndustryScreenList.h"

@interface ZWExhibitorsVC ()<ZWTopSelectViewDelegate,UITableViewDelegate,UITableViewDataSource,ZWIndustryMerchantCellDelegate>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)UITableView *rightTableView;
@property(nonatomic, assign)NSInteger selectType;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSArray *industrys;
@property(nonatomic, strong)NSString *leftListId;

@property(nonatomic, assign)NSInteger isNewMerchant;

@property(nonatomic, strong)NSArray *screenValues;

//@property(nonatomic, strong)NSMutableArray *conditions;//获取点击itme之后的值
//@property(nonatomic, strong)NSMutableArray *itemsIndex;//获取点击itme的索引

@property(nonatomic, strong)NSString *industriesId;
@property(nonatomic, strong)NSString *countries;
@property(nonatomic, strong)NSString *cities;

@end

@implementation ZWExhibitorsVC

-(UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.08*kScreenWidth, 0.2*kScreenWidth, kScreenHeight-zwNavBarHeight-zwTabBarHeight-0.08*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.sectionHeaderHeight = 0;
    _leftTableView.sectionFooterHeight = 0;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _leftTableView;
}

-(UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0.08*kScreenWidth, 0.8*kScreenWidth, kScreenHeight-zwNavBarHeight-zwTabBarHeight-0.08*kScreenWidth) style:UITableViewStyleGrouped];
    }
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.sectionHeaderHeight = 0;
    _rightTableView.sectionFooterHeight = 0;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _rightTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self refreshData];
    [self refreshHeader];
    [self refreshFooter];
    [self createScreening];
    [self createNotice];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeDrawerValue:) name:@"takeExhibitorsDrawerValue" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshExhibitorsPageData:) name:@"refreshExhibitorsPageData" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"takeExhibitorsDrawerValue" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshExhibitorsPageData" object:nil];
}
- (void)takeDrawerValue:(NSNotification *)notice {

    NSLog(@"----%@",notice.object);
    NSArray *myArray = notice.object;
    self.screenValues = myArray;
    
    self.industriesId = myArray[0][@"myId"];
    self.countries = myArray[1][@"name"];
    self.cities = myArray[2][@"name"];
    self.leftListId = @"";
    self.selectType = 0;
    [self createRequest:1];
    
}

- (void)refreshExhibitorsPageData:(NSNotification *)notice {
    self.page = 1;
    self.leftListId = @"";
    self.isNewMerchant = 0;
    self.selectType = 0;
    [self createRequest:self.page];
}


- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"zai_icon_shaixuan"] barItem:self.navigationItem target:self action:@selector(showMenu:)];
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"search_icon"] barItem:self.navigationItem target:self action:@selector(leftItemClick:)];
}
- (void)leftItemClick:(UIBarButtonItem *)item {

    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 5;
    [self.navigationController pushViewController:searchVC animated:YES];

}
- (void)showMenu:(UIBarButtonItem *)item {
    CSMenuViewController *menuVC = [[CSMenuViewController alloc]init];
    menuVC.screenType = 1;
//    menuVC.conditions = self.conditions;
//    menuVC.itemsIndex = self.itemsIndex;
//    menuVC.industriesId = self.industriesId;
    
    menuVC.screenValues = self.screenValues;
    
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:menuVC];
    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:navC];
    frostedVC.direction = REFrostedViewControllerDirectionRight;
    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
    frostedVC.animationDuration = 0.2;
    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    self.view.window.rootViewController = frostedVC;
    [self.frostedViewController presentMenuViewController];
}

- (void)createUI {
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"行业展商";
    self.dataSource = [NSMutableArray array];
    ZWTopSelectView *selectView = [[ZWTopSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.08*kScreenWidth) withTitles:@[@"全部展商",@"新品展商"]];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.delegate = self;
    [self.view addSubview:selectView];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];

}
-(void)clickItemWithIndex:(NSInteger)index {
    self.page = 1;
    self.isNewMerchant = index;
    [self createRequest:self.page];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return self.industrys.count;
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

//    NSArray *titles = @[@"滤清器",@"概念汽车汽车汽汽车汽",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车",@"酷炫跑车"];
    ZWExhibitorIndustryModel *model = self.industrys[indexPath.row];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 0.2*kScreenWidth-23, 0.13*kScreenWidth-1)];
    titleLabel.text = model.name;
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
    
    ZWInduExhibitorsModel *model = self.dataSource[indexPath.row];
    ZWIndustryMerchantCell *merchantCell = [[ZWIndustryMerchantCell alloc]initWithFrame:CGRectMake(0, 0, 0.8*kScreenWidth, 0.25*kScreenWidth-1)];
    merchantCell.titleLabel.font = smallMediumFont;
    merchantCell.mainBusiness.font = smallMediumFont;
    merchantCell.demandLabel.font = smallMediumFont;
    merchantCell.tag = indexPath.row;
    merchantCell.showModel = model;
    merchantCell.delegate = self;
    [cell.contentView addSubview:merchantCell];
    
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
    return 0.01*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        self.selectType = indexPath.row;
        [self.leftTableView reloadData];
        ZWExhibitorIndustryModel *model = self.industrys[indexPath.row];
        self.page = 1;
        self.leftListId = model.listId;
        [self createRequest:self.page];
    }else {
        ZWInduExhibitorsModel *model = self.dataSource[indexPath.row];
        ZWExhibitorsDetailsVC *detailsVC = [[ZWExhibitorsDetailsVC alloc]init];
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.title = @"展商详情";
        detailsVC.merchantId = model.merchantId;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequest:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:self.page];
    }];
}

- (void)refreshData {
    NSDictionary *myDic = @{@"myId":@"",@"name":@""};
    self.screenValues = @[myDic,myDic,myDic];
    self.leftListId = @"";
    self.cities = self.screenValues[2][@"name"];
    self.countries = self.screenValues[1][@"name"];
    self.industriesId = self.screenValues[0][@"myId"];
    self.selectType = 0;
    
    self.page = 1;
    self.isNewMerchant = 0;
    [self createRequest:self.page];
}


- (NSDictionary *)takeParametes:(NSInteger)page {
    NSDictionary *parametes = @{@"baseIndustryId":self.industriesId,
                                @"industryId":self.leftListId,
                                @"name":@"",
                                @"city":self.cities,
                                @"country":self.countries,
                                @"isNewMerchant":[NSString stringWithFormat:@"%ld",(long)self.isNewMerchant],
                                @"pageQuery":@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                               @"pageSize":@"10"}};
    return parametes;
}

- (void)createRequest:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    __block NSDictionary *myParametes = [self takeParametes:page];
    [[ZWDataAction sharedAction]postReqeustWithURL:zwIndustryExhibitorsList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.rightTableView.mj_header endRefreshing];
        [strongSelf.rightTableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            
            NSArray *myData = data[@"data"][@"merchantList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWInduExhibitorsModel *model = [ZWInduExhibitorsModel parseJSON:myDic];
                [myArray addObject:model];
            }
            
            [strongSelf.dataSource addObjectsFromArray:myArray];
            
            NSArray *myIndustries = data[@"data"][@"industryVos"];
            
            NSString *titleStr = data[@"data"][@"title"];
            if ([titleStr isEqualToString:@""]) {
//                self.title = @"行业展商";
                self.navigationItem.title = @"行业展商";
            }else {
//                self.title = [NSString stringWithFormat:@"行业展商(%@)",titleStr];
                self.navigationItem.title = [NSString stringWithFormat:@"行业展商(%@)",titleStr];
            }
            NSString *baseIndustryId = [NSString stringWithFormat:@"%@",myParametes[@"industryId"]];
            
            if ([baseIndustryId isEqualToString:@""]) {
                [[ZWSaveIndustryScreenList shareAction]saveIndustriesListData:myIndustries];
                [self takeMyLevel3Industries];
            }
            [strongSelf.leftTableView reloadData];
            [strongSelf.rightTableView reloadData];
            
        }
    } failureBlock:^(NSError * _Nonnull error) {

    }showInView:self.view];
}

- (void)takeMyLevel3Industries {
    NSArray *myArray = [[ZWSaveIndustryScreenList shareAction]takeLevel3Industries];
    NSMutableArray *myIndArray = [NSMutableArray array];
    ZWExhibitorIndustryModel *model = [ZWExhibitorIndustryModel alloc];
    model.listId = @"";
    model.name = @"全部";
    [myIndArray addObject:model];
    for (NSDictionary *myDic in myArray) {
        ZWExhibitorIndustryModel *model = [ZWExhibitorIndustryModel parseJSON:myDic];
        [myIndArray addObject:model];
    }
    self.industrys = myIndArray;
}


-(void)industryCancelTheCollection:(ZWIndustryMerchantCell *)cell withIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    ZWInduExhibitorsModel *model = self.dataSource[index];
    [[ZWDataAction sharedAction]getReqeustWithURL:zwInduExhibitorsCollectionAndCancel parametes:@{@"merchantId":model.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            ZWIndustryMerchantCell *myCell = cell;
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
}

- (void)createScreening {
//    __weak typeof (self) weakSelf = self;
//    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeLevel3IndustriesList parametes:@{@"ParentId":@""} successBlock:^(NSDictionary * _Nonnull data) {
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        if (zw_issuccess) {
//            NSArray *myData = data[@"data"][@"industryVos"];
//            NSMutableArray *myArray = [NSMutableArray array];
//            ZWExhibitorIndustryModel *model = [ZWExhibitorIndustryModel alloc];
//            model.listId = @"";
//            model.name = @"全部";
//            [myArray addObject:model];
//            for (NSDictionary *myDic in myData) {
//                ZWExhibitorIndustryModel *model = [ZWExhibitorIndustryModel parseJSON:myDic];
//                [myArray addObject:model];
//            }
//            strongSelf.industrys = myArray;
//            [strongSelf.leftTableView reloadData];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//
//    } showInView:self.view];
}

@end
