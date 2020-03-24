//
//  ZWExhibitionNaviVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionNaviVC.h"
#import "ZWExExhibitorsVC.h"
#import "DCCycleScrollView.h"
#import "ZWExhibitionNaviModel.h"
#import "ZWImageBrowser.h"
#import "UIView+Ext.h"
@interface ZWExhibitionNaviVC ()<UITableViewDelegate,UITableViewDataSource,DCCycleScrollViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataSource;
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, strong)NSArray *dataImages;
@property(nonatomic, strong)UIImageView *myImage;

@property(nonatomic, strong)NSMutableArray *imageViewsArray;

@property(nonatomic, assign)CGFloat imageHeight;

@end

@implementation ZWExhibitionNaviVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
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
    [[YNavigationBar sharedInstance]createSkinNavigationBar:self.navigationController.navigationBar withBackColor:skinColor withTintColor:[UIColor whiteColor]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
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
    self.imageViewsArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];

    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenHeight-zwTabBarHeight-zwNavBarHeight, kScreenWidth-30, 0.1*kScreenWidth)];
    bottomBtn.backgroundColor = skinColor;
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [bottomBtn setTitle:@"进入展会展商" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = boldNormalFont;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
}
- (void)bottomBtnClick:(UIButton *)btn {
    ZWExhibitionNaviModel *model = self.dataSource[0];
    ZWExExhibitorsVC *exhibitorsVC = [[ZWExExhibitorsVC alloc]init];
    exhibitorsVC.hidesBottomBarWhenPushed = YES;
    exhibitorsVC.title = @"展商列表";
    exhibitorsVC.exhibitionId = model.exhibitionId;
    exhibitorsVC.price = self.price;
    exhibitorsVC.exExhibitorsNum = model.merchantCount;
    exhibitorsVC.nExExhibitorsNum = model.nExhibitorCount;
    [self.navigationController pushViewController:exhibitorsVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
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
    
    NSMutableArray *https = [NSMutableArray array];
    for (NSString *urlStr in self.imageArray) {
        NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,urlStr];
        [https addObject:url];
    }
    self.myImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 0.6*kScreenWidth)];
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",https[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.myImage.contentMode = UIViewContentModeScaleAspectFill;
    self.myImage.layer.cornerRadius = 5;
    self.myImage.layer.masksToBounds = YES;
    [cell.contentView addSubview:self.myImage];
    
    [self.imageViewsArray addObject:self.myImage];
    
    NSLog(@"-------%@",self.imageViewsArray);
    
}

- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.dataImages tapIndex:index];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.6*kScreenWidth+40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 273+0.5 *kScreenWidth;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return zwTabBarHeight+15;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tools = [[UIView alloc]init];
    tools.backgroundColor = [UIColor whiteColor];
    ZWExhibitionNaviModel *model = self.dataSource[0];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 50)];
    titleLabel.text = model.exhibitionName;
    titleLabel.font = normalFont;
    titleLabel.numberOfLines = 0;
    [tools addSubview:titleLabel];
    
    UILabel *titleOne = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+8, CGRectGetWidth(titleLabel.frame), 20)];
    titleOne.text = @"展厅展位图";
    titleOne.font = boldNormalFont;
    [tools addSubview:titleOne];
    
    NSMutableArray *https = [NSMutableArray array];
    for (NSString *urlName in model.topImagesUrl) {
        NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,urlName];
        [https addObject:url];
    }
    
    DCCycleScrollView *banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(20, CGRectGetMaxY(titleOne.frame)+10, kScreenWidth-40, 0.5*kScreenWidth) shouldInfiniteLoop:YES imageGroups:https];
    banner.layer.cornerRadius = 5;
    banner.layer.masksToBounds = YES;
    banner.autoScrollTimeInterval = 5;
    banner.cellPlaceholderImage = [UIImage imageNamed:@"fu_img_no_02"];
    banner.autoScroll = YES;
    banner.isZoom = NO;
    banner.itemSpace = 0;
    banner.imgCornerRadius = 0;
    banner.itemWidth = kScreenWidth-30;
    banner.delegate = self;
    banner.layer.borderColor = zwGrayColor.CGColor;
    banner.layer.borderWidth = 5;
    [tools addSubview:banner];
    self.dataImages = https;
    
    UILabel *titleTwo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(banner.frame), CGRectGetMaxY(banner.frame)+10, CGRectGetWidth(banner.frame), CGRectGetHeight(titleOne.frame))];
    titleTwo.text = @"展会信息";
    titleTwo.font = boldNormalFont;
    [tools addSubview:titleTwo];
    
    NSString *startTime = [model.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *endTime = [model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleTwo.frame), CGRectGetMaxY(titleTwo.frame)+5, CGRectGetWidth(titleTwo.frame), CGRectGetHeight(titleTwo.frame))];
    dateLabel.text = [NSString stringWithFormat:@"展会时间：%@~%@",startTime,endTime];
    dateLabel.font = normalFont;
    dateLabel.numberOfLines = 0;
    [tools addSubview:dateLabel];
    
    UILabel *pavilionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(dateLabel.frame)+5, CGRectGetWidth(dateLabel.frame), CGRectGetHeight(dateLabel.frame))];
    pavilionLabel.text = [NSString stringWithFormat:@"展馆名称：%@",model.hallName];
    pavilionLabel.font = normalFont;
    pavilionLabel.numberOfLines = 0;
    [tools addSubview:pavilionLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(pavilionLabel.frame), CGRectGetMaxY(pavilionLabel.frame)+5, CGRectGetWidth(pavilionLabel.frame), CGRectGetHeight(pavilionLabel.frame))];
    numberLabel.text = [NSString stringWithFormat:@"展商数量：%@家",model.merchantCount];
    numberLabel.font = normalFont;
    numberLabel.numberOfLines = 0;
    [tools addSubview:numberLabel];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(numberLabel.frame), CGRectGetMaxY(numberLabel.frame)+5, CGRectGetWidth(numberLabel.frame), CGRectGetHeight(numberLabel.frame))];
    newLabel.text = [NSString stringWithFormat:@"新品展商：%@家",model.nExhibitorCount];
    newLabel.font = normalFont;
    newLabel.numberOfLines = 0;
    [tools addSubview:newLabel];
    
    UILabel *titleThree = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(newLabel.frame), CGRectGetMaxY(newLabel.frame)+10, CGRectGetWidth(newLabel.frame), CGRectGetHeight(newLabel.frame))];
    titleThree.text = @"展馆鸟瞰图";
    titleThree.font = boldNormalFont;
    [tools addSubview:titleThree];
    
//    [self convertImage:https];
    
    return tools;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ZWImageBrowser showImageV_img:self.imageViewsArray[indexPath.row]];
}

//获取展会导航数据
- (void)createRequest {
    NSDictionary *parametes;
    if (self.exhibitionId) {
        parametes = @{@"exhibitionId":self.exhibitionId};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwOnlineExhibitionNavigation parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            ZWExhibitionNaviModel *model = [ZWExhibitionNaviModel parseJSON:myData];
            [myArray addObject:model];
            strongSelf.dataSource = myArray;
            strongSelf.imageArray = model.belowImagesUrl;
            [strongSelf.tableView reloadData];
        }else {
            
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
}


- (void)convertImage:(NSArray *)httpImageName {
    if (httpImageName) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *url in httpImageName) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
            if (!data) {
                UIImage *image = [UIImage imageNamed:@"fu_img_no_02"]; // 取得图片
                [images addObject:image];
            }else{
                UIImage *image = [UIImage imageWithData:data]; // 取得图片
                [images addObject:image];
            }
        }
        self.dataImages = images;
    }
}

@end
