//
//  ZWDynamicDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDynamicDetailVC.h"
#import "DCCycleScrollView.h"
@interface ZWDynamicDetailVC ()<UITableViewDelegate,UITableViewDataSource,DCCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)DCCycleScrollView *banner;

@property(nonatomic, strong)NSString *exhiTitle;
@property(nonatomic, strong)NSString *describe;

@property(nonatomic, strong)NSArray *imageArray;

@end

@implementation ZWDynamicDetailVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -zwStatusBarHeight, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRequest];
}
- (void)backBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIButton *backBtn = [UIButton  buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(20, zwStatusBarHeight+9, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"zai_zxiang_icon_chanx"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0.13*kScreenWidth)];
        titleLabel.text = self.exhiTitle;
        titleLabel.font = normalFont;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        
    }else {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0.13*kScreenWidth)];
        titleLabel.text = @"展台说明";
        titleLabel.font = boldNormalFont;
        [cell.contentView addSubview:titleLabel];
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.describe textFont:normalFont textWidth:kScreenWidth-30];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), kScreenWidth-30, height)];
        detailLabel.text =self.describe;
        detailLabel.font = normalFont;
        detailLabel.numberOfLines = 0;
        detailLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:detailLabel];
        
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.13*kScreenWidth;
    }else {
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.describe textFont:normalFont textWidth:kScreenWidth-30];
        return 0.15*kScreenWidth+height;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.6*kScreenWidth;
    }else {
        return 0.02*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (section == 0) {
        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.6*kScreenWidth) shouldInfiniteLoop:YES imageGroups:self.imageArray];
        self.banner.placeholderImage = [UIImage imageNamed:@"fu_img_no_02"];
        self.banner.autoScrollTimeInterval = 5;
        self.banner.autoScroll = YES;
        self.banner.isZoom = NO;
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 0;
        self.banner.itemWidth = kScreenWidth;
        self.banner.delegate = self;
        [view addSubview:self.banner];
    }
    return view;
}
//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
}

- (void)createRequest {

    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwExhibitorsNewDynamicDetail parametes:@{@"id":self.ID} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *imageArr = data[@"data"][@"imagesList"];
            NSMutableArray *images = [NSMutableArray array];
            for (NSDictionary *myDic in imageArr) {
                NSString *imageStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,myDic[@"url"]];
                [images addObject:imageStr];
            }
            strongSelf.exhiTitle = [NSString stringWithFormat:@"%@-%@",data[@"data"][@"merchantName"],data[@"data"][@"planExhibitionName"]];
            strongSelf.describe = data[@"data"][@"describe"];
            strongSelf.imageArray = images;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}
@end
