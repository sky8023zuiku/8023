//
//  ZWMyOrderVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyOrderVC.h"
#import "ZWMyOrderCell.h"
#import "ZWOrderAlreadyPayCell.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <MJRefresh.h>
#import "ZWPayVC.h"

@interface ZWMyOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;

@property(nonatomic, assign)NSInteger type;//记录0为未支付，1为已支付
@property(nonatomic, assign)NSInteger status;//记录1为未支付，2为已支付

@property (nonatomic ,strong)NSMutableArray *deleteArray;//需要被删除的数据
@property(nonatomic, assign)NSInteger page;
@property(strong, nonatomic)UIView *showView;
@property(nonatomic, strong)UIButton *allSelectedBtn;

@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation ZWMyOrderVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, zwNavBarHeight+44, kScreenWidth, kScreenHeight-zwNavBarHeight-44) style:UITableViewStyleGrouped];
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    self.page = 1;
    self.status = 1;
    [self createRequest:self.page withStatus:self.status];
    [self refreshHeader];
    [self refreshFooter];
}

- (void)createNavigationBar {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, zwNavBarHeight-1)];
    navView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), kScreenWidth, 1)];
    lineView.backgroundColor = zwGrayColor;
    [self.view addSubview:lineView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, zwStatusBarHeight+7, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left_black_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, zwStatusBarHeight, 80, zwNavBarHeight-zwStatusBarHeight)];
    titleLabel.text = @"订单";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [navView addSubview:titleLabel];
    
    CGFloat btnWidth = [[ZWToolActon shareAction]adaptiveTextWidth:@"管理" labelFont:[UIFont systemFontOfSize:17]];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kScreenWidth-15-btnWidth, zwStatusBarHeight, btnWidth, zwNavBarHeight-zwStatusBarHeight);
    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
}
- (void)backBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"管理"]) {
        self.type = 1;
//        self.navigationItem.rightBarButtonItem.title = @"完成";
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
        if (self.allSelectedBtn.selected) {
            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
            [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        }
    }else {
        self.type = 0;
        [self.deleteArray removeAllObjects];
//        self.navigationItem.rightBarButtonItem.title = @"管理";
        [btn setTitle:@"管理" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }
}


//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf createRequest:strongSelf.page withStatus:strongSelf.status];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:strongSelf.page withStatus:strongSelf.status];
    }];
}
- (void)createRequest:(NSInteger)page withStatus:(NSInteger)status{
    ZWOrderListRequest *request = [[ZWOrderListRequest alloc]init];
    request.payStatus = status;
    request.pageNo = page;
    request.pageSize = 10;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = respense.data[@"list"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWOrderListModel *model = [ZWOrderListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [self.dataSource addObjectsFromArray:myArray];
            [self.tableView reloadData];
        }else {
            
        }
    }];
}

//- (void)createNavigationBar {
//    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
//    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"管理" barItem:self.navigationItem target:self action:@selector(createRightItem:)];
//}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRightItem:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"管理"]) {
           self.type = 1;
           self.navigationItem.rightBarButtonItem.title = @"完成";
           [self.tableView setEditing:YES animated:YES];
           [self showEitingView:YES];
           if (self.allSelectedBtn.selected) {
               self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
               [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
           }
       }else {
           self.type = 0;
           [self.deleteArray removeAllObjects];
           self.navigationItem.rightBarButtonItem.title = @"管理";
           [self.tableView setEditing:NO animated:YES];
           [self showEitingView:NO];
       }
}
- (void)createUI {
    
    self.status = 1;
    self.dataSource = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = [NSArray arrayWithObjects:@"未支付订单",@"已支付订单", nil];

    for (int i = 0; i < 2; i ++) {
        UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        myBtn.frame = CGRectMake(i*kScreenWidth/2, zwNavBarHeight, kScreenWidth/2, 44);
        myBtn.tag = 1000+i;
        if (i == 0) {
            myBtn.backgroundColor = skinColor;
            [myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            myBtn.backgroundColor = [UIColor whiteColor];
            [myBtn setTitleColor:skinColor forState:UIControlStateNormal];
        }
        [myBtn setTitle:titles[i] forState:UIControlStateNormal];
        myBtn.titleLabel.font = normalFont;
        [myBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:myBtn];
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.showView];
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWOrderListModel *model = self.dataSource[indexPath.section];
    if (self.status == 1) {
        model.paymentStatus = 1;
    }else {
        model.paymentStatus = 2;
    }
    ZWMyOrderCell *orderCell = [[ZWMyOrderCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    orderCell.model = model;
    [cell.contentView addSubview:orderCell];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 9) {
        return 0.01*kScreenWidth;
    }else {
        return 0.1;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"--iiiii--%ld",(long)indexPath.row);
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWOrderListModel *model = self.dataSource[indexPath.section];
    if (self.type == 0) {
        if (self.status == 1) {
            ZWPayVC *payVC = [[ZWPayVC alloc]init];
            payVC.model = model;
            payVC.status = 2;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }else {
        [self.deleteArray addObject:model.orderId];
        NSLog(@"选中的id：%@",self.deleteArray);
        if (self.deleteArray.count == self.dataSource.count) {
            if (!self.allSelectedBtn.selected) {
                self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
                [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli_selected"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    ZWOrderListModel *model = self.dataSource[indexPath.section];
    if (self.type == 1) {
         NSLog(@"---撤销的id：%@",model.orderId);
        [self.deleteArray removeObject:model.orderId];
        if (self.allSelectedBtn.selected) {
            self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
            [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        }
        NSLog(@"撤销的id：%@",self.deleteArray);
    }else{

    }
}

- (void)myBtnClick:(UIButton *)btn {
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1001];
    [self.dataSource removeAllObjects];
    [self.deleteArray removeAllObjects];
    if (self.allSelectedBtn.selected) {
        self.allSelectedBtn.selected = !self.allSelectedBtn.selected;
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
    }
    NSLog(@"---数组---%@",self.dataSource);
    self.page = 1;
    if (btn.tag == 1000) {
        self.status = 1;
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn1.backgroundColor = skinColor;
        [btn2 setTitleColor:skinColor forState:UIControlStateNormal];
        btn2.backgroundColor = [UIColor whiteColor];
        [self.tableView reloadData];
    } else {
        self.status = 2;
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.backgroundColor = skinColor;
        [btn1 setTitleColor:skinColor forState:UIControlStateNormal];
        btn1.backgroundColor = [UIColor whiteColor];
        [self.tableView reloadData];
    }
    [self createRequest:self.page withStatus:self.status];
    
}

- (void)showEitingView:(BOOL)isShow{
    if (isShow == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.showView.frame = CGRectMake(0, kScreenHeight-zwTabBarHeight, kScreenWidth, zwTabBarHeight);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.showView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, zwTabBarHeight);
        }];
    }
}
- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, zwTabBarHeight)];
        _showView.backgroundColor = [UIColor whiteColor];
        _showView.layer.shadowColor = [UIColor blackColor].CGColor;
        _showView.layer.shadowOffset = CGSizeZero; //设置偏移量为0,四周都有阴影
        _showView.layer.shadowRadius = 5.0f;//阴影半径，默认3
        _showView.layer.shadowOpacity = 0.2f;
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(kScreenWidth -100, 10, 80, 30);
        deleteBtn.layer.cornerRadius = 15;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.borderWidth = 1;
        deleteBtn.layer.borderColor = skinColor.CGColor;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = normalFont;
        [deleteBtn setTitleColor:skinColor forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:deleteBtn];
        
        self.allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.allSelectedBtn.frame = CGRectMake(20, 15, 20, 20);
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        [self.allSelectedBtn addTarget:self action:@selector(allSelectedBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:self.allSelectedBtn];
        
        UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.allSelectedBtn.frame)+10, CGRectGetMinY(self.allSelectedBtn.frame), 80, CGRectGetWidth(self.allSelectedBtn.frame))];
        selectLabel.text = @"全选";
        selectLabel.textAlignment = NSTextAlignmentLeft;
        [_showView addSubview:selectLabel];
        
    }
    return _showView;
}
- (void)allSelectedBtnClcik:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli_selected"] forState:UIControlStateSelected];
        NSMutableArray *myID = [NSMutableArray array];
        for (int i = 0; i< self.dataSource.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            //全选实现方法
            ZWOrderListModel *model = self.dataSource[indexPath.section];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            [myID addObject:model.orderId];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:myID];
    }else{
        [self.allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"message_guanli"] forState:UIControlStateNormal];
        //取消选中
        for (int i = 0; i< self.dataSource.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        [self.deleteArray removeAllObjects];
    }
}

- (void)deleteBtnClick:(UIButton *)btn {
    NSLog(@"%@",self.deleteArray);
    if (self.deleteArray.count == 0) {
        [self showAlertWithMessage:@"无可删除的订单"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除订单" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf deleteOrder];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {

    } showInView:self];
}
- (void)deleteOrder {
    ZWOrderDeleteRequest *request = [[ZWOrderDeleteRequest alloc]init];
    request.idList = self.deleteArray;
    __weak typeof (self) weakSelf = self;
    [request postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"删除成功");
            [strongSelf.dataSource removeAllObjects];
            [strongSelf createRequest:strongSelf.page withStatus:strongSelf.status];
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
