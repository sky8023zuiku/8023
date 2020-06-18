//
//  ZWUserManagerVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWChildUserManagerVC.h"
#import "ZWChildUsersAddVC.h"
#import "ZWMineRqust.h"
#import "ZWMineResponse.h"
#import <Masonry/Masonry.h>

@interface ZWChildUserManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, assign)NSInteger type;

@property(nonatomic, strong)UIView *bottomView;

@property (strong, nonatomic) UIView *showView;

@property(nonatomic, strong)NSArray *dataSource;

@property (nonatomic ,strong)NSMutableArray *deleteArray;//需要被删除的数据

@end

@implementation ZWChildUserManagerVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
    [self createNotice];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"管理" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"删除"]) {
        [self deleteChlidUser];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightItemClick:(UIBarButtonItem *)item {
    
    if ([item.title isEqualToString:@"管理"]) {
        self.type = 1;
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.navigationItem.leftBarButtonItem.image = nil;
        self.navigationItem.leftBarButtonItem.title = @"删除";
        [self.tableView setEditing:YES animated:YES];
         [self showEitingView:YES];
    }else {
        self.type = 0;
        [self.deleteArray removeAllObjects];
        self.navigationItem.rightBarButtonItem.title = @"管理";
        self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"zai_dao_icon_left"];
        self.navigationItem.leftBarButtonItem.title = nil;
        [self.tableView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }
    
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"ZWChildUserManagerVC" object:nil];
}
- (void)refreshData {
    [self createRequest];
}
- (void)createUI {
    self.type = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.showView];
    
    self.deleteArray = [NSMutableArray array];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.showView.mas_top);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@zwTabBarHeight);
        make.bottom.equalTo(self.view).offset(zwTabBarHeight);
    }];
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
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    cell.tintColor = skinColor;
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWChildUserListModel *model = self.dataSource[indexPath.row];

    UIImageView *titleImage = [[UIImageView alloc]init];
    titleImage.frame = CGRectMake(20, 0.08*kScreenWidth, 0.14*kScreenWidth, 0.14*kScreenWidth);
    titleImage.image = [UIImage imageNamed:@"h1.jpg"];
    titleImage.layer.cornerRadius = 0.07*kScreenWidth;
    titleImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:titleImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+10, CGRectGetMinY(titleImage.frame), kScreenWidth-CGRectGetMaxX(titleImage.frame)-70, 20)];
    nameLabel.text = model.name;
    nameLabel.font = normalFont;
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(titleImage.frame)-20, CGRectGetWidth(nameLabel.frame), CGRectGetHeight(nameLabel.frame))];
    companyLabel.text = model.companyName;
    companyLabel.font = normalFont;
    companyLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:companyLabel];
    
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-80, 0.3*kScreenWidth/2-15, 30, 30)];
    if ([model.status intValue] == 1) {
        mySwitch.on = YES;
    }else {
        mySwitch.on = NO;
    }
    mySwitch.onTintColor = skinColor;
    mySwitch.tag = indexPath.row;
    [mySwitch addTarget:self action:@selector(mySwitchClick:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:mySwitch];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0.3*kScreenWidth-1, kScreenWidth-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWChildUserListModel *model = self.dataSource[indexPath.row];
    if (self.type == 1) {
        [self.deleteArray addObject:model.childrenId];
        NSLog(@"我要删除的数据：%@",self.deleteArray);
    }else {
        NSLog(@"1111111");
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    ZWChildUserListModel *model = self.dataSource[indexPath.row];
    if (self.type == 1) {
        [self.deleteArray removeObject:model.childrenId];
        
        NSLog(@"撤销：%@",self.deleteArray);
    }else{
        
    }
}
//*********************************************网络请求***************************************************/

-(void)createRequest {
    ZWChildUserListRequst *request = [[ZWChildUserListRequst alloc]init];
    __weak typeof (self) weakSelf = self;
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            NSArray *dataArr = respense.data;
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in dataArr) {
                ZWChildUserListModel *model = [ZWChildUserListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataSource = myArray;
            [strongSelf.tableView reloadData];
        }else {
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)showEitingView:(BOOL)isShow{
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:zwTabBarHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = skinColor;
        [button setTitle:@"添加" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:button];
        __weak typeof (self) weakSelf = self;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            make.top.left.bottom.equalTo(strongSelf.showView);
            make.width.equalTo(strongSelf.showView).multipliedBy(1);
        }];
    }
    return _showView;
}

-(void)buttonClick:(UIButton *)btn {
    ZWChildUsersAddVC *childAddVC = [[ZWChildUsersAddVC alloc]init];
    childAddVC.title = @"添加子用户";
    [self.navigationController pushViewController:childAddVC animated:YES];
}
- (void)deleteChlidUser {
    if (self.deleteArray.count == 0) {
        [self showAlertWithMessage:@"无可删除的子用户"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        ZWChildUserDeleteRequest *request = [[ZWChildUserDeleteRequest alloc]init];
        request.idList = strongSelf.deleteArray;
        [request postRequestCompleted:^(YHBaseRespense *respense) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (respense.isFinished) {
                NSLog(@"删除成功");
                [strongSelf createRequest];
            }else {
                
            }
        }];
        
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}

- (void)mySwitchClick:(UISwitch *)uSwitch {
    ZWChildUserListModel *model = self.dataSource[uSwitch.tag];
    ZWChildUserStatusRequest *request = [[ZWChildUserStatusRequest alloc]init];
    request.childrenId = model.childrenId;
    if ([model.status intValue]==1) {
        request.status = @"0";
    }else {
        request.status = @"1";
    }
    [request postFormDataWithProgress:nil RequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
        }else {
            NSLog(@"---%@",respense.data);
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
