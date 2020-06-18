//
//  ZWMessageActivitiesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageActivitiesVC.h"
#import "ZWActivitiesMessageModel.h"

@interface ZWMessageActivitiesVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@end

@implementation ZWMessageActivitiesVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0,0.2*kScreenWidth+5, 0, 0);
    [_tableView setSeparatorColor:zwDarkGrayColor];
    return _tableView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    
    [self createRequest];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWActivitiesMessageModel *model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    titleImage.backgroundColor = zwDarkGrayColor;
    titleImage.image = [UIImage imageNamed:@"zw_zfzw_icon"];
    titleImage.layer.cornerRadius = 0.075*kScreenWidth;
    titleImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:titleImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, CGRectGetMinY(titleImage.frame), 0.2*kScreenWidth, CGRectGetHeight(titleImage.frame)/3)];
    titleLabel.text = model.title;
    titleLabel.font = boldNormalFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *deteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.45*kScreenWidth, CGRectGetMinY(titleLabel.frame), 0.5*kScreenWidth, CGRectGetHeight(titleLabel.frame))];
    deteLabel.font = smallFont;
    deteLabel.textColor = [UIColor grayColor];
    deteLabel.text = [[ZWToolActon shareAction]getTimeFromTimestamp:(NSNumber *)model.created withDataStr:@"YYYY-MM-dd HH:mm:ss"];
    deteLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:deteLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), 0.75*kScreenWidth-5, CGRectGetHeight(titleImage.frame)/3*2)];
    detailLabel.text = model.description2;
    detailLabel.numberOfLines = 2;
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = smallMediumFont;
    [cell.contentView addSubview:detailLabel];
    
    if ([model.readStatus isEqualToString:@"0"]) {
        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*kScreenWidth, 0.03*kScreenWidth, 10, 10)];
        redLabel.backgroundColor = [UIColor redColor];
        redLabel.layer.cornerRadius = 5;
        redLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:redLabel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.2*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWActivitiesMessageModel *model = self.dataArray[indexPath.row];
    if ([model.readStatus isEqualToString:@"0"]) {
        model.readStatus = @"1";
        [self.tableView reloadData];
        [self setMessageIsRead:model.listId];
    }
}

- (void)setMessageIsRead:(NSString *)listId {
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSetSystemMessageIsRead parametes:@{@"idList":@[listId]} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSLog(@"成功设置为已读");
            [[ZWMessageNumAction shareAction]takeMessageNumber];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

- (void)createRequest {
    self.page = 1;
    [self dataRequestWithPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf dataRequestWithPage:self.page];
    }];
}

//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf dataRequestWithPage:self.page];
    }];
}

- (void)dataRequestWithPage:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetActivitiesMessageList parametes:@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"10"} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"][@"systemList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWActivitiesMessageModel * model = [ZWActivitiesMessageModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
    
}

@end
