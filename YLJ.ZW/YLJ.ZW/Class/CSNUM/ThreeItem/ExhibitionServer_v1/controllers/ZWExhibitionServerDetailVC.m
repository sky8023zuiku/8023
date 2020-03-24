//
//  ZWExhibitionServerDetailVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/17.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionServerDetailVC.h"
#import <SDCycleScrollView.h>
#import "UIImage+ZWCustomImage.h"
#import "ZWExhibitionSeverDetailView.h"
#import "ZWExhibitionServerDetailCaseModel.h"


@interface ZWExhibitionServerDetailVC ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSDictionary *detailData;

@property(nonatomic, strong)NSArray *caseArray;

@end

@implementation ZWExhibitionServerDetailVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createRequst];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.title = @"公司详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else if (section == 2) {
        return 1;
    }else {
        return self.caseArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self createTableWithCell:cell withIndex:indexPath];
    
    return cell;
}

- (void)createTableWithCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        NSArray *imageAr = self.detailData[@"imagesUrl"];
        NSMutableArray *imageArray = [NSMutableArray array];
        if (imageAr) {
            for (NSDictionary *urlDic in imageAr) {
                NSLog(@"----%@",urlDic);
                if (![urlDic isKindOfClass:[NSNull class]]) {
                    NSString *my = [NSString stringWithFormat:@"%@%@",httpImageUrl,urlDic[@"url"]];
                    NSString *urlStr = [[ZWToolActon shareAction]transcodWithUrl:my];
                    [imageArray addObject:urlStr];
                }
            }
        }
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.delegate = self;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        cycleScrollView.showPageControl = YES;
//        cycleScrollView.localizationImageNamesGroup = @[@"h1.jpg",@"h2.jpg",@"h3.jpg"];
        cycleScrollView.imageURLStringsGroup = imageArray;
        cycleScrollView.autoScrollTimeInterval = 3;
        cycleScrollView.currentPageDotImage = [UIImage imageWithColor:[UIColor whiteColor] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        [cell.contentView addSubview:cycleScrollView];
    }else if (indexPath.section == 1) {
        
        NSArray *images = @[@"exhibition_server_detail_tel_icon",@"exhibition_server_detail_addrss_icon"];
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.01*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth)];
        titleImage.image = [UIImage imageNamed:images[indexPath.row]];
        [cell.contentView addSubview:titleImage];
        
        NSString *address = [NSString stringWithFormat:@"%@",self.detailData[@"address"]];
        NSString *telephone = [NSString stringWithFormat:@"%@",self.detailData[@"telephone"]];
        NSArray *values = @[telephone,address];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, 0, kScreenWidth-CGRectGetMaxX(titleImage.frame)-10, 0.05*kScreenWidth)];
        detailLabel.text = values[indexPath.row];
        detailLabel.font = smallMediumFont;
        detailLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
        [cell.contentView addSubview:detailLabel];
        
    }else if (indexPath.section == 2) {
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.detailData[@"profile"] font:smallMediumFont];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, height)];
        contentLabel.text =self.detailData[@"profile"];
        contentLabel.font = smallMediumFont;
        contentLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
        contentLabel.numberOfLines = 0;
        [cell.contentView addSubview:contentLabel];
        
    }else {
        
        NSDictionary *dataDic = self.caseArray[indexPath.row];
        
        NSArray *imageData = dataDic[@"productImages"];
        NSMutableArray<ZWExhibitionServerDetailCaseModel *> *imageArray = [NSMutableArray array];
        for (NSDictionary *myDic in imageData) {
            ZWExhibitionServerDetailCaseModel *model = [ZWExhibitionServerDetailCaseModel parseJSON:myDic];
            [imageArray addObject:model];
        }
        
//        NSArray *arr = @[@[@"h1.jpg"],
//                       @[@"h1.jpg",@"h2.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h1.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h2.jpg",@"h1.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h1.jpg",@"h2.jpg",@"h3.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h2.jpg",@"h1.jpg",@"h3.jpg",@"h2.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h2.jpg",@"h1.jpg"],
//                       @[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h1.jpg",@"h2.jpg",@"h1.jpg"]];
    
        ZWExhibitionSeverDetailView *view = [[ZWExhibitionSeverDetailView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 0.5*kScreenWidth) imagesArray:imageArray];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [cell.contentView addSubview:view];
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:dataDic[@"imagesIntroduce"] font:smallMediumFont];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame), CGRectGetWidth(view.frame), height)];
        detailLabel.text = dataDic[@"imagesIntroduce"];
        detailLabel.numberOfLines = 0;
        detailLabel.font = smallMediumFont;
        [cell.contentView addSubview:detailLabel];
        
    }
    
}

//点击图片的代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
   NSLog(@"index = %ld",(long)index);
//    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.dataImages tapIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0.5*kScreenWidth;
    }else if (indexPath.section == 1) {
        return 0.07*kScreenWidth;
    }else if (indexPath.section == 2) {
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.detailData[@"profile"] font:smallMediumFont];
        return height+20;
    }else {
        NSDictionary *dataDic = self.caseArray[indexPath.row];
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:dataDic[@"imagesIntroduce"] font:smallMediumFont];
        return 0.5*kScreenWidth+height+0.08*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1*kScreenWidth;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *toolView = [[UIView alloc]init];
    toolView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 12.5, 3, 0.1*kScreenWidth-25)];
    lineView.backgroundColor = skinColor;
    lineView.layer.cornerRadius = 1.5;
    lineView.layer.masksToBounds = YES;
    [toolView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, 0, 0.9*kScreenWidth, 0.1*kScreenWidth)];
    titleLabel.font = normalFont;
    titleLabel.textColor = skinColor;
    [toolView addSubview:titleLabel];
    
    if (section == 0) {
        lineView.backgroundColor = skinColor;
        titleLabel.text = self.detailData[@"name"];
    }else if (section == 1) {
        lineView.backgroundColor = skinColor;
        titleLabel.text = @"公司简介";
    }else if (section == 2) {
        lineView.backgroundColor = skinColor;
        titleLabel.text = @"产品案例";
    }else {
        lineView.backgroundColor = [UIColor clearColor];
    }
    
    return toolView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)createRequst {
    [[ZWDataAction sharedAction]getReqeustWithURL:zwGetExhibitionServerDetail parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            self.detailData = data[@"data"][@"serviceProviderDetails"];
            NSLog(@"%@",data);
            self.caseArray = data[@"data"][@"productList"];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
