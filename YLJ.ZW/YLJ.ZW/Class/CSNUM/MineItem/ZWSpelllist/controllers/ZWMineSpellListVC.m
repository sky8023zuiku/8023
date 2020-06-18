//
//  ZWMineSpellListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineSpellListVC.h"
#import "ZWSpellListCell.h"
#import "ZWServerSpellListDetailVC.h"
#import "ZWMineSpellListDetailVC.h"
#import "ZWMineSpellListFailureVC.h"

#import "ZWMineReleaseSpelllistVC.h"

@interface ZWMineSpellListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation ZWMineSpellListVC

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    return _tableView;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createRequest) name:@"refreshSepllListData" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshSepllListData" object:nil];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"发布" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UINavigationItem *)item {
//    ZWReleaseSpelllistVC *listVC = [[ZWReleaseSpelllistVC alloc]init];
//    listVC.pageIndex = 2;
//    [self.navigationController pushViewController:listVC animated:YES];
    
    ZWMineReleaseSpelllistVC *listVC = [[ZWMineReleaseSpelllistVC alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZWSpellListModel *model = self.dataArray[indexPath.section];
    ZWSpellListCell *listCell = [[ZWSpellListCell alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0.35*kScreenWidth) withFont:smallMediumFont];
    listCell.backgroundColor = [UIColor whiteColor];
    listCell.model = model;
    listCell.layer.cornerRadius = 3;
    listCell.layer.masksToBounds = NO;
    listCell.layer.shadowOpacity=1;///不透明度
    listCell.layer.shadowColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor;//阴影颜色
    listCell.layer.shadowOffset = CGSizeMake(0, 0);//投影偏移
    listCell.layer.shadowRadius = 4;//半径大小
    [cell.contentView addSubview:listCell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.35*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 9) {
        return 10;
    }else {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWSpellListModel *model = self.dataArray[indexPath.section];
    if ([model.spellStatus isEqualToString:@"3"]) {
        ZWMineSpellListFailureVC *spellDetailVC = [[ZWMineSpellListFailureVC alloc]init];
        spellDetailVC.model = model;
        [self.navigationController pushViewController:spellDetailVC animated:YES];
    }else {
        ZWMineSpellListDetailVC *spellDetailVC = [[ZWMineSpellListDetailVC alloc]init];
        spellDetailVC.model = model;
        [self.navigationController pushViewController:spellDetailVC animated:YES];
    }
}

- (void)createRequest {
    [self refreshHeader];
    [self refreshFooter];
    [self createRequstwithPage:1];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequstwithPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequstwithPage:strongSelf.page];
    }];
}

- (void)createRequstwithPage:(NSInteger)page {
    
    NSDictionary *parameters = @{@"pageQuery":@{
                                                    @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                                    @"pageSize":@"10"
                                                }
                                };
    
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwMySpellList parametes:parameters successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSLog(@"%@",data[@"data"][@"resultList"]);
            NSArray *arry = data[@"data"][@"resultList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in arry) {
//                ZWSpellListModel *model = [ZWSpellListModel parseJSON:myDic];
                ZWSpellListModel *model = [ZWSpellListModel mj_objectWithKeyValues:myDic];
                [myArray addObject:model];
            }
            
            
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//2
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
//3
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//4
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
}
//5
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认删除" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf deleteCardWithIndex:indexPath];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];

    }];
    return @[deleteRowAction];
}


- (void)deleteCardWithIndex:(NSIndexPath *)indexPath {
    
     ZWSpellListModel *model = self.dataArray[indexPath.section];
    
    NSDictionary *myParametes =@{
        @"spellId":model.spellId
    };
    if (myParametes) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwDeleteMySpellList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [strongSelf createRequest];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
    
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
