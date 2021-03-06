//
//  ZWMyCatalogueVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyCatalogueVC.h"
#import "CSSearchVC.h"
#import "ZspMenu.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>
#import "CSSearchBarStyle.h"

#import "ZWExhibitionListsCell.h"

#import "ZWExhibitionNaviVC.h"

#import "CSMenuViewController.h"
#import "ZWExhibitionDelayCell.h"

#import "CSFilterManager.h"

@interface ZWMyCatalogueVC ()<UITableViewDelegate,UITableViewDataSource,ZWExhibitionListsCellDelegate,ZWExhibitionDelayCellDelegate,ZspMenuDelegate,ZspMenuDataSource,CSFilterManagerDelegate>

@property (nonatomic, strong) ZspMenu *menu;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong)NSArray *countries;
@property(nonatomic, strong)NSArray *cities;
@property(nonatomic, strong)NSArray *industries;
@property(nonatomic, strong)NSArray *years;
@property(nonatomic, strong)NSArray *months;

@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@property (nonatomic, strong) UIButton *pickMenuBtn;
@property (nonatomic, strong) NSArray *mainKindArray;
@property (nonatomic, strong) NSMutableArray *subKindArray;

@property (nonatomic, strong) UIView *blankView;

@property(nonatomic, strong)NSArray *screenValues;//筛选数组

@property(nonatomic, strong)NSMutableDictionary *parametersDic;

@property(nonatomic, strong)NSDictionary *selectedDictionary;

@end

@implementation ZWMyCatalogueVC
-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-zwNavBarHeight-44) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}


- (ZspMenu *)menu {
    if (!_menu) {
        _menu = [[ZspMenu alloc]initWithOrigin:CGPointMake(0, 40) andHeight:40];
    }
    _menu.delegate = self;
    _menu.dataSource = self;
    return _menu;
}

//每个column有多少行
- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return 90;
}
//每个column中每行的title
- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    NSArray *array = @[@"城市",@"年份",@"月份",@"二级",@"三级"];
    return array[indexPath.column];
}

//有多少个column，默认为1列
- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    return 5;
}
//第column列，没行的image
- (NSString *)menu:(ZspMenu *)menu imageNameForRowAtIndexPath:(ZspIndexPath *)indexPath {
    return nil;
}
////detail text
//- (NSString *)menu:(ZspMenu *)menu detailTextForRowAtIndexPath:(ZspIndexPath *)indexPath {
//    return @"详情";
//}
//某列的某行item的数量，如果有，则说明有二级菜单，反之亦然
- (NSInteger)menu:(ZspMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        return 10;
    }else {
        return 0;;
    }
}
//如果有二级菜单，则实现下列协议
//二级菜单的标题
- (NSString *)menu:(ZspMenu *)menu titleForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    return @"城市";
}
//二级菜单的image
- (NSString *)menu:(ZspMenu *)menu imageForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    return nil;
}
//二级菜单的detail text
//- (NSString *)menu:(ZspMenu *)menu detailTextForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
//    return @"1111";
//}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createNavigationBar];
    [self createSearchBar];
    [self refreshData];
    [self refreshHeader];
    [self refreshFooter];
    [self createNotice];
    
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeExhibitionDrawerValue:) name:@"takeMyExhibitionDrawerValue" object:nil];
}
- (void)takeExhibitionDrawerValue:(NSNotification *)notice {
    
    self.parametersDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.parametersDic setValue:notice.object[0][@"name"] forKey:@"country"];
    [self.parametersDic setValue:notice.object[1][@"name"] forKey:@"city"];
    [self.parametersDic setValue:notice.object[2][@"myId"] forKey:@"industryId"];
    [self.parametersDic setValue:notice.object[3][@"name"] forKey:@"yearTime"];
    [self.parametersDic setValue:notice.object[4][@"name"] forKey:@"monthTime"];
    
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:self.parametersDic];
   
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"takeMyExhibitionDrawerValue" object:nil];
}
   
- (void)takeFilterParameters:(NSNotification *)nitce {
    
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"zai_icon_shaixuan"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
    
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createArequestWithPage:strongSelf.page withParameter:strongSelf.parametersDic];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createArequestWithPage:strongSelf.page withParameter:strongSelf.parametersDic];
    }];
}

- (void)refreshData {
    NSDictionary *myDic = @{@"myId":@"",@"name":@""};
    self.screenValues = @[myDic,myDic,myDic,myDic,myDic];

    self.parametersDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.parametersDic setValue:self.screenValues[0][@"name"] forKey:@"country"];
    [self.parametersDic setValue:self.screenValues[1][@"name"] forKey:@"city"];
    [self.parametersDic setValue:self.screenValues[2][@"myId"] forKey:@"industryId"];
    [self.parametersDic setValue:self.screenValues[3][@"name"] forKey:@"yearTime"];
    [self.parametersDic setValue:self.screenValues[4][@"name"] forKey:@"monthTime"];
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:self.parametersDic];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.menu];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
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
    if (self.dataSource.count != 0) {
        ZWExhibitionListModel *model = self.dataSource[indexPath.section];
        
        if ([model.developingState isEqualToString:@"1"]) {
            ZWExhibitionDelayCell *delayCell = [[ZWExhibitionDelayCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
            delayCell.delegate = self;
            delayCell.model = model;
            delayCell.collectionBtn.tag = indexPath.section;
            [cell.contentView addSubview:delayCell];
        }else {
            ZWExhibitionListsCell *exhibitionCell = [[ZWExhibitionListsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
            exhibitionCell.model = model;
            exhibitionCell.delegate = self;
            exhibitionCell.collectionBtn.tag = indexPath.section;
            [cell.contentView addSubview:exhibitionCell];
        }
        
        
    }
}
#pragma ZWExhibitionListsCellDelegate
-(void)collectionItemWithIndex:(ZWExhibitionListsCell *)cell withIndex:(NSInteger)index; {
    NSLog(@"%ld",(long)index);
    ZWExhibitionListModel *model = self.dataSource[index];
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
#pragma ZWExhibitionDelayCellDelegate
-(void)collectionItemWithCell:(ZWExhibitionDelayCell *)cell withIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
    ZWExhibitionListModel *model = self.dataSource[index];
    ZWCancelCollectionRequst *requst = [[ZWCancelCollectionRequst alloc]init];
    requst.exhibitionId = model.listId;
    __block ZWExhibitionDelayCell *myCell = cell;
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
    
    ZWExhibitionListModel *model = self.dataSource[indexPath.section];
    if ([model.developingState isEqualToString:@"1"]) {
        return 0.32*kScreenWidth;
    }else {
        return 0.28*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count-1 ) {
        return 0.01*kScreenWidth;
    } else {
        return 0.1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExhibitionNaviVC *vc = [[ZWExhibitionNaviVC alloc]init];
    ZWExhibitionListModel *model = self.dataSource[indexPath.row];
    vc.exhibitionId = model.listId;
    vc.title = @"展会导航";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)createSearchBar{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchView.backgroundColor = skinColor;
    [self.view addSubview:searchView];

    ZWSearchBar *searchBar = [[ZWSearchBar alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 44)];
    searchBar.layer.masksToBounds = YES;
    [searchView addSubview:searchBar];
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
    searchVC.type = 3;
    searchVC.isAnimation = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {

//    CSMenuViewController *menuVC = [[CSMenuViewController alloc]init];
//    menuVC.screenType = 3;
//    menuVC.screenValues = self.screenValues;
//    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:menuVC];
//    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:navC];
//    frostedVC.direction = REFrostedViewControllerDirectionRight;
//    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
//    frostedVC.animationDuration = 0.2;
//    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
//    self.view.window.rootViewController = frostedVC;
//    [self.frostedViewController presentMenuViewController];
//
    
    [[CSFilterManager shareManager]showFilterMenu:self setSelectedData:self.selectedDictionary];
    [CSFilterManager shareManager].delegate = self;
    self.tabBarController.tabBar.hidden = YES;
        
}
- (void)takeFilterData:(NSDictionary *)data {
    NSLog(@"%@",data);
    self.selectedDictionary = data;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:data[@"country"][@"name"] forKey:@"country"];
    [dic setValue:data[@"city"][@"name"] forKey:@"city"];
    [dic setValue:data[@"industry"][@"id"] forKey:@"industryId"];
    [dic setValue:data[@"year"][@"name"] forKey:@"yearTime"];
    [dic setValue:data[@"month"][@"name"] forKey:@"monthTime"];
    self.page = 1;
    [self createArequestWithPage:self.page withParameter:dic];
}

- (void)createArequestWithPage:(NSInteger)page withParameter:(NSDictionary *)dic {
    NSLog(@"我的页数%ld",(long)page);
    ZWMyCatalogueListRequst *requst = [[ZWMyCatalogueListRequst alloc]init];
    requst.pageQuery = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"7"};
    requst.country = dic[@"country"];
    requst.city = dic[@"city"];
    requst.yearTime = dic[@"yearTime"];
    requst.monthTime = dic[@"monthTime"];
    requst.industryId = dic[@"industryId"];
    __weak typeof (self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            if (page == 1) {
                [strongSelf removeBlankView];
                [strongSelf.dataSource removeAllObjects];
            }
            NSLog(@"%@",respense.data);
            NSArray *dataArr = respense.data;
            NSMutableArray *myArray =[NSMutableArray array];
            for (NSDictionary *myDic in dataArr) {
                ZWExhibitionListModel *model = [ZWExhibitionListModel mj_objectWithKeyValues:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
            
        }else {
            
        }
    }];
}
- (void)removeBlankView {
    if (self.blankView) {
        [self.blankView removeFromSuperview];
        self.blankView = nil;
    }
}
@end
