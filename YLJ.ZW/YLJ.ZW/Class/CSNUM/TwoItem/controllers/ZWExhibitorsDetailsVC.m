//
//  ZWExhibitorsDetailsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//
#import "ZWExhibitorsDetailsVC.h"
#import "DCCycleScrollView.h"
#import "ZWProductCell.h"
#import "ZWExhibitorsSaveLocation.h"
#import "ZWNewDynamicModel.h"
#import "ZWExhibitorsDetailModel.h"
#import "ZWMineResponse.h"
#import "ZWExhibitorsContactModel.h"
#import "ZWProductDetailVC.h"
#import "ZWDynamicDetailVC.h"
#import "ZWShowDynamicVC.h"
#import <MBProgressHUD.h>
#import "ZWExExhibitorsDetailsVC.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <QuickLook/QuickLook.h>
#import "ZWIndustriesItemView.h"

#import "ZWExbihitorsIndustriesModel.h"
#import "ZWExhibitionNaviVC.h"

#import <YYLabel.h>
#import <NSAttributedString+YYText.h>

#import <YYText.h>

@interface ZWExhibitorsDetailsVC ()<UITableViewDataSource,UITableViewDelegate,DCCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,QLPreviewControllerDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)DCCycleScrollView *banner;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;

@property(nonatomic, strong)NSArray *productArray;
@property(nonatomic, strong)NSArray *dynamicsArray;
@property(nonatomic, strong)NSArray *contactArray;
@property(nonatomic, strong)ZWExhibitorsDetailModel *model;
@property(nonatomic, strong)NSArray *imageArray;

@property(nonatomic, strong)NSArray *dataImages;

//@property (nonatomic,strong) ZWNavExhibitorModel *ExhibitorModel;
@property (strong, nonatomic) QLPreviewController *previewController;
@property (copy, nonatomic) NSURL *fileURL;

@property(nonatomic, strong)NSArray *industries;

@end

@implementation ZWExhibitorsDetailsVC

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

-(UICollectionView *)collectView
{
    if (!_collectionView) {
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.4*kScreenWidth) collectionViewLayout:_layout];
    }
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZWProductCell class] forCellWithReuseIdentifier:@"ZWProductCell"];
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    return _collectionView;
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
    [self.view addSubview:self.tableView];
    
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=0.05*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"---2222----%ld",(long)self.contactArray.count);
    if (section == 6) {
        if (self.dynamicsArray.count == 0) {
            return 1;
        }else {
            return self.dynamicsArray.count;
        }
    }else if (section == 7) {
        if (self.contactArray.count == 0) {
            return 1;
        }else {
            return self.contactArray.count;
        }
    }else {
        return 1;
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat itemWidth = 0.86*kScreenWidth/5;
        CGFloat itemMargin = 0.01*kScreenWidth;
        NSArray *cutArray;
        if (self.industries.count > 5) {
            cutArray = [self.industries subarrayWithRange:NSMakeRange(0, 5)];
        }else {
            cutArray = self.industries;
        }
        for (int i = 0; i<cutArray.count; i++) {
            ZWExbihitorsIndustriesModel *model = self.industries[i];
            ZWIndustriesItemView *industriesItemView = [[ZWIndustriesItemView alloc]initWithFrame:CGRectMake(5*itemMargin+(itemMargin+itemWidth)*i, 0, itemWidth, itemWidth)];
            industriesItemView.backgroundColor = zwGrayColor;
            industriesItemView.layer.cornerRadius = 3;
            industriesItemView.layer.masksToBounds = YES;
            industriesItemView.model = model;
            [cell.contentView addSubview:industriesItemView];
        }
    }else if (indexPath.section == 1) {
        CGFloat unitH = 0.4*kScreenWidth/6;
        UIImageView *pdfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.022*kScreenWidth, 1.2*unitH, 1.5*unitH)];
        pdfImageView.image = [UIImage imageNamed:@"icon_pdf"];
        [cell.contentView addSubview:pdfImageView];
        
        NSArray *array = [self.model.productUrl componentsSeparatedByString:@","];
        
        UILabel *gsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pdfImageView.frame)+5, CGRectGetMinY(pdfImageView.frame)+2, 0.95*kScreenWidth-CGRectGetMaxX(pdfImageView.frame)-5, 0.025*kScreenWidth)];
        gsLabel.text = self.model.productUrl;
        gsLabel.font = smallFont;
        [cell.contentView addSubview:gsLabel];
        if (array[0]) {
            gsLabel.text = array[0];
        }else {
            gsLabel.text = @"暂无产品手册";
        }
        UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        preBtn.frame = CGRectMake(CGRectGetMinX(gsLabel.frame), CGRectGetMaxY(pdfImageView.frame)-0.75*unitH, 0.13*kScreenWidth, unitH);
        [preBtn setImage:[UIImage imageNamed:@"icon_yulan"] forState:UIControlStateNormal];
        [preBtn setTitle:@"预览" forState:UIControlStateNormal];
        [preBtn setTitleColor:skinColor forState:UIControlStateNormal];
        preBtn.titleLabel.font = smallMediumFont;
        [preBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:preBtn];
        
        UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadBtn.frame = CGRectMake(CGRectGetMaxX(preBtn.frame)+0.01*kScreenWidth, CGRectGetMinY(preBtn.frame), CGRectGetWidth(preBtn.frame), CGRectGetHeight(preBtn.frame));
        [downloadBtn setImage:[UIImage imageNamed:@"icon_xiazai"] forState:UIControlStateNormal];
        [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [downloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
        downloadBtn.titleLabel.font = smallMediumFont;
        [downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:downloadBtn];
    }else if (indexPath.section == 2) {
        NSString *mainStr;
        if (self.model.product.length == 0) {
            mainStr = @"暂无";
        }else {
            mainStr = self.model.product;
        }
        CGFloat mainHeight = [[ZWToolActon shareAction]adaptiveTextHeight:mainStr font:smallMediumFont];
        UILabel *mainValue = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, mainHeight)];
        mainValue.text = mainStr;
        mainValue.font = smallMediumFont;
        mainValue.numberOfLines = 0;
        [cell.contentView addSubview:mainValue];
    }else if (indexPath.section == 3) {
        
        NSString *demandStr;
        if (self.model.requirement.length == 0) {
            demandStr = @"暂无";
        }else {
            demandStr = self.model.requirement;
        }
        CGFloat demandHeight = [[ZWToolActon shareAction]adaptiveTextHeight:demandStr font:smallMediumFont];
        UILabel *demandValue = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, demandHeight)];
        demandValue.text = demandStr;
        demandValue.font = smallMediumFont;
        [cell.contentView addSubview:demandValue];
        
    }else if (indexPath.section == 4) {
        
        NSString *introduceStr;
        if (self.model.profile.length == 0) {
            introduceStr = @"暂无";
        }else {
            introduceStr = self.model.profile;
        }
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.profile font:smallMediumFont]+20;
        UILabel *introduceDetail = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, height)];
        introduceDetail.text = introduceStr;
        introduceDetail.font = smallMediumFont;
        introduceDetail.numberOfLines = 0;
        [cell.contentView addSubview:introduceDetail];
        
    }else if (indexPath.section == 5) {
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.productArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.4*kScreenWidth)];
            myNotice.text = @"暂无产品";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
        }else {
            [cell.contentView addSubview:self.collectionView];
        }
    }else if (indexPath.section == 6) {
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.dynamicsArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.4*kScreenWidth)];
            myNotice.text = @"暂无动态";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ZWNewDynamicModel *model = self.dynamicsArray[indexPath.row];
            UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.3*kScreenWidth, 0.2*kScreenWidth)];
            [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.images[@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
            [cell.contentView addSubview:titleImage];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, CGRectGetMinY(titleImage.frame), 0.95*kScreenWidth-CGRectGetMaxX(titleImage.frame)-5, 0.05*kScreenWidth)];
            titleLabel.font = smallMediumFont;
            titleLabel.text = model.exhibitionName;
            [cell.contentView addSubview:titleLabel];
            
            
            NSString *startTime =[[ZWToolActon shareAction] getTimeFromTimestamp:model.startTime withDataStr:@"YYYY-MM-DD"];
            NSString *endTime =[[ZWToolActon shareAction] getTimeFromTimestamp:model.endTime withDataStr:@"YYYY-MM-DD"];
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMidY(titleImage.frame)-0.03*kScreenWidth, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
            dateLabel.font = smallFont;
            dateLabel.text = [NSString stringWithFormat:@"%@~%@",startTime,endTime];
            [cell.contentView addSubview:dateLabel];
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMaxY(titleImage.frame)-0.06*kScreenWidth, CGRectGetWidth(dateLabel.frame), 0.06*kScreenWidth)];
            detailLabel.font = smallFont;
            if (model.exposition.length == 0) {
                detailLabel.text = @"展位号：暂无";
            }else {
                detailLabel.text = [NSString stringWithFormat:@"展位号：%@",model.exposition];
            }
            detailLabel.numberOfLines = 2;
            [cell.contentView addSubview:detailLabel];
        }
    }else {
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.contactArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.4*kScreenWidth)];
            myNotice.text = @"暂无联系人";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
        }else {
            ZWExhibitorsContactModel *model = self.contactArray[indexPath.row];
            CGFloat height = 0.25*kScreenWidth/3;
            CGFloat width = 0.9*kScreenWidth/2;

            UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.25*kScreenWidth)];
            toolView.backgroundColor = zwGrayColor;
            [cell.contentView addSubview:toolView];

            CALayer *layer = [toolView layer];
            layer.shadowOffset = CGSizeMake(0, 3); //(0,0)时是四周都有阴影
            layer.shadowRadius = 1.0;
            layer.shadowColor = [UIColor blackColor].CGColor;
            layer.shadowOpacity = 0.1;

            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, width, height)];
            nameLabel.text = [NSString stringWithFormat:@"联系人：%@",model.contacts];
            nameLabel.font = smallMediumFont;
            [toolView addSubview:nameLabel];

            UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, width, height)];
            positionLabel.text = [NSString stringWithFormat:@"职务：%@",model.post];
            positionLabel.font = smallMediumFont;
            [toolView addSubview:positionLabel];

            YYLabel *phoneLabel = [[YYLabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(nameLabel.frame), width, height)];
            phoneLabel.font = smallMediumFont;
            if ([model.type isEqualToString:@"0"]) {
                phoneLabel.text = @"手机：暂无";
            }else {
                NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机：%@",model.phone]];
                NSRange phoneRange = [[phoneString string]rangeOfString:model.phone];
                [phoneString setYy_color:[UIColor blackColor]];
                __weak typeof (self) weakSelf = self;
                [phoneString yy_setTextHighlightRange:phoneRange color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    [strongSelf takeCallWithValue:model.phone];
                }];
                phoneLabel.attributedText = phoneString;
            }
            [toolView addSubview:phoneLabel];
            
            YYLabel *telLabel = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), CGRectGetMinY(phoneLabel.frame), width, height)];
            NSMutableAttributedString *telString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话：%@",model.telephone]];
            NSRange telRange = [[telString string]rangeOfString:model.telephone];
            [telString setYy_color:[UIColor blackColor]];
            __weak typeof (self) weakSelf = self;
            [telString yy_setTextHighlightRange:telRange color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf takeCallWithValue:model.telephone];
            }];
            telLabel.attributedText = telString;
            [toolView addSubview:telLabel];


            UILabel *qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(phoneLabel.frame), width, height)];
            qqLabel.text = [NSString stringWithFormat:@"Q  Q：%@",model.qq];
            qqLabel.font = smallMediumFont;
            [toolView addSubview:qqLabel];

            UILabel *emalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(qqLabel.frame), CGRectGetMinY(qqLabel.frame), width, height)];
            emalLabel.text = [NSString stringWithFormat:@"邮箱：%@",model.mail];
            emalLabel.font = smallMediumFont;
            [toolView addSubview:emalLabel];
        }
    }
}

- (void)takeCallWithValue:(NSString *)value {
    NSLog(@"我的值是什么%@",value);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",value];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.86*kScreenWidth/5;
    }else if (indexPath.section == 1) {
        return 0.2*kScreenWidth;
    }else if (indexPath.section == 2) {
        NSString *mainStr;
        if (self.model.product == nil || [self.model.product isEqualToString:@""]) {
            mainStr = @"暂无";
        }else {
            mainStr = self.model.product;
        }
        CGFloat mainHeight = [[ZWToolActon shareAction]adaptiveTextHeight:mainStr font:smallMediumFont];
        return mainHeight;
    }else if (indexPath.section == 3) {
        NSString *demandStr;
        if (self.model.requirement == nil || [self.model.requirement isEqualToString:@""]) {
            demandStr = @"暂无";
        }else {
            demandStr = self.model.requirement;
        }
        CGFloat demandHeight = [[ZWToolActon shareAction]adaptiveTextHeight:demandStr font:normalFont];
        return demandHeight;
    }else if (indexPath.section == 4) {
        NSString *introduceStr;
        if (self.model.profile == nil || [self.model.profile isEqualToString:@""]) {
            introduceStr = @"暂无";
        }else {
            introduceStr = self.model.profile;
        }
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.model.profile font:smallMediumFont]+20;
        return height;
    }else if (indexPath.section == 5) {
        return 0.4*kScreenWidth;
    }else if (indexPath.section == 6) {
        if (self.dynamicsArray.count == 0) {
            return 0.4*kScreenWidth;
        }else {
            return 0.25*kScreenWidth;
        }
    } else {
        if (self.contactArray.count == 0) {
            return 0.45*kScreenWidth;
        }else {
            return 0.3*kScreenWidth;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return zw16B9ImageScale*kScreenWidth+0.1*kScreenWidth;
    }else {
        return 0.1*kScreenWidth;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *imageStr in self.imageArray) {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",httpImageUrl,imageStr];
            [images addObject:imageUrl];
        }
        
        self.dataImages = images;
        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, zw16B9ImageScale*kScreenWidth) shouldInfiniteLoop:YES imageGroups:images];
        self.banner.placeholderImage = [UIImage imageNamed:@"fu_img_no_02"];
        self.banner.autoScrollTimeInterval = 5;
        self.banner.autoScroll = YES;
        self.banner.isZoom = NO;
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 0;
        self.banner.itemWidth = kScreenWidth;
        self.banner.delegate = self;
        self.banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:self.banner];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, CGRectGetMaxY(self.banner.frame)+0.03*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth)];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.layer.cornerRadius = 0.005*kScreenWidth;
        lineView.layer.masksToBounds = YES;
        [view addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, CGRectGetMaxY(self.banner.frame), 0.5*kScreenWidth, 0.1*kScreenWidth)];
        titleLabel.text = @"所属行业";
        titleLabel.font = boldNormalFont;
        [view addSubview:titleLabel];
        
    } else {
        
        if (section != 0 ) {
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.03*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth)];
            lineView.backgroundColor = [UIColor blackColor];
            lineView.layer.cornerRadius = 0.005*kScreenWidth;
            lineView.layer.masksToBounds = YES;
            [view addSubview:lineView];
            
            NSArray *titles = @[@"产品手册",@"主营项目",@"需求说明",@"公司简介",@"产品展示",@"参展动态",@"联系方式"];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, 0, 0.5*kScreenWidth, 0.1*kScreenWidth)];
            titleLabel.text = titles[section-1];
            titleLabel.font = boldNormalFont;
            [view addSubview:titleLabel];
            
            if (section == 6) {
                
                CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:@"更多" labelFont:smallMediumFont];
                UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                moreBtn.frame = CGRectMake(kScreenWidth-width-0.08*kScreenWidth, 0, width, 0.1*kScreenWidth);
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
                moreBtn.titleLabel.font = smallMediumFont;
                [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [view addSubview:moreBtn];
                
                UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                arrowBtn.frame = CGRectMake(CGRectGetMaxX(moreBtn.frame), 0.035*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
                [arrowBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_icon"] forState:UIControlStateNormal];
                [view addSubview:arrowBtn];
                
                UIButton *jumpMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                jumpMoreBtn.frame = CGRectMake(0.6*kScreenWidth, 0, 0.4*kScreenWidth, 0.1*kScreenWidth);
                [jumpMoreBtn addTarget:self action:@selector(jumpMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:jumpMoreBtn];
                
            }
            
        }
        
    }
    
    return view;
    
}

- (void)jumpMoreBtnClick:(UIButton *)btn {
    ZWShowDynamicVC *VC = [[ZWShowDynamicVC alloc]init];
    VC.exhibitorId = self.merchantId;
    VC.title = @"动态列表";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 6) {
        if (self.dynamicsArray.count != 0) {
            ZWNewDynamicModel *model = self.dynamicsArray[indexPath.row];
            
            NSLog(@"------%@",model.purchased?@"yes":@"no");
            
            if ([model.purchased boolValue] == false) {
                __weak typeof (self) weakSelf = self;
                [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"对不起，您未购买该展会，无法查看此展商在该展会下的详细信息，您可以进入该展会详情的展会展商进行购买，是否前去购买？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
                    naviVC.title = @"展会导航";
                    naviVC.exhibitionId = model.exhibitionId;
                    naviVC.price = model.price;
                    [strongSelf.navigationController pushViewController:naviVC animated:YES];
                } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {

                } showInView:self];
            }else {
                ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
                detailsVC.title = @"展商详情";
                detailsVC.exhibitorId = model.exhibitorId;
                detailsVC.merchantId = model.merchantId;
                [self.navigationController pushViewController:detailsVC animated:YES];
            }
        }
    }
}

#define DCCycleScrollViewDelegate
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);    
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.dataImages tapIndex:index];
}


#pragma UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWProductListModel *model = self.productArray[indexPath.row];
    ZWProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWProductCell" forIndexPath:indexPath];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    cell.titleLabel.text = model.name;
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.font = smallFont;
    cell.backgroundColor = zwGrayColor;
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((0.8*kScreenWidth)/3, (0.8*kScreenWidth)/3+0.08*kScreenWidth);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZWProductListModel *model = self.productArray[indexPath.row];
    ZWProductDetailVC *vc = [[ZWProductDetailVC alloc]init];
    vc.productId = model.productId;
    vc.productType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

//*********************************************************网络请求*****************************************************
- (void)createRequest {
    [self requestExhibitorsDetail];//获取展商详情
}

- (void)requestExhibitorsDetail {
    
    NSLog(@"------%@",self.merchantId);
    if (self.merchantId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsDetails parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                
                NSArray *myIndustries = data[@"data"][@"industryList"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myIndustries) {
                    ZWExbihitorsIndustriesModel *model = [ZWExbihitorsIndustriesModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                
                strongSelf.industries = myArray;
            
                strongSelf.imageArray = data[@"data"][@"images"];
                NSDictionary *myData = data[@"data"][@"zwMerchantVo"];
                ZWExhibitorsDetailModel *model = [ZWExhibitorsDetailModel parseJSON:myData];
                strongSelf.model = model;
                [strongSelf requestProductList];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        }];
    }
}

- (void)requestProductList {
    if (self.merchantId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsProductList parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                NSArray *myData = data[@"data"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWProductListModel *model = [ZWProductListModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                strongSelf.productArray = myArray;
//                [strongSelf.collectView reloadData];
                [strongSelf requestDynamicList];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)requestDynamicList {
    if (self.merchantId) {
           NSDictionary *parametes = @{@"merchantId":self.merchantId,
                                       @"pageNo":@"1",
                                       @"pageSize":@"2"};
           __weak typeof (self) weakSelf = self;
           [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsNewDynamic parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
               __strong typeof (weakSelf) strongSelf = weakSelf;
               if (zw_issuccess) {
                   NSArray *myData = data[@"data"][@"result"];
                   NSLog(@"-----------------------%@",data[@"data"]);
                   NSMutableArray *myArray = [NSMutableArray array];
                   for (NSDictionary *myDic in myData) {
                       ZWNewDynamicModel *model = [ZWNewDynamicModel parseJSON:myDic];
                       [myArray addObject:model];
                   }
                   strongSelf.dynamicsArray = myArray;
                   
//                   [strongSelf.tableView reloadData];
                   [strongSelf requestContactList];
               }
           } failureBlock:^(NSError * _Nonnull error) {
               
           }];
           
       }
}

- (void)requestContactList {//,@"status":@"2"
    if (self.merchantId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExhibitorsContactList parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
               NSArray *myData = data[@"data"];
               NSMutableArray *myArray = [NSMutableArray array];
               for (NSDictionary *myDic in myData) {
                   ZWExhibitorsContactModel *model = [ZWExhibitorsContactModel parseJSON:myDic];
                   [myArray addObject:model];
               }
               strongSelf.contactArray = myArray;
               [strongSelf.tableView reloadData];
               [strongSelf.collectView reloadData];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        }];
    }
}

- (void)browseBtnClick:(UIButton *)btn {
    if (! self.model.productUrl||[self.model.productUrl isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"暂无产品手册"];
        return;
    }
    NSLog(@"%@",self.model.productUrl);

    [self downloadWithUrl:self.model.productUrl withType:0];
}

- (void)downloadBtnClick:(UIButton *)btn {
   if (! self.model.productUrl||[self.model.productUrl isEqualToString:@""]) {
       [self showOneAlertWithMessage:@"暂无产品手册"];
       return;
   }
    [self downloadWithUrl:self.model.productUrl withType:1];
}

//下载文件
- (void)downloadWithUrl:(NSString *)URLStr withType:(NSInteger)type {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSArray *array = [URLStr componentsSeparatedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,[array objectAtIndex:1]];
    NSString *fileName = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        self.fileURL = url;
        if (type == 0) {
            [self presentViewController:self.previewController animated:YES completion:nil];
        }else {
            [self shareLog:url];
        }
    }else {
        [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
        __weak typeof (self) weakSelf = self;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:[strongSelf getCurrentVC].view animated:YES];
            strongSelf.fileURL = filePath;
            if (type == 0) {
                [strongSelf presentViewController:strongSelf.previewController animated:YES completion:nil];
            }else {
                [strongSelf shareLog:filePath];
            }
        }];
        [downloadTask resume];
    }
    
}

#pragma mark - QLPreviewControllerDataSource
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}

//判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
    
}

-(void)shareLog:(NSURL *)fileURL{
    //在iOS 11不显示分享选项了
    //定义URL数组
    NSArray *urls=@[fileURL];
    //创建分享的类型,注意这里没有常见的微信,朋友圈以QQ等,但是罗列完后,实际运行是相应按钮的,所以可以运行.
    UIActivityViewController *activituVC=[[UIActivityViewController alloc]initWithActivityItems:urls applicationActivities:nil];
    NSArray *cludeActivitys=@[UIActivityTypePostToFacebook,
                              UIActivityTypePostToTwitter,
                              UIActivityTypePostToWeibo,
                              UIActivityTypePostToVimeo,
                              UIActivityTypeMessage,
                              UIActivityTypeMail,
                              UIActivityTypeCopyToPasteboard,
                              UIActivityTypePrint,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToTencentWeibo];
    activituVC.excludedActivityTypes=cludeActivitys;
    //显示分享窗口
    [self presentViewController:activituVC animated:YES completion:nil];
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
