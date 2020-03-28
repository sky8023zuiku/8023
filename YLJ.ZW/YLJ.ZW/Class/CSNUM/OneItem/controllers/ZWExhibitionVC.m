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



@interface ZWExhibitionVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZWExhibitionListsCellDelegate,ZWTopSelectViewDelegate,ZWExhibitionDelayCellDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSMutableArray *titleBtns;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIButton *selectButton;
@property(nonatomic, assign)NSInteger cellType;//0为展会列表，1为计划列表

@property(nonatomic, strong)NSMutableArray *dataSource;//数据源
@property(nonatomic, assign)NSInteger page;//页数

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

@property (nonatomic, strong) ZWExhibitionListRequsetAction *action;

@property (nonatomic, strong) REFrostedViewController *frostedVC;

//@property(nonatomic, strong)NSMutableArray *conditions;//获取点击itme之后的值
//@property(nonatomic, strong)NSMutableArray *itemsIndex;//获取点击itme的索引
//@property(nonatomic, strong)NSString *industriesId;//行业id

@property(nonatomic, strong)NSArray *screenValues;

@end

@implementation ZWExhibitionVC

-(ZWExhibitionListRequsetAction *)action {
    if (!_action) {
        _action = [[ZWExhibitionListRequsetAction alloc]init];
    }
    return _action;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
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
//    [self getCountryRequest];
//    [self initArray];
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
    if (self.cellType == 0) {
        [self createArequestWithPage:self.page withParameter:dic];
    }else {
//        [self requestPianExhibitionList:dic withPage:self.page];
    }
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
        
//    ZWTopSelectView *selectView = [[ZWTopSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.08*kScreenWidth) withTitles:@[@"展会列表",@"计划列表"]];
//    selectView.delegate = self;
//    [self.view addSubview:selectView];
    
}
- (void)clickItemWithIndex:(NSInteger)index {
    if (index == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"user"];
        ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([user.uuid isEqualToString:@""]||!user.uuid) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
            [self yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:nil];
            return;
        }
    }
    NSLog(@"%ld",(long)index);
    self.cellType = index;
    self.page = 1;
    if (index == 0) {
        [self createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
    }else {
//        [self requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }
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
    
    if (self.cellType == 0) {
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
    }else {
        
        ZWExhPlanListModel *model = self.dataSource[indexPath.row];
        ZWPlansListCell *plansListCell = [[ZWPlansListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.28*kScreenWidth)];
        plansListCell.tag = indexPath.row;
        plansListCell.model = model;
        [cell.contentView addSubview:plansListCell];
        
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
    if (self.cellType == 0) {
        ZWExhibitionListModel *model = self.dataSource[indexPath.row];
        ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
        naviVC.hidesBottomBarWhenPushed = YES;
        naviVC.title = @"展会导航";
        naviVC.exhibitionId = model.listId;
        naviVC.price = model.price;
        [self.navigationController pushViewController:naviVC animated:YES];
    }else {
        ZWExhPlanListModel *model = self.dataSource[indexPath.row];
        ZWPlansDetailVC *detailVC = [[ZWPlansDetailVC alloc]init];
        detailVC.ID = model.ID;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
    self.cellType = 0;
    
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
        if (strongSelf.cellType == 0) {
            [strongSelf createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
        }else {
//            [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
        }
        
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        
        if (strongSelf.cellType == 0) {
            [strongSelf createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
        }else {
//            [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
        }
        
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
                [strongSelf removeBlankView];
            }
            NSArray *dataArr = data[@"data"];
            NSMutableArray *myArray =[NSMutableArray array];
            for (NSDictionary *myDic in dataArr) {
                ZWExhibitionListModel *model = [ZWExhibitionListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            if (strongSelf.dataSource.count == 0) {
               [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无展会" withType:1];
            }
            [strongSelf.tableView reloadData];
        }else {
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf removeBlankView];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [strongSelf.tableView reloadData];
        [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
    } showInView:self.view];
}
///**
// * 网络请求获取计划展会列表
//*/
//- (void)requestPianExhibitionList:(NSDictionary *)parametes withPage:(NSInteger)page {
//    __weak typeof (self) weakSelf = self;
//    [[ZWDataAction sharedAction]postReqeustWithURL:zwPlanExhibitionList parametes:[self takeParameters:parametes withPage:page] successBlock:^(NSDictionary * _Nonnull data) {
//        __weak typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//        if (zw_issuccess) {
//            if (page == 1) {
//                [strongSelf.dataSource removeAllObjects];
//            }
//            [strongSelf removeBlankView];
//            NSArray *myData = data[@"data"];
//            NSMutableArray *myArray = [NSMutableArray array];
//            for (NSDictionary *myDic in myData) {
//                ZWExhPlanListModel *model = [ZWExhPlanListModel parseJSON:myDic];
//                [myArray addObject:model];
//            }
//            [strongSelf.dataSource addObjectsFromArray:myArray];
//            if (strongSelf.dataSource.count == 0) {
//               [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无展会" withType:1];
//            }
//            [strongSelf.tableView reloadData];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//        __weak typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.dataSource removeAllObjects];
//        [strongSelf removeBlankView];
//        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf.tableView.mj_footer endRefreshing];
//        [strongSelf.tableView reloadData];
//        [strongSelf showBlankPagesWithImage:requestFailedBlankPagesImageName withDitail:@"当前网络异常，请检查网络" withType:2];
//    } showInView:self.view];
//}

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


- (void)removeBlankView {
    if (self.blankView) {
        [self.blankView removeFromSuperview];
        self.blankView = nil;
    }
}
- (void)showBlankPagesWithImage:(NSString *)imageName withDitail:(NSString *)ditail withType:(NSInteger)type {
    
    self.blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44)];
    [self.view addSubview:self.blankView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, 0.1*kScreenHeight, 0.8*kScreenWidth, 0.45*kScreenWidth)];
    imageView.image = [UIImage imageNamed:imageName];
    [self.blankView addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 30)];
    myLabel.text = ditail;
    myLabel.font = bigFont;
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:myLabel];
    
    if (type == 2) {
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadBtn.frame = CGRectMake(0.3*kScreenWidth, CGRectGetMaxY(myLabel.frame)+25, 0.4*kScreenWidth, 0.1*kScreenWidth);
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        reloadBtn.layer.borderColor = skinColor.CGColor;
        reloadBtn.titleLabel.font = normalFont;
        reloadBtn.layer.cornerRadius = 0.05*kScreenWidth;
        reloadBtn.layer.masksToBounds = YES;
        [reloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
        reloadBtn.layer.borderWidth = 1;
        [reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.blankView addSubview:reloadBtn];
    }
    
}
- (void)reloadBtnClick:(UIButton *)btn {
    if (self.cellType == 0) {
        [self createArequestWithPage:self.page withParameter:self.action.mj_keyValues];
    }else {
//        [self requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }
}

//*******************************************************抽屉****************************************************

- (void)rightItemClick:(UIBarButtonItem *)item {
    
    CSMenuViewController *menuVC = [[CSMenuViewController alloc]init];
    menuVC.screenType = 2;
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


@end
