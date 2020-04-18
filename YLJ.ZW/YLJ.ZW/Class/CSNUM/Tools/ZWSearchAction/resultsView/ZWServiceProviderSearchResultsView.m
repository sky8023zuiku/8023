//
//  ZWServiceProviderSearchResultsView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWServiceProviderSearchResultsView.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <MJRefresh.h>
#import "ZWCompanyDetailVC.h"
#import "ZWExhibitionServerDetailVC.h"
#import "ZWExhServiceListCell.h"

@interface ZWServiceProviderSearchResultsView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *resultsText;

@property(nonatomic, strong) NSString *parameterType;//展会服务里面需要区分类别
@property(nonatomic, strong) NSString *city;//传入城市

@end
@implementation ZWServiceProviderSearchResultsView
- (instancetype)initWithFrame:(CGRect)frame withParameter:(id)obj
{
    if (self = [super initWithFrame:frame]) {
        self.parameterType = obj[@"type"];
        self.city = obj[@"city"];
        self.dataArray = [NSMutableArray array];
        [self addSubview:self.contentTableView];
        NSLog(@"----%@",self.searchText);
    }
    return self;
}

-(void)setSearchText:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    self.resultsText = searchText;
    [self createData:searchText];
}
-(void)createData:(NSString *)text {
    self.page = 1;
    [self createRequst:text withPage:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf.dataArray removeAllObjects];
        [strongSelf createRequst:strongSelf.resultsText withPage:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequst:strongSelf.resultsText withPage:strongSelf.page];
    }];
}

- (void)createRequst:(NSString *)text withPage:(NSInteger)page{
//    ZWServiceProvidersListRequst *requst = [[ZWServiceProvidersListRequst alloc]init];
//    requst.status = 2;
//    requst.merchantName = text;
//    requst.city = self.city;
//    requst.type = self.parameterType;
//    requst.pageNo = (int)page;
//    requst.pageSize = 10;
//    __weak typeof(self) weakSelf = self;
//    [requst postRequestCompleted:^(YHBaseRespense *respense) {
//        __strong typeof (self) strongSelf = weakSelf;
//        [strongSelf.contentTableView.mj_header endRefreshing];
//        [strongSelf.contentTableView.mj_footer endRefreshing];
//        if (respense.isFinished) {
//            NSLog(@"%@",[[ZWToolActon shareAction]transformDic:respense.data[@"result"]]);
//            NSArray *array = respense.data[@"result"];
//            NSMutableArray *myArr = [NSMutableArray array];
//            for (NSDictionary *myDic in array) {
//                ZWServiceProvidersListModel *model = [ZWServiceProvidersListModel parseJSON:myDic];
//                [myArr addObject:model];
//            }
//            [strongSelf.dataArray addObjectsFromArray:myArr];
//            [strongSelf.contentTableView reloadData];
//        }else {
//
//        }
//    }];

    
    NSDictionary *myDic = @{
        @"merchantName":text,
        @"pageQuery":@{
                @"pageNo":[NSString stringWithFormat:@"%ld",page],
                @"pageSize":@"10"
        }
    };
    if (myDic) {
        __weak typeof(self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwExhibitionServiceProviderList parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf.contentTableView.mj_header endRefreshing];
            [strongSelf.contentTableView.mj_footer endRefreshing];
            if (zw_issuccess) {
                if (page == 1) {
                    [strongSelf.dataArray removeAllObjects];
                }
                NSLog(@"%@",[[ZWToolActon shareAction]transformDic:data[@"data"][@"providerList"]]);
                NSArray *array = data[@"data"][@"providerList"];
                NSMutableArray *myArr = [NSMutableArray array];
                for (NSDictionary *myDic in array) {
                    ZWServiceProvidersListModel *model = [ZWServiceProvidersListModel parseJSON:myDic];
                    [myArr addObject:model];
                }
                [strongSelf.dataArray addObjectsFromArray:myArr];
                [strongSelf.contentTableView reloadData];
            }else {
                
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (ZWBaseEmptyTableView *)contentTableView
{
    if (!_contentTableView) {
        self.contentTableView = [[ZWBaseEmptyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.sectionHeaderHeight = 0;
        _contentTableView.sectionFooterHeight = 0;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
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
    ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
     
//     UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 15, 0.28*kScreenWidth, 0.23*kScreenWidth)];
//     imageView.image = [UIImage imageNamed:@"h1.jpg"];
//     [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imagesUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
//     [cell.contentView addSubview:imageView];
//
//     UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, CGRectGetMinY(imageView.frame), 0.4*kScreenHeight, 20)];
//     titleLabel.text = model.name;
//     titleLabel.font = boldNormalFont;
//     titleLabel.textColor = [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
//     [cell.contentView addSubview:titleLabel];
//
//
//     NSArray *labels = [NSArray arrayWithObjects:@"展台设计",@"展台搭建",@"展会相关", nil];
//     NSArray *bgColors = @[[UIColor colorWithRed:200.0/255.0 green:227.0/255.0 blue:255.0/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:227/255.0 blue:200/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
//     NSArray *textColors = @[[UIColor colorWithRed:24/255.0 green:136/255.0 blue:255/255.0 alpha:1.0],[UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:56/255.0 blue:56/255.0 alpha:1.0]];
//
//     for (int i = 0; i<labels.count ; i++) {
//         UILabel *ywLabel = [[UILabel alloc]init];
//         ywLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame)+60*i, CGRectGetMaxY(titleLabel.frame)+18, 50, 20);
//         ywLabel.backgroundColor = bgColors[i];
//         ywLabel.textColor = textColors[i];
//         ywLabel.text = labels[i];
//         ywLabel.font = smallFont;
//         ywLabel.textAlignment = NSTextAlignmentCenter;
//         ywLabel.layer.cornerRadius = 2.5;
//         ywLabel.layer.masksToBounds = YES;
//         [cell.contentView addSubview:ywLabel];
//     }
//
//     UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(imageView.frame)-20, 0.8*kScreenWidth, 20)];
//     detailLabel.text = model.speciality;
//     detailLabel.font = normalFont;
//     [cell.contentView addSubview:detailLabel];
//
//
//     UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 0.35*kScreenWidth-1, 0.91*kScreenWidth, 1)];
//     lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
//     [cell.contentView addSubview:lineView];
    
    
//    ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
    ZWExhServiceListCell *showCell = [[ZWExhServiceListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
    showCell.model = model;
    [cell.contentView addSubview:showCell];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 0.3*kScreenWidth-1, 0.91*kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
    [cell.contentView addSubview:lineView];
    
    
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.3*kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
//    ZWCompanyDetailVC *companyDetailVC = [[ZWCompanyDetailVC alloc]init];
//    companyDetailVC.serviceId = [NSString stringWithFormat:@"%@",model.providersId];
//    [self.ff_navViewController pushViewController:companyDetailVC animated:YES];
    
    
    ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
    ZWExhibitionServerDetailVC *VC = [[ZWExhibitionServerDetailVC alloc]init];
    VC.merchantId = [NSString stringWithFormat:@"%@",model.providersId];
    [self.ff_navViewController pushViewController:VC animated:YES];
}

@end
