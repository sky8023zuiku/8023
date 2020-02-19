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

@interface ZWMyCatalogueVC ()<UITableViewDelegate,UITableViewDataSource,ZWExhibitionListsCellDelegate,ZWExhibitionDelayCellDelegate>

@property (nonatomic, strong) ZspMenu *menu;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong)NSArray *countries;
@property(nonatomic, strong)NSArray *cities;
@property(nonatomic, strong)NSArray *industries;
@property(nonatomic, strong)NSArray *years;
@property(nonatomic, strong)NSArray *months;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@property (nonatomic, strong) UIButton *pickMenuBtn;
@property (nonatomic, strong) NSArray *mainKindArray;
@property (nonatomic, strong) NSMutableArray *subKindArray;

//@property (nonatomic, strong) NSMutableArray *countryModelArray;
//@property (nonatomic, strong) NSMutableArray *cityModelArray;
//@property (nonatomic, strong) NSMutableArray *industryModelArray;
//@property (nonatomic, strong) NSMutableArray *countryArray;
//@property (nonatomic, strong) NSMutableArray *cityArray;
//@property (nonatomic, strong) NSMutableArray *industryArray;

@property (nonatomic, strong) UIView *blankView;

//@property(nonatomic, strong)NSMutableArray *conditions;//获取点击itme之后的值
//@property(nonatomic, strong)NSMutableArray *itemsIndex;//获取点击itme的索引
//@property(nonatomic, strong)NSString *industriesId;//

@property(nonatomic, strong)NSArray *screenValues;//筛选数组

@property(nonatomic, strong)NSMutableDictionary *parametersDic;

@end

@implementation ZWMyCatalogueVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-zwNavBarHeight-44) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self createSearchBar];
//    self.page = 1;
//    [self createRequst:self.page];
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

    CSSearchBarStyle *searchBar = [[CSSearchBarStyle alloc] initWithFrame:CGRectMake(15, 5, CGRectGetWidth(searchView.frame)-30, 30)];
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.backgroundImage = [UIImage new];
    searchBar.showsCancelButton = NO;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        searchBar.searchTextField.enabled = NO;
        searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        searchBar.searchTextField.font = smallMediumFont;
        searchBar.layer.cornerRadius = 15.0f;
        searchBar.layer.masksToBounds = YES;
    }else {
        UITextField *searchField = [searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.enabled = NO;
        searchField.font = smallMediumFont;
        searchField.layer.cornerRadius = 15.0f;
        searchField.layer.masksToBounds = YES;
    }
    
    [searchView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    [searchView addSubview:self.searchBar];
    CGFloat height = searchBar.bounds.size.height;
    CGFloat top = (height - 30.0) / 2.0;
    CGFloat bottom = top;
    searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItemClick:)];
    [self.searchBar addGestureRecognizer:tap];
    
}
- (void)tapItemClick:(UITapGestureRecognizer *)recognizer {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 3;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {

    CSMenuViewController *menuVC = [[CSMenuViewController alloc]init];
    menuVC.screenType = 3;
    menuVC.screenValues = self.screenValues;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:menuVC];
    REFrostedViewController *frostedVC= [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:navC];
    frostedVC.direction = REFrostedViewControllerDirectionRight;
    frostedVC.limitMenuViewSize = kScreenWidth/3*2;
    frostedVC.animationDuration = 0.2;
    frostedVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    self.view.window.rootViewController = frostedVC;
    [self.frostedViewController presentMenuViewController];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
                ZWExhibitionListModel *model = [ZWExhibitionListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
            if (strongSelf.dataSource.count == 0) {
                [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无展会" withType:1];
            }
        }else {
            NSLog(@"%@",respense.data);
//            [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
        }
    }];
}
- (void)removeBlankView {
    if (self.blankView) {
        [self.blankView removeFromSuperview];
        self.blankView = nil;
    }
}
- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    
    self.blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44)];
    [self.view addSubview:self.blankView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.1*kScreenHeight, 0.8*kScreenWidth, 0.5*kScreenWidth)];
    imageView.image = [UIImage imageNamed:imageName];
    [self.blankView addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 30)];
    myLabel.text = ditail;
    myLabel.font = bigFont;
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:myLabel];
    
//    if (type == 2) {
//        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        reloadBtn.frame = CGRectMake(0.3*kScreenWidth, CGRectGetMaxY(myLabel.frame)+25, 0.4*kScreenWidth, 0.1*kScreenWidth);
//        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//        reloadBtn.layer.borderColor = skinColor.CGColor;
//        reloadBtn.titleLabel.font = normalFont;
//        reloadBtn.layer.cornerRadius = 0.05*kScreenWidth;
//        reloadBtn.layer.masksToBounds = YES;
//        [reloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
//        reloadBtn.layer.borderWidth = 1;
//        [reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.blankView addSubview:reloadBtn];
//    }
    
}
     
@end
