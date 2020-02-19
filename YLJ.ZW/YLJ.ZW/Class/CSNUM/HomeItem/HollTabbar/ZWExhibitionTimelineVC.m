//
//  ZWExhibitionTimelineVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionTimelineVC.h"
#import "ZWExhibitionTimelineModel.h"
#import "ZWAnnouncementVC.h"
#import <YYLabel.h>
#import <YYText.h>
@interface ZWExhibitionTimelineVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation ZWExhibitionTimelineVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0.025*kScreenWidth, 0, 0.025*kScreenWidth );
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"展会排期";
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@""] barItem:self.tabBarController.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)rightItemClick:(UIBarButtonItem *)item {
    
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initWithData];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma UITableViewDataSource
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
    
    ZWExhibitionTimelineModel *model = self.dataArray[indexPath.row];
    
    CGFloat rowHeight = 0.3*kScreenWidth;
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.025*kScreenWidth, rowHeight-0.05*kScreenWidth, rowHeight-0.05*kScreenWidth)];
    [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    titleImage.layer.cornerRadius = 3;
    titleImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:titleImage];
    
    
    UIImageView *labelImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(titleImage.frame)-30, 0, 30, 30)];
    [titleImage addSubview:labelImage];
    
    YYLabel *titleLabel = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+0.025*kScreenWidth, CGRectGetMinY(titleImage.frame), kScreenWidth-CGRectGetMaxX(titleImage.frame)-0.05*kScreenWidth, 0.5*CGRectGetHeight(titleImage.frame))];
    titleLabel.numberOfLines = 2;
    if ([model.developingState isEqualToString:@"0"]) {
        titleLabel.text = model.name;
        titleLabel.font = boldNormalFont;
        labelImage.image = [UIImage imageNamed:@""];
    }else {
        NSString *titleState;
        if ([model.developingState isEqualToString:@"1"]) {
            titleState = @"【延期】";
            labelImage.image = [UIImage imageNamed:@"delay_icon"];
        }else {
            titleState = @"【取消】";
            labelImage.image = [UIImage imageNamed:@"cancel_icon"];
        }
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"查看公告%@%@",titleState,model.name]];
        [titleStr setYy_color:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0]];
        [titleStr setYy_font:boldNormalFont];
        NSRange rangeOne = [[titleStr string]rangeOfString:@"查看公告"];
        __weak typeof (self) weakSelf = self;
        [titleStr yy_setTextHighlightRange:rangeOne color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            ZWAnnouncementVC *VC = [[ZWAnnouncementVC alloc]init];
            VC.hidesBottomBarWhenPushed = YES;
            VC.imageUrl = model.announcementImages;
            VC.title = @"公告";
            [strongSelf.navigationController pushViewController:VC animated:YES];
        }];
        NSRange rangeTwo = [[titleStr string]rangeOfString:titleState];
        [titleStr yy_setTextHighlightRange:rangeTwo color:[UIColor redColor] backgroundColor:[UIColor whiteColor] userInfo:nil];
        titleLabel.attributedText = titleStr;
    }
    [cell.contentView addSubview:titleLabel];
    

    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMinY(titleImage.frame)+0.5*CGRectGetHeight(titleImage.frame), CGRectGetWidth(titleLabel.frame), 0.5*CGRectGetHeight(titleImage.frame)/2)];
    dateLabel.text = @"时    间：2018-06-07~2018-06-10";
    dateLabel.font = smallMediumFont;
    dateLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:dateLabel];
    
    UILabel *mianLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame), CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
    mianLabel.text = [NSString stringWithFormat:@"主办方：%@",model.sponsor];
    mianLabel.font = smallMediumFont;
    mianLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    [cell.contentView addSubview:mianLabel];
    
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


- (void)initWithData {
    self.page = 1;
    [self refreshData:self.page];
    [self refreshHeader];
    [self refreshFooter];
}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [self refreshData:self.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [self refreshData:self.page];
    }];
}
- (void)refreshData:(NSInteger)page {
    
    NSDictionary *parametes = @{@"pageNo":[NSString stringWithFormat:@"%ld",page],
                                @"pageSize":@"10",
                                @"hallId":self.hallId};
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwHallDateLineList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *myData = data[@"data"][@"result"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExhibitionTimelineModel *model = [ZWExhibitionTimelineModel parseJSON:myDic];
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
