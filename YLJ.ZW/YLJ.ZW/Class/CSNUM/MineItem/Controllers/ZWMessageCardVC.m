//
//  ZWMessageCardVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageCardVC.h"
#import "ZWCardCollectionModel.h"
#import "ZWMessageCardDetailVC.h"

@interface ZWMessageCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)ZWBaseEmptyTableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@end

@implementation ZWMessageCardVC

-(ZWBaseEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZWBaseEmptyTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0,0.05*kScreenWidth, 0, 0);
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
    self.title = @"名片列表";
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
    
    ZWCardCollectionModel *model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    titleImage.backgroundColor = zwDarkGrayColor;
    titleImage.layer.cornerRadius = 0.075*kScreenWidth;
    titleImage.layer.masksToBounds = YES;
    [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.headImage]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
    [cell.contentView addSubview:titleImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, CGRectGetMinY(titleImage.frame), 0.2*kScreenWidth, CGRectGetHeight(titleImage.frame)/3)];
    titleLabel.text = model.contacts;
    titleLabel.font = boldNormalFont;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *deteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.45*kScreenWidth, CGRectGetMinY(titleLabel.frame), 0.5*kScreenWidth, CGRectGetHeight(titleLabel.frame))];
    deteLabel.font = smallFont;
    deteLabel.textColor = [UIColor grayColor];
    deteLabel.text = [[ZWToolActon shareAction]getTimeFromTimestamp:model.created withDataStr:@"YYYY-MM-dd HH:mm:ss"];
    deteLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:deteLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), 0.75*kScreenWidth-5, CGRectGetHeight(titleImage.frame)/3*2)];
    detailLabel.text = model.phone;
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
    ZWCardCollectionModel *model = self.dataArray[indexPath.row];
    ZWMessageCardDetailVC *cardDetailVC = [[ZWMessageCardDetailVC alloc]init];
    cardDetailVC.cardStr = model.userCard;
    [self.navigationController pushViewController:cardDetailVC animated:YES];
    if ([model.readStatus isEqualToString:@"0"]) {
        model.readStatus = @"1";
        [self.tableView reloadData];
        [self setMessageIsRead:model.listId];
    }
}
- (void)setMessageIsRead:(NSString *)listId {
    [[ZWDataAction sharedAction]postReqeustWithURL:zwSetMessageIsRead parametes:@{@"idList":@[listId]} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSLog(@"成功设置为已读");
            [[ZWMessageNumAction shareAction]takeMessageNumber];
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
    
    //删除数据，和删除动画
//    [self.myarray removeObjectAtIndex:deleteRow];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
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
    ZWCardCollectionModel *model = self.dataArray[indexPath.row];
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwDeleteMessage parametes:@{@"idList":@[model.listId]} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [strongSelf createRequest];
        }else {
            [strongSelf showOneAlertWithMessage:@"删除失败，请稍后再试或者联系客服"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
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
    [[ZWDataAction sharedAction]postReqeustWithURL:zwGetBusinessCardList parametes:@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"10"} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"][@"cardList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWCardCollectionModel *model = [ZWCardCollectionModel parseJSON:myDic];
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
