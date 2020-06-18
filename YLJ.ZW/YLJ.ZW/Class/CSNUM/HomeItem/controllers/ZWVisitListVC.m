//
//  ZWVisitListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/6.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWVisitListVC.h"
#import "ZWPlansListCell.h"
#import "ZWPlansDetailVC.h"
#import "ZWExhibitionListRequsetAction.h"

#import "CSMenuViewController.h"
#import "CSSearchVC.h"
#import "ZWImageBrowser.h"
#import "ZWAnnouncementVC.h"
#import "ZWPlanDelayCell.h"

#import "DFSegmentView.h"

#import "ZWBaseEmptyTableView.h"

@interface ZWVisitListVC ()<UITableViewDataSource,UITableViewDelegate,ZWPlansListCellDelegate,ZWPlanDelayCellDelegate,DFSegmentViewDelegate>
@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) ZWExhibitionListRequsetAction *action;
@property (nonatomic, strong)NSArray *screenValues;

@property (nonatomic, strong)DFSegmentView *segmentYear;
@property (nonatomic, strong)DFSegmentView *segmentMonth;

@property (nonatomic, strong)NSMutableDictionary *parameterDic;

@end

@implementation ZWVisitListVC

-(ZWExhibitionListRequsetAction *)action {
    if (!_action) {
        _action = [[ZWExhibitionListRequsetAction alloc]init];
    }
    return _action;
}

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth+5, kScreenWidth, kScreenHeight-zwNavBarHeight-0.15*kScreenWidth) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0 );
    return _tableView;
}

-(NSMutableDictionary *)parameterDic {
    if (!_parameterDic) {
        _parameterDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _parameterDic;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[YNavigationBar sharedInstance]createSkinNavigationBar:self.navigationController.navigationBar withBackColor:skinColor withTintColor:[UIColor whiteColor]];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takePlanScreenValue:) name:@"takePlanScreenDrawerValue" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"takePlanScreenDrawerValue" object:nil];
}
- (void)takePlanScreenValue:(NSNotification *)notice {
    
    self.screenValues = notice.object;
    [self.parameterDic setValue:notice.object[0][@"myId"] forKey:@"industryId"];
    [self.parameterDic setValue:notice.object[1][@"name"] forKey:@"country"];
    [self.parameterDic setValue:notice.object[2][@"name"] forKey:@"city"];
    [self createPianExhibitionList:self.parameterDic];
    
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    
    [self createTopScreen];

    [self.view addSubview:self.tableView];
}

- (void)createTopScreen {
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth; //月份
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSLog(@"%ld-%ld",(long)year,(long)month);
    NSArray *years = @[[NSString stringWithFormat:@"%ld年",(year-1)],
                       [NSString stringWithFormat:@"%ld年",year],
                       [NSString stringWithFormat:@"%ld年",(year+1)]];
    
    if (years.count>0) {
        _segmentYear = [[DFSegmentView alloc] initWithFrame:CGRectZero andDelegate:self andTitlArr:years];
        _segmentYear.headViewHeight = 0.1*kScreenWidth;
        _segmentYear.selectIndex = 1;
        _segmentYear.tag = 0;
        _segmentYear.headViewLinelColor = [UIColor whiteColor];
        _segmentYear.headViewTextLabelColor = skinColor;
        [self.view addSubview:_segmentYear];
        [_segmentYear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0.02*kScreenWidth);
            make.left.right.bottom.equalTo(self.view);
        }];
    }else {
        return;
    }
    
    if (month) {
        _segmentMonth = [[DFSegmentView alloc] initWithFrame:CGRectZero andDelegate:self andTitlArr:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]];
        _segmentMonth.headViewHeight = 0.1*kScreenWidth;
        _segmentMonth.selectIndex = month-1;
        _segmentMonth.tag = 1;
        _segmentMonth.headViewLinelColor = skinColor;
        _segmentMonth.headViewTextLabelColor = skinColor;
        [self.view addSubview:_segmentMonth];
        [_segmentMonth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0.1*kScreenWidth);
            make.left.right.bottom.equalTo(self.view);
        }];
        [_segmentMonth reloadData];
    }else {
        return;
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.2*kScreenWidth+1, kScreenWidth, 5)];
    lineView.backgroundColor = zwGrayColor;
    [self.view addSubview:lineView];
    
    [self.parameterDic setValue:[NSString stringWithFormat:@"%ld",year] forKey:@"yearTime"];
    [self.parameterDic setValue:[NSString stringWithFormat:@"%ld",month] forKey:@"monthTime"];
    [self createPianExhibitionList:self.parameterDic];
}

- (void)createPianExhibitionList:(NSMutableDictionary *)dic {
    self.page = 1;
    [self requestPianExhibitionList:self.parameterDic withPage:self.page];
}


- (UIViewController *)superViewController {
    
    return self;
}

- (UIViewController *)subViewControllerWithIndex:(NSInteger)index {
    UIViewController *baseVC = [UIViewController new];
    baseVC.view.backgroundColor = [UIColor clearColor];
    return baseVC;
}

- (void)didSelectSegmentView:(DFSegmentView *)segmentView selectTitleWithIndex:(NSInteger)index {
    
    if (segmentView.tag == 0) {
        NSInteger year = [self takeYear];
        if (index == 0) {
            year = year-1;
        }else if (index == 1) {
            year = year;
        }else {
            year = year+1;
        }
        [self.parameterDic setValue:[NSString stringWithFormat:@"%ld",year] forKey:@"yearTime"];
        [self createPianExhibitionList:self.parameterDic];
    }else {
        NSLog(@"===%ld",index);
        [self.parameterDic setValue:[NSString stringWithFormat:@"%ld",index+1] forKey:@"monthTime"];
        [self createPianExhibitionList:self.parameterDic];
    }
}

- (NSInteger)takeYear {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;//年
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger year = [dateComponent year];
    return year;
}

- (NSInteger)takeMonth {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;//年
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger month = [dateComponent month];
    return month;
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"zai_icon_shaixuan"] barItem:self.navigationItem target:self action:@selector(screenBtnClick:)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    leftItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItemTwo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick:)];
    leftItemTwo.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItems = @[leftItem, leftItemTwo];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClick:(UIButton *)btn {
    CSSearchVC *searchVC = [[CSSearchVC alloc]init];
    searchVC.type = 7;
    searchVC.isAnimation = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)screenBtnClick:(UIButton *)btn {
    CSMenuViewController *menuVC = [[CSMenuViewController alloc]init];
    menuVC.screenType = 4;
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
    ZWExhPlanListModel *model = self.dataSource[indexPath.row];

    if ([model.developingState isEqualToString:@"1"]) {
        ZWPlanDelayCell *delayCell = [[ZWPlanDelayCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
        delayCell.tag = indexPath.row;
        delayCell.model = model;
        delayCell.delegate = self;
        [cell.contentView addSubview:delayCell];
    }else {
        ZWPlansListCell *plansListCell = [[ZWPlansListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
        plansListCell.tag = indexPath.row;
        plansListCell.model = model;
        plansListCell.delegate = self;
        [cell.contentView addSubview:plansListCell];
    }

}
-(void)respondToEventsWithIndex:(NSInteger)index {
    [self gotoAnnouncementWithIndex:index];
}

-(void)respondToEventsWithDelayIndex:(NSInteger)index {
    [self gotoAnnouncementWithIndex:index];
}
- (void)gotoAnnouncementWithIndex:(NSInteger)index {
    ZWExhPlanListModel *model = self.dataSource[index];
    ZWAnnouncementVC *VC = [[ZWAnnouncementVC alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.imageUrl = model.announcementImages;
    VC.title = @"公告";
    [self.navigationController pushViewController:VC animated:YES];
}



-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    UIImage * result = [UIImage imageWithData:data];
    return result;
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExhPlanListModel *model = self.dataSource[indexPath.row];
    if ([model.developingState isEqualToString:@"1"]) {
        return 0.35*kScreenWidth;
    }else {
        return 0.3*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWExhPlanListModel *model = self.dataSource[indexPath.row];
    ZWPlansDetailVC *detailVC = [[ZWPlansDetailVC alloc]init];
    detailVC.ID = model.ID;
    detailVC.title = @"计划展会详情";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)createRequest {

    NSDictionary *myDic = @{@"myId":@"",@"name":@""};
    self.screenValues = @[myDic,myDic,myDic,myDic,myDic];

    self.page = 1;
    [self requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
    }];
}

/**
 * 网络请求获取计划展会列表
*/
- (void)requestPianExhibitionList:(NSDictionary *)parametes withPage:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwPlanExhibitionList parametes:[self takeParameters:parametes withPage:page] successBlock:^(NSDictionary * _Nonnull data) {
        __weak typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExhPlanListModel *model = [ZWExhPlanListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
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

-(void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {

    } showInView:self];
}

@end
