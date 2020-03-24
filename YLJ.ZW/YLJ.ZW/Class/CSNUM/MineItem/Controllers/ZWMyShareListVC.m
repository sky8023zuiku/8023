//
//  ZWMyShareListVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareListVC.h"
#import "ZWMyShareExhibitionUserModel.h"
@interface ZWMyShareListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@end

@implementation ZWMyShareListVC

-(UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        
    }
    return _tableView;
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
- (void)goBack:(UINavigationItem *)item {
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZWMyShareExhibitionUserModel *model = self.dataArray[indexPath.row];
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.02*kScreenWidth, 0.11*kScreenWidth, 0.11*kScreenWidth)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.coverImage]] placeholderImage:[UIImage imageNamed:@"icon_no_60"]];
    headImage.layer.cornerRadius = 0.055*kScreenWidth;
    headImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.02*kScreenWidth, CGRectGetMinY(headImage.frame), 0.5*kScreenWidth, 0.05*kScreenWidth)];
    nameLabel.text = model.userName;
    nameLabel.font = smallMediumFont;
    nameLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+0.01*kScreenWidth, 0.5*kScreenWidth, 0.05*kScreenWidth)];
    phoneLabel.text = model.phone;
    phoneLabel.font = smallFont;
    phoneLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:phoneLabel];
    
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), 0.37*kScreenWidth-30, CGRectGetHeight(nameLabel.frame))];
    dateLabel.text = model.bindTime;
    dateLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    dateLabel.font = smallFont;
    dateLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:dateLabel];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.15*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)createRequest {
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    [self dataRequestWithPage:self.page];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [self dataRequestWithPage:self.page];
    }];
}

//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [self dataRequestWithPage:self.page];
    }];
}

- (void)dataRequestWithPage:(NSInteger)page {
    NSLog(@"------%@",self.exhibitionId);
    NSDictionary *myDic = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"20",@"exhibitionId":self.exhibitionId};
    if (myDic) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwShareUserList parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                if (page == 1) {
                    [strongSelf.dataArray removeAllObjects];
                }
                NSArray *myData = data[@"data"][@"result"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWMyShareExhibitionUserModel *model = [ZWMyShareExhibitionUserModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                [strongSelf.dataArray addObjectsFromArray:myArray];
                [strongSelf.tableView reloadData];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}


@end
