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

#import "ZWShareManager.h"
#import "ZWShareModel.h"


@interface ZWExhibitionServerDetailVC ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSDictionary *detailData;

@property(nonatomic, strong)NSArray *caseArray;

@property(nonatomic, strong)NSArray *browseImages;

@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic, assign)BOOL isOpen;

@property(nonatomic, assign)CGFloat profileH;

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

-(SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.currentPageDotImage = [UIImage imageWithColor:[UIColor whiteColor] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        _cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        
    }
    return _cycleScrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
    [self createRequst];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"share_forward_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item {
    
    ZWShareModel *model = [[ZWShareModel alloc]init];
    model.shareUrl = [NSString stringWithFormat:@"%@/share-services/share-services.html?merchantId=%@",share_url,self.shareModel.providersId];
    model.shareTitleImage = [NSString stringWithFormat:@"%@%@",httpImageUrl,self.shareModel.imagesUrl];
    model.shareDetail = @"查看详情";
    model.shareName = self.shareModel.name;
    [[ZWShareManager shareManager]showShareAlertWithViewController:self withDataModel:model withExtension:@{} withType:0];
    
}

- (void)createUI {
    
    self.title = @"公司详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOpen = NO;
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
        self.cycleScrollView.imageURLStringsGroup = imageArray;
        self.browseImages = imageArray;
        [cell.contentView addSubview:self.cycleScrollView];
        
    }else if (indexPath.section == 1) {
        
        NSArray *images = @[@"exhibition_server_detail_tel_icon",@"exhibition_server_detail_addrss_icon"];
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0.035*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth)];
        titleImage.image = [UIImage imageNamed:images[indexPath.row]];
        [cell.contentView addSubview:titleImage];
        
        NSString *telephone = [NSString stringWithFormat:@"%@",self.detailData[@"telephone"]];
//        NSString *telephone = @"183545677855,021-80232332，000000000";
        NSArray  *array = [[ZWToolActon shareAction]strTurnArrayWithString:telephone];
        if (array.count>3) {
            array = [array subarrayWithRange:NSMakeRange(0, 3)];
        }
        if (indexPath.row == 0) {
            
            for (int i = 0; i<array.count; i++) {
                CGFloat leftWith = CGRectGetMaxX(titleImage.frame);
                if (array.count != 0) {
                    for (int i = 0; i<array.count ; i++) {
                        CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:array[i] labelFont:smallMediumFont];
                        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        phoneBtn.frame = CGRectMake(leftWith+5, 0, width, 0.1*kScreenWidth);
                        [phoneBtn setTitle:array[i] forState:UIControlStateNormal];
                        [phoneBtn setTitleColor:skinColor forState:UIControlStateNormal];
                        phoneBtn.titleLabel.font = smallMediumFont;
                        phoneBtn.tag = i;
                        [cell.contentView addSubview:phoneBtn];
                        [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        leftWith += width+5;
                    }
                }
            }
            
        }else {
            UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, 0, kScreenWidth-CGRectGetMaxX(titleImage.frame)-10, 0.1*kScreenWidth)];
            addressLabel.font = smallMediumFont;
            addressLabel.textColor = [UIColor grayColor];
            addressLabel.numberOfLines = 2;
            addressLabel.text = [NSString stringWithFormat:@"%@",self.detailData[@"address"]];
            [cell.contentView addSubview:addressLabel];
        }
        
    }else if (indexPath.section == 2) {
        
//        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.detailData[@"profile"] textFont:smallMediumFont textWidth:kScreenWidth-40];
        
        self.profileH = [self takeProfileHeightHeight];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, self.profileH)];
        contentLabel.text = [self takeProfileValue];
        contentLabel.font = smallMediumFont;
        contentLabel.textColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
        contentLabel.numberOfLines = 0;
        [cell.contentView addSubview:contentLabel];
        
        if ([self takeProfileValue].length > 80) {
            UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame), kScreenWidth, 0.1*kScreenWidth);
            if (self.isOpen == YES) {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }else {
                [moreBtn setTitle:@"点击此处查看全部" forState:UIControlStateNormal];
            }
            moreBtn.titleLabel.font = smallMediumFont;
            [moreBtn setTitleColor:skinColor forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(profileMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:moreBtn];
        }
        
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

        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:dataDic[@"imagesIntroduce"] textFont:smallMediumFont textWidth:CGRectGetWidth(view.frame)];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame)+0.03*kScreenWidth, CGRectGetWidth(view.frame), height)];
        detailLabel.text = dataDic[@"imagesIntroduce"];
        detailLabel.numberOfLines = 0;
        detailLabel.font = smallMediumFont;
        detailLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:detailLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(detailLabel.frame)+20, CGRectGetMaxY(detailLabel.frame)+20, CGRectGetWidth(detailLabel.frame)-40, 1)];
        lineView.backgroundColor = zwGrayColor;
        [cell.contentView addSubview:lineView];
        
    }
    
}

- (void)profileMoreBtnClick:(UIButton *)btn {
    self.isOpen = !self.isOpen;
    [self.tableView reloadData];
}

//获取完整的公司简介
- (NSString *)takeProfileValue {
    
    NSString *introduceStr;
    if (self.detailData[@"profile"] == 0) {
        introduceStr = @"暂无";
    }else {
        introduceStr = self.detailData[@"profile"];
    }
    return introduceStr;
    
}
//获取处理过后的简介
- (NSString *)takeIntroduceAfterTheProcessing {
    NSString *subString;
    if (self.isOpen == YES) {
        subString = [self takeProfileValue];
    }else {
        if ([self takeProfileValue].length >= 80) {
            subString = [NSString stringWithFormat:@"%@...",[[self takeProfileValue] substringWithRange:NSMakeRange(0, 80)]] ;
        }else {
            subString = [self takeProfileValue];
        }
    }
    return subString;
}

//计算公司简介需要返回的labal高度
- (CGFloat)takeProfileHeightHeight {
    NSString *subString;
    if (self.isOpen == YES) {
        subString = [self takeProfileValue];
    }else {
        if ([self takeProfileValue].length >= 80) {
            subString = [NSString stringWithFormat:@"%@...",[[self takeProfileValue] substringWithRange:NSMakeRange(0, 80)]] ;
        }else {
            subString = [self takeProfileValue];
        }
    }
    CGFloat profileHeight = [[ZWToolActon shareAction]adaptiveTextHeight:subString textFont:smallMediumFont textWidth:0.94*kScreenWidth];
    return profileHeight;
}


- (void)phoneBtnClick:(UIButton *)btn {
    [[ZWToolActon shareAction]dialTheNumber:btn.titleLabel.text];
}

//点击图片的代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
   NSLog(@"index = %ld",(long)index);
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.browseImages tapIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0.5*kScreenWidth;
    }else if (indexPath.section == 1) {
        return 0.1*kScreenWidth;
    }else if (indexPath.section == 2) {
        return self.profileH+0.1*kScreenWidth;
    }else {
        NSDictionary *dataDic = self.caseArray[indexPath.row];
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:dataDic[@"imagesIntroduce"] textFont:smallMediumFont textWidth:kScreenWidth-30];
        return 0.5*kScreenWidth+height+0.11*kScreenWidth+30;
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
    lineView.backgroundColor = [UIColor blackColor];
    lineView.layer.cornerRadius = 1.5;
    lineView.layer.masksToBounds = YES;
    [toolView addSubview:lineView];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, 0, 0.9*kScreenWidth, 0.1*kScreenWidth)];
    titleLabel.font = boldNormalFont;
    titleLabel.textColor = [UIColor blackColor];
    [toolView addSubview:titleLabel];

    if (section == 0) {
        titleLabel.text = self.detailData[@"name"];
    }else if (section == 1) {
        titleLabel.text = @"公司简介";
    }else if (section == 2) {
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
