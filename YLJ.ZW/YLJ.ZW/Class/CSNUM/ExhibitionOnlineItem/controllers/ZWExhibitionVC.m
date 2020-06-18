//
//  ZWExhibitionVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionVC.h"
//#import "ZWMyCatalogueCell.h"
#import "CSSearchBarStyle.h"
#import "UIView+MJExtension.h"
#import "ZWTopSelectView.h"
#import "ZWPlansListCell.h"
#import "ZWExhibitionNaviVC.h"
#import "ZWPlansDetailVC.h"

#import "ZWExhibitionListsCell.h"

#import "ZWMineResponse.h"
#import "CSSearchVC.h"

#import "ZWMineRqust.h"

//#import "ZWGetCountryRequest.h"
//#import "ZWGetCityRequest.h"
//#import "ZWGetIndustryRequest.h"

#import "ZWExhibitionListRequsetAction.h"
#import "ZWExhPlanListModel.h"
#import "ZWMainLoginVC.h"
#import "UIViewController+YCPopover.h"

#import "REFrostedViewController.h"
#import "CSMenuViewController.h"

#import "ZWExhibitionDelayCell.h"

#import "CSFilterManager.h"


@interface ZWExhibitionVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZWExhibitionListsCellDelegate,ZWExhibitionDelayCellDelegate,CSFilterManagerDelegate>

@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSMutableArray *titleBtns;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIButton *selectButton;
//@property(nonatomic, assign)NSInteger cellType;//0为展会列表，1为计划列表

@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@property(nonatomic, assign)NSInteger page;//页数

@property (nonatomic, strong) UIButton *pickMenuBtn;
@property (nonatomic, strong) NSArray *mainKindArray;
@property (nonatomic, strong) NSMutableArray *subKindArray;

@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) ZWExhibitionListRequsetAction *action;
@property (nonatomic, strong) REFrostedViewController *frostedVC;

@property(nonatomic, strong)NSArray *screenValues;

@property(nonatomic, strong)NSDictionary *selectDictionary;

@end

@implementation ZWExhibitionVC

-(ZWExhibitionListRequsetAction *)action {
    if (!_action) {
        _action = [[ZWExhibitionListRequsetAction alloc]init];
    }
    return _action;
}

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createSearchBar];
    [self createRequest];
    [self createNotice];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeExhibitionDrawerValue:) name:@"takeExhibitionDrawerValue" object:nil];
}

- (void)takeExhibitionDrawerValue:(NSNotification *)notice {
    
    self.screenValues = notice.object;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:notice.object[0][@"name"] forKey:@"country"];
    [dic setValue:notice.object[1][@"name"] forKey:@"city"];
    [dic setValue:notice.object[2][@"myId"] forKey:@"industryId"];
    [dic setValue:notice.object[3][@"name"] forKey:@"yearTime"];
    [dic setValue:notice.object[4][@"name"] forKey:@"monthTime"];
    
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:dic];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"takeExhibitionDrawerValue" object:nil];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"zai_icon_shaixuan"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
        
}


#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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
    
    ZWExhibitionListModel *model = self.dataSource[indexPath.row];
    
    if ([model.developingState isEqualToString:@"1"]) {
        
        ZWExhibitionDelayCell *delayCell = [[ZWExhibitionDelayCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
        delayCell.delegate = self;
        delayCell.model = model;
        delayCell.collectionBtn.tag = indexPath.row;
        [cell.contentView addSubview:delayCell];
        
    }else {
        
        ZWExhibitionListsCell *exhibitionCell = [[ZWExhibitionListsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
        exhibitionCell.delegate = self;
        exhibitionCell.model = model;
        exhibitionCell.collectionBtn.tag = indexPath.row;
        [cell.contentView addSubview:exhibitionCell];
        
    }

}

#pragma ZWMyCatalogueCellDelegate
-(void)collectionItemWithIndex:(ZWExhibitionListsCell *)cell withIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    ZWExhibitionListModel *model = self.dataSource[index];
    NSDictionary *parametes;
    if (model.listId) {
        parametes = @{@"exhibitionId":model.listId};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCollectionAndCancelExhibition parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            ZWExhibitionListsCell *myCell = cell;
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }else {
            [strongSelf showOneAlertWith:@"操作失败"];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
}

-(void)collectionItemWithCell:(ZWExhibitionDelayCell *)cell withIndex:(NSInteger)index {
    
    NSLog(@"%ld",(long)index);
    ZWExhibitionListModel *model = self.dataSource[index];
    NSDictionary *parametes;
    if (model.listId) {
        parametes = @{@"exhibitionId":model.listId};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCollectionAndCancelExhibition parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            ZWExhibitionDelayCell *myCell = cell;
            if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
            }else {
                myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
            }
            [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
        }else {
            [strongSelf showOneAlertWith:@"操作失败"];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExhibitionListModel *model = self.dataSource[indexPath.row];
    if ([model.developingState isEqualToString:@"1"]) {
        return 0.32*kScreenWidth;
    }else {
        return 0.28*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count-1) {
        return 0.01*kScreenWidth;
    } else {
        return 0.1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([user.uuid isEqualToString:@""]||!user.uuid) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
        [self yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:nil];
        return;
    }
    ZWExhibitionListModel *model = self.dataSource[indexPath.row];
    NSDictionary *shareData = @{
        @"exhibitionId":model.listId,
        @"exhibitionName":model.name,
        @"exhibitionTitleImage":model.imageUrl
    };
    ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
    naviVC.hidesBottomBarWhenPushed = YES;
    naviVC.title = @"展会导航";
    naviVC.exhibitionId = model.listId;
    naviVC.price = model.price;
    naviVC.shareData = shareData;
    [self.navigationController pushViewController:naviVC animated:YES];
}

- (void)createSearchBar{
    
    ZWSearchBar *searchBar = [[ZWSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchBar.layer.masksToBounds = YES;
    self.navigationItem.titleView = searchBar;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.isFirstResponser = NO;
    searchBar.isShowRightBtn = YES;
    searchBar.iconName = @"icon_search";
    searchBar.iconSize = CGSizeMake(15, 15);
    searchBar.insetsIcon = UIEdgeInsetsMake(0, 13, 0, 0);
    searchBar.placeHolder = @"请输入要搜索的内容";
    searchBar.cusFontPlaceHolder = 20;
    searchBar.colorSearchBg = [UIColor whiteColor];
    searchBar.raidus = 14;
    searchBar.insetsSearchBg = UIEdgeInsetsMake(8, 0, 8, 0);
    searchBar.cusFontTxt = 14;
    searchBar.colorTxtInput = [UIColor redColor];
    searchBar.isEditable = NO;
    searchBar.colorTitleBtn = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItemClick:)];
    [searchBar.txtField addGestureRecognizer:tap];
    
}

- (void)tapItemClick:(UITapGestureRecognizer *)recognizer {
    
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 4;
    searchVC.hidesBottomBarWhenPushed = YES;
    searchVC.isAnimation = 0;
    [self.navigationController pushViewController:searchVC animated:NO];
    
}

- (void)showOneAlertWith:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

- (void)createRequest {
    
    NSDictionary *myDic = @{@"myId":@"",@"name":@""};
    self.screenValues = @[myDic,myDic,myDic,myDic,myDic];
    
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
    }];
}

/**
 * 网络请求获取在线展会列表
*/
- (void)createArequestWithPage:(NSInteger)page withParameter:(NSDictionary *)dic {
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwOnlineExhibitionList parametes:[self takeParameters:dic withPage:page] successBlock:^(NSDictionary * _Nonnull data) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            NSArray *dataArr = data[@"data"];
            NSMutableArray *myArray =[NSMutableArray array];
            for (NSDictionary *myDic in dataArr) {
                ZWExhibitionListModel *model = [ZWExhibitionListModel mj_objectWithKeyValues:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }else {
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    } showInView:self.view];
}

-(NSDictionary *)takeParameters:(NSDictionary *)dic withPage:(NSInteger)page  {
    self.action.city = dic[@"city"];
    self.action.country = dic[@"country"];
    self.action.industryId = dic[@"industryId"];
    self.action.monthTime = dic[@"monthTime"];
    self.action.yearTime = dic[@"yearTime"];
    self.action.pageQuery = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                              @"pageSize":@"10"};
    return self.action.mj_keyValues;
}

//*******************************************************抽屉****************************************************

- (void)rightItemClick:(UIBarButtonItem *)item {
    
    [[CSFilterManager shareManager]showFilterMenu:self setSelectedData:self.selectDictionary];
    [CSFilterManager shareManager].delegate = self;
    
}

- (void)takeFilterData:(NSDictionary *)data {
    self.selectDictionary = data;
    NSLog(@"%@",self.selectDictionary);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:data[@"country"][@"name"] forKey:@"country"];
    [dic setValue:data[@"city"][@"name"] forKey:@"city"];
    [dic setValue:data[@"industry"][@"id"] forKey:@"industryId"];
    [dic setValue:data[@"year"][@"name"] forKey:@"yearTime"];
    [dic setValue:data[@"month"][@"name"] forKey:@"monthTime"];
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:dic];
}

@end
