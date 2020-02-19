//
//  ZWCompanyDetailVC.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCompanyDetailVC.h"
#import "DCCycleScrollView.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import "ZWImageBrowser.h"
#import "CSTurnsView.h"
#import "CSBannerView.h"

@interface ZWCompanyDetailVC ()<UITableViewDelegate,UITableViewDataSource,DCCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)NSArray *dataImages;
@property(nonatomic, strong)NSArray *imageArray;
@end

@implementation ZWCompanyDetailVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequst];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createRequst {
    ZWServiceProvidersDetailRequst *requst = [[ZWServiceProvidersDetailRequst alloc]init];
    requst.serviceId = self.serviceId;
    __weak typeof(self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        if (respense.finished) {
            NSLog(@"%@",respense.data);
            NSArray *myData = @[respense.data];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWServiceProvidersDetailModel *model = [ZWServiceProvidersDetailModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataArray = myArray;
            [strongSelf.tableView reloadData];
        }else {
            
        }
    }];
}
- (void)createUI {
    self.title = @"公司详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWServiceProvidersDetailModel *model = self.dataArray[0];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.3*kScreenWidth, 0.13*kScreenWidth)];
    titleLabel.font = normalFont;
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, kScreenWidth-110, 0.13*kScreenWidth)];
    detailLabel.font = boldNormalFont;
    detailLabel.numberOfLines = 2;
    detailLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [cell.contentView addSubview:detailLabel];
    
    if (indexPath.row == 0) {
        
        titleLabel.text = @"公司名称：";
        detailLabel.text = [NSString stringWithFormat:@"%@",model.name];
        
    } else if(indexPath.row == 1) {
        
        titleLabel.text = @"公司电话：";
        detailLabel.text = [NSString stringWithFormat:@"%@",model.telephone];
        detailLabel.font = normalFont;
        detailLabel.textColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0];
        
    }else if (indexPath.row == 2) {
        
        titleLabel.text = @"公司地址：";
        detailLabel.text = [NSString stringWithFormat:@"%@",model.address];
        detailLabel.font = normalFont;
        detailLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        
    }else {
        
        titleLabel.text = @"公司简介：";
        NSString *detailStr = [NSString stringWithFormat:@"%@",model.profile];
        CGFloat kHeight = [[ZWToolActon shareAction]adaptiveTextHeight:detailStr font:normalFont];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0.08*kScreenWidth, kScreenWidth-30, kHeight+50)];
        detailLabel.text = detailStr;
        detailLabel.font = normalFont;
        detailLabel.numberOfLines = 0;
        detailLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [cell.contentView addSubview:detailLabel];
        
    }
    if (indexPath.row !=3) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 0.13*kScreenWidth-1, 0.91*kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWServiceProvidersDetailModel *model = self.dataArray[0];
    if (indexPath.row==3) {
        
        NSString *detailStr =[NSString stringWithFormat:@"%@",model.profile];
        
        CGFloat kHeight = [[ZWToolActon shareAction]adaptiveTextHeight:detailStr font:normalFont];
    
        return kHeight+0.23*kScreenWidth+50;
    }else {
        return 0.13*kScreenWidth;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return zw16B9ImageScale*kScreenWidth+20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWServiceProvidersDetailModel *model = self.dataArray[0];
    if (indexPath.row == 1) {
        NSString *telephoneNumber=model.telephone;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNumber];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:str];
        [application openURL:URL];
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZWServiceProvidersDetailModel *model = self.dataArray[0];
    return [self createShuffling:model.imagesUrl];
}

- (UIView *)createShuffling:(NSArray *)images {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *myImages = [NSMutableArray array];
    for (int i=0; i<images.count; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,images[i][@"url"]];
        [myImages addObject:imageStr];
    }
    
    DCCycleScrollView *banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, zw16B9ImageScale*kScreenWidth) shouldInfiniteLoop:YES imageGroups:myImages];
    banner.autoScrollTimeInterval = 5;
    banner.cellPlaceholderImage = [UIImage imageNamed:@"fu_img_no_02"];
    banner.autoScroll = YES;
    banner.isZoom = NO;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 0;
    banner.itemWidth = self.view.frame.size.width;
    banner.delegate = self;
    [view addSubview:banner];
    self.imageArray = myImages;
    
    return view;
}

//点击图片的代理
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.imageArray tapIndex:index];
}



@end
