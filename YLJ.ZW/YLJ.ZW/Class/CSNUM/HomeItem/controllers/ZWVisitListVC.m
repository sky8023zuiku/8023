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

@interface ZWVisitListVC ()<UITableViewDataSource,UITableViewDelegate,ZWPlansListCellDelegate,ZWPlanDelayCellDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, assign)NSInteger page;

@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) ZWExhibitionListRequsetAction *action;
@property(nonatomic, strong)NSArray *screenValues;
@end

@implementation ZWVisitListVC

-(ZWExhibitionListRequsetAction *)action {
    if (!_action) {
        _action = [[ZWExhibitionListRequsetAction alloc]init];
    }
    return _action;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0 );
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:notice.object[0][@"name"] forKey:@"country"];
    [dic setValue:notice.object[1][@"name"] forKey:@"city"];
    [dic setValue:notice.object[2][@"myId"] forKey:@"industryId"];
    [dic setValue:notice.object[3][@"name"] forKey:@"yearTime"];
    [dic setValue:notice.object[4][@"name"] forKey:@"monthTime"];
    self.page = 1;
    [self requestPianExhibitionList:dic withPage:self.page];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
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
    if (section == self.dataSource.count-1) {
        return 0.01*kScreenWidth;
    } else {
        return 0.1;
    }
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
            [strongSelf removeBlankView];
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExhPlanListModel *model = [ZWExhPlanListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataSource addObjectsFromArray:myArray];
            if (strongSelf.dataSource.count == 0) {
               [strongSelf showBlankPagesWithImage:blankPagesImageName withDitail:@"暂无展会" withType:1];
            }
            [strongSelf.tableView reloadData];
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
    [self requestPianExhibitionList:self.action.mj_keyValues withPage:self.page];
}


-(void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
