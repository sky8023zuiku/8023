//
//  ZWMyInvitationVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInvitationVC.h"
#import "ZWMyInviteCodeVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMyInvitationModel.h"

@interface ZWMyInvitationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSDictionary *dataDiictionary;
@end

@implementation ZWMyInvitationVC
-(UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createData];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"邀请码" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    [self requestUserInfoForQrCode];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataDiictionary) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataDiictionary) {
        if (section == 0) {
            return 1;
        }else {
            return self.dataArray.count;
        }
    }else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataDiictionary) {
        if (indexPath.section == 0) {
            UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.02*kScreenWidth, 0.11*kScreenWidth, 0.11*kScreenWidth)];
            [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.dataDiictionary[@"headImage"]]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
            headImage.layer.cornerRadius = 0.055*kScreenWidth;
            headImage.layer.masksToBounds = YES;
            [cell.contentView addSubview:headImage];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.04*kScreenWidth, CGRectGetMinY(headImage.frame), 0.5*kScreenWidth, 0.05*kScreenWidth)];
            nameLabel.text = self.dataDiictionary[@"name"];
            nameLabel.font = smallMediumFont;
            nameLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+0.01*kScreenWidth, 0.5*kScreenWidth, 0.05*kScreenWidth)];
            phoneLabel.text = self.dataDiictionary[@"phone"];
            phoneLabel.font = smallFont;
            phoneLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
            [cell.contentView addSubview:phoneLabel];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(0.85*kScreenWidth-15, CGRectGetMinY(nameLabel.frame)+10, 0.15*kScreenWidth, 0.05*kScreenWidth);
            [deleteBtn setTitle:@"首页不看他" forState:UIControlStateNormal];
            deleteBtn.layer.borderWidth = 0.5;
            deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
            deleteBtn.layer.cornerRadius = 5;
            deleteBtn.layer.masksToBounds = YES;
            [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = smallFont;
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteBtn];
            
        }else {
            [self createCell:cell withIndex:indexPath.row];
        }
    }else {
        [self createCell:cell withIndex:indexPath.row];
    }
}

- (void)createCell:(UITableViewCell *)cell withIndex:(NSInteger)index {
    ZWMyInvitationModel *model = self.dataArray[index];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.02*kScreenWidth, 0.11*kScreenWidth, 0.11*kScreenWidth)];
    headImage.image = [UIImage imageNamed:@"h1.jpg"];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.headImage]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
    headImage.layer.cornerRadius = 0.055*kScreenWidth;
    headImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.04*kScreenWidth, CGRectGetMinY(headImage.frame), 0.5*kScreenWidth, 0.05*kScreenWidth)];
    nameLabel.text = model.userName;
    nameLabel.font = smallMediumFont;
    nameLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+0.01*kScreenWidth, 0.5*kScreenWidth, 0.05*kScreenWidth)];
    phoneLabel.text = model.phone;
    phoneLabel.font = smallFont;
    phoneLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:phoneLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), 0.3*kScreenWidth, CGRectGetHeight(nameLabel.frame))];
    dateLabel.text = model.recommendTime;
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = smallFont;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:dateLabel];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.08*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.02*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.15*kScreenWidth;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *toolView = [[UIView alloc]init];
    toolView.backgroundColor = [UIColor whiteColor];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0.08*kScreenWidth)];
    myLabel.font = normalFont;
    if (self.dataDiictionary) {
        if (section == 0) {
            myLabel.text = @"我的邀请人";
        }else {
            myLabel.text = @"我邀请的人";
        }
    }else {
        myLabel.text = @"我邀请的人";
    }
    
    [toolView addSubview:myLabel];
    
    return toolView;
}


- (void)deleteBtnClick:(UIButton *)btn {
    
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认首页不看该公司信息" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf deleteWhoInvitedMe];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
    
}


//********************************************************数据相关******************************************************************/

//-(NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}
- (void)createData {
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    [self createRquestWithPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [self createRquestWithPage:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [self createRquestWithPage:self.page];
    }];
}

- (void)createRquestWithPage:(NSInteger)index {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwInvitationList parametes:@{@"pageNo":[NSString stringWithFormat:@"%ld",index],@"pageSize":@"10"} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (index == 1) {
            [strongSelf.dataArray removeAllObjects];
        }
        if (zw_issuccess) {
            NSArray *myData = data[@"data"][@"childList"][@"result"];
            NSLog(@"%@",data[@"data"]);
            strongSelf.dataDiictionary = data[@"data"][@"parentInfo"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWMyInvitationModel *model = [ZWMyInvitationModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)deleteWhoInvitedMe {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwDeleteMyFirstLookCompany parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [strongSelf createRquestWithPage:1];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}


//获取个人信息生成二维码
- (void)requestUserInfoForQrCode {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeUserInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myDic = data[@"data"];
            if (myDic) {
                [[ZWSaveDataAction shareAction]saveUserInfoData:myDic];
            }
            NSDictionary *OrCodeDic = @{
                @"zw_status":@"0",//0为邀请二维码
                @"zw_content":@{
                    @"phone":data[@"data"][@"phone"],
                    @"userName":data[@"data"][@"userName"],
                    @"headImages":data[@"data"][@"headImages"],
                    @"merchantName":data[@"data"][@"merchantName"]
                }
            };
            ZWMyInviteCodeVC *inviteCodeVC  = [[ZWMyInviteCodeVC alloc]init];
            inviteCodeVC.QrCodeDic = OrCodeDic;
            [strongSelf yc_centerPresentController:inviteCodeVC presentedSize:CGSizeMake(0.8*kScreenWidth, kScreenWidth) completeHandle:^(BOOL presented) {
            
            }];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}
@end
