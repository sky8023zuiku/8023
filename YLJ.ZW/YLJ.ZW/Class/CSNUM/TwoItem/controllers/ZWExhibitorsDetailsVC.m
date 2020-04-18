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

#import "UButton.h"

#import "ZWShareModel.h"
#import "ZWShareManager.h"

#import "ZWExExhibitorsModel.h"




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

@property (strong, nonatomic) QLPreviewController *previewController;
@property (copy, nonatomic) NSURL *fileURL;

@property(nonatomic, strong)NSArray *industries;

@property(nonatomic, assign)BOOL isOpen;

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
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}

//-(UICollectionView *)collectView
//{
//    if (!_collectionView) {
//        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.4*kScreenWidth) collectionViewLayout:_layout];
//    }
//    _collectionView.delegate=self;
//    _collectionView.dataSource=self;
//    _collectionView.backgroundColor = [UIColor whiteColor];
//    [_collectionView registerClass:[ZWProductCell class] forCellWithReuseIdentifier:@"ZWProductCell"];
//    _collectionView.showsVerticalScrollIndicator=NO;
//    _collectionView.showsHorizontalScrollIndicator=NO;
//    _collectionView.showsVerticalScrollIndicator = NO;
//    return _collectionView;
//}

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
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"share_forward_icon"] barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UIBarButtonItem *)item {
    
    ZWShareModel *model = [[ZWShareModel alloc]init];
    model.shareName = self.shareModel.name;
    model.shareTitleImage = [NSString stringWithFormat:@"%@%@",httpImageUrl,self.shareModel.imageUrl];
    model.shareUrl = [NSString stringWithFormat:@"%@/html/share_merchants.html?merchantId=%@",share_url,self.shareModel.merchantId];
    model.shareDetail = @"查看详情";
    [[ZWShareManager shareManager]shareWithData:model];
    
}
- (void)createUI {
    
    self.isOpen = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.minimumLineSpacing=0.025*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }else if (section == 4) {
        return 1;
    }else if (section == 5) {
        if (self.dynamicsArray.count == 0) {
            return 1;
        }else {
            return self.dynamicsArray.count;
        }
    }else {
        if (self.contactArray.count == 0) {
            return 1;
        }else {
            return self.contactArray.count;
        }
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
        [cell.contentView addSubview:self.banner];
        
    }else if (indexPath.section == 1) {
        
        NSArray *titleArray = @[@"产品手册：",@"需求说明：",@"主营项目："];
        CGFloat PHeight = [[ZWToolActon shareAction]adaptiveTextHeight:@"占位" textFont:smallMediumFont textWidth:0.18*kScreenWidth];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.18*kScreenWidth, PHeight)];
        titleLabel.font = smallMediumFont;
        titleLabel.text = titleArray[indexPath.row];
        titleLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:titleLabel textAlignmentWith:CGRectGetWidth(titleLabel.frame)];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row == 0) {
            
            UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            browseBtn.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), 0.1*kScreenWidth, PHeight);
            browseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [browseBtn setTitle:@"预览" forState:UIControlStateNormal];
            [browseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            browseBtn.titleLabel.font = smallMediumFont;
            [cell.contentView addSubview:browseBtn];
            
            UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downloadBtn.frame = CGRectMake(CGRectGetMaxX(browseBtn.frame), CGRectGetMinY(browseBtn.frame), CGRectGetWidth(browseBtn.frame), CGRectGetHeight(browseBtn.frame));
            downloadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
            [downloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
            [downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            downloadBtn.titleLabel.font = smallMediumFont;
            [cell.contentView addSubview:downloadBtn];
            
        }else if (indexPath.row == 1) {
            CGFloat demandHeight = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeDemandValue] textFont:smallMediumFont textWidth:0.76*kScreenWidth];
            UILabel *demandValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), 0.76*kScreenWidth, demandHeight)];
            demandValue.text = [self takeDemandValue];
            demandValue.font = smallMediumFont;
            [cell.contentView addSubview:demandValue];
            
        }else {
            
            CGFloat mainHeight = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeMainValue] textFont:smallMediumFont textWidth:0.76*kScreenWidth];
            UILabel *mainValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), 0.76*kScreenWidth, mainHeight)];
            mainValue.text = [self takeMainValue];
            mainValue.font = smallMediumFont;
            mainValue.numberOfLines = 0;
            [cell.contentView addSubview:mainValue];
                    
        }
        
    }else if (indexPath.section == 2) {
        
        CGFloat itemWidth = 0.82*kScreenWidth/5;
        CGFloat itemMargin = 0.03*kScreenWidth;
        NSArray *cutArray;
        if (self.industries.count > 5) {
            cutArray = [self.industries subarrayWithRange:NSMakeRange(0, 5)];
        }else {
            cutArray = self.industries;
        }
        for (int i = 0; i<cutArray.count; i++) {
            
            ZWExbihitorsIndustriesModel *model = self.industries[i];
            ZWIndustriesItemView *industriesItemView = [[ZWIndustriesItemView alloc]initWithFrame:CGRectMake(itemMargin+(itemMargin+itemWidth)*i, 0.03*kScreenWidth, itemWidth, itemWidth)];
            industriesItemView.backgroundColor = zwGrayColor;
            industriesItemView.layer.cornerRadius = 3;
            industriesItemView.layer.masksToBounds = YES;
            industriesItemView.model = model;
            [cell.contentView addSubview:industriesItemView];

        }
                   
    }else if (indexPath.section == 3) {

        UILabel *introduceDetail = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.94*kScreenWidth, [self takeIntroduceHeight])];
//        introduceDetail.text = [self takeIntroduceValue];
        introduceDetail.text = [self takeIntroduceAfterTheProcessing];
        introduceDetail.font = smallMediumFont;
        introduceDetail.numberOfLines = 0;
        [cell.contentView addSubview:introduceDetail];
        
        if ([self takeIntroduceValue].length > 80) {
            UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = CGRectMake(0, CGRectGetMaxY(introduceDetail.frame), kScreenWidth, 0.1*kScreenWidth);
            if (self.isOpen == YES) {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }else {
                [moreBtn setTitle:@"点击此处查看全部" forState:UIControlStateNormal];
            }
            moreBtn.titleLabel.font = smallMediumFont;
            [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(introduceMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:moreBtn];
        }
        
    }else if (indexPath.section == 4) {
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.productArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.94*kScreenWidth, 0.4*kScreenWidth-20)];
            myNotice.text = @"暂无产品";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
        }else {
            
            if (self.productArray.count <=3 ) {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.025*kScreenWidth, 0.94*kScreenWidth, 0.4*kScreenWidth) collectionViewLayout:_layout];
            }else if (self.productArray.count <= 6 && self.productArray.count >3) {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.025*kScreenWidth, 0.94*kScreenWidth, 0.8*kScreenWidth) collectionViewLayout:_layout];
            }else {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.025*kScreenWidth, 0.94*kScreenWidth, 1.2*kScreenWidth) collectionViewLayout:_layout];
            }
            
            _collectionView.delegate=self;
            _collectionView.dataSource=self;
            _collectionView.backgroundColor = [UIColor whiteColor];
            [_collectionView registerClass:[ZWProductCell class] forCellWithReuseIdentifier:@"ZWProductCell"];
            _collectionView.showsVerticalScrollIndicator=NO;
            _collectionView.showsHorizontalScrollIndicator=NO;
            _collectionView.showsVerticalScrollIndicator = NO;
            [cell.contentView addSubview:self.collectionView];
        }
    }else if (indexPath.section == 5) {
        
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.dynamicsArray.count == 0) {
            
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.94*kScreenWidth, 0.4*kScreenWidth-20)];
            myNotice.text = @"暂无动态";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
                    
        }else {
            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ZWNewDynamicModel *model = self.dynamicsArray[indexPath.row];
            UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.025*kScreenWidth, 0.3*kScreenWidth, 0.2*kScreenWidth)];
            [titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.images[@"url"]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
            [cell.contentView addSubview:titleImage];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+5, CGRectGetMinY(titleImage.frame), 0.95*kScreenWidth-CGRectGetMaxX(titleImage.frame)-5, 0.05*kScreenWidth)];
            titleLabel.font = smallMediumFont;
            titleLabel.text = model.exhibitionName;
            [cell.contentView addSubview:titleLabel];
            
            NSString *startTime =  [NSString stringWithFormat:@"%@",model.startTime];
            NSString *endTime =  [NSString stringWithFormat:@"%@",model.endTime];
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMidY(titleImage.frame)-0.03*kScreenWidth, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
            dateLabel.font = smallFont;
            dateLabel.text = [NSString stringWithFormat:@"%@~%@",[startTime substringToIndex:10],[endTime substringToIndex:10]];
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
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.94*kScreenWidth, 0.4*kScreenWidth-20)];
            myNotice.text = @"暂无联系人";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
                    
        }else {
            
            ZWExhibitorsContactModel *model = self.contactArray[indexPath.row];
            CGFloat height = 0.28*kScreenWidth/8;
            CGFloat magin = 0.28*kScreenWidth/2/5;
            CGFloat width = 0.9*kScreenWidth/2;
            
            UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 10, 0.94*kScreenWidth, 0.28*kScreenWidth)];
            toolView.backgroundColor = zwGrayColor;
            toolView.layer.cornerRadius = 5;
            toolView.layer.masksToBounds = YES;
            [cell.contentView addSubview:toolView];
                        
            //联系人
            ZWLeftImageBtn *nameBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, magin, width, height)];
            if (model.contacts.length == 0) {
                [nameBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [nameBtn setTitle:model.contacts forState:UIControlStateNormal];
            }
            [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [nameBtn setImage:[UIImage imageNamed:@"exhibitor_contcet_name_cion"] forState:UIControlStateNormal];
            nameBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:nameBtn];
            
            //职务
            ZWLeftImageBtn *positionBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameBtn.frame), CGRectGetMinY(nameBtn.frame), width, height)];
            if (model.post.length == 0) {
                [positionBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [positionBtn setTitle:model.post forState:UIControlStateNormal];
            }
            [positionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [positionBtn setImage:[UIImage imageNamed:@"exhibitor_position_icon"] forState:UIControlStateNormal];
            positionBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:positionBtn];
            
            //手机
            ZWLeftImageBtn *phoneBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(nameBtn.frame), CGRectGetMaxY(nameBtn.frame)+magin, width, height)];
            if (model.phone.length == 0) {
                [phoneBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [phoneBtn setTitle:model.phone forState:UIControlStateNormal];
                [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [phoneBtn setTitleColor:skinColor forState:UIControlStateNormal];
            [phoneBtn setImage:[UIImage imageNamed:@"exhibitor_contects_phone"] forState:UIControlStateNormal];
            phoneBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:phoneBtn];
            
            //电话
            ZWLeftImageBtn *telBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneBtn.frame), CGRectGetMinY(phoneBtn.frame), width, height)];
            if (model.telephone.length == 0) {
                [telBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [telBtn setTitle:model.telephone forState:UIControlStateNormal];
                [telBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [telBtn setTitleColor:skinColor forState:UIControlStateNormal];
            [telBtn setImage:[UIImage imageNamed:@"exhibitors_contects_tel_icon"] forState:UIControlStateNormal];
            telBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:telBtn];
                        
            //qq
            ZWLeftImageBtn *qqBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneBtn.frame), CGRectGetMaxY(telBtn.frame)+magin, 2*width, height)];
            if (model.qq.length == 0) {
                [qqBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [qqBtn setTitle:model.qq forState:UIControlStateNormal];
            }
            [qqBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [qqBtn setImage:[UIImage imageNamed:@"exhibitor_contects_qq_icon"] forState:UIControlStateNormal];
            qqBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:qqBtn];
            
            //邮箱
            ZWLeftImageBtn *emailBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(qqBtn.frame), CGRectGetMaxY(qqBtn.frame)+magin, 2*width, height)];
            if (model.mail.length == 0) {
                [emailBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [emailBtn setTitle:model.mail forState:UIControlStateNormal];
            }
            [emailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [emailBtn setImage:[UIImage imageNamed:@"exhibitor_contects_email_icon"] forState:UIControlStateNormal];
            emailBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:emailBtn];

        }
    }
}

- (void)introduceMoreBtnClick:(UIButton *)btn {
    self.isOpen = !self.isOpen;
    [self.tableView reloadData];
}

//需求
- (NSString *)takeDemandValue {
    
    NSString *demandStr;
    if (self.model.requirement.length == 0) {
        demandStr = @"暂无";
    }else {
        demandStr = self.model.requirement;
    }
    return demandStr;
    
}
//主营
- (NSString *)takeMainValue {
    
    NSString *mainStr;
    if (self.model.product == nil || [self.model.product isEqualToString:@""]) {
        mainStr = @"暂无";
    }else {
        mainStr = self.model.product;
    }
    return mainStr;
                     
}
//**********************************************************公司简介处理*******************************************************************/

//获取完整的公司简介
- (NSString *)takeIntroduceValue {
    
    NSString *introduceStr;
    if (self.model.profile.length == 0) {
        introduceStr = @"暂无";
    }else {
        introduceStr = self.model.profile;
    }
    return introduceStr;
    
}
//获取处理过后的简介
- (NSString *)takeIntroduceAfterTheProcessing {
    NSString *subString;
    if (self.isOpen == YES) {
        subString = [self takeIntroduceValue];
    }else {
        if ([self takeIntroduceValue].length >= 80) {
            subString = [NSString stringWithFormat:@"%@...",[[self takeIntroduceValue] substringWithRange:NSMakeRange(0, 80)]] ;
        }else {
            subString = [self takeIntroduceValue];
        }
    }
    return subString;
}
//计算公司简介需要返回的labal高度
- (CGFloat)takeIntroduceHeight {
    NSString *subString;
    if (self.isOpen == YES) {
        subString = [self takeIntroduceValue];
    }else {
        if ([self takeIntroduceValue].length >= 80) {
            subString = [NSString stringWithFormat:@"%@...",[[self takeIntroduceValue] substringWithRange:NSMakeRange(0, 80)]] ;
        }else {
            subString = [self takeIntroduceValue];
        }
    }
    CGFloat introduceHeight = [[ZWToolActon shareAction]adaptiveTextHeight:subString textFont:smallMediumFont textWidth:0.94*kScreenWidth];
    return introduceHeight;
}

- (void)phoneBtnClick:(UIButton *)btn {
    [self makePhoneCall:btn.titleLabel.text];
}

- (void)makePhoneCall:(NSString *)value {
    NSLog(@"我的值是什么%@",value);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",value];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return zw16B9ImageScale*kScreenWidth;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CGFloat PHeight = [[ZWToolActon shareAction]adaptiveTextHeight:@"占位" textFont:smallMediumFont textWidth:0.18*kScreenWidth];
            return PHeight+20;
        }else if (indexPath.row == 1) {
            CGFloat demandHeight = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeDemandValue] textFont:smallMediumFont textWidth:0.76*kScreenWidth];
            return demandHeight+20;
        }else {
            CGFloat mainHeight = [[ZWToolActon shareAction]adaptiveTextHeight:[self takeMainValue] textFont:smallMediumFont textWidth:0.76*kScreenWidth];
            return mainHeight+20;
        }
        
    }else if (indexPath.section == 2) {
        return 0.86*kScreenWidth/5+0.06*kScreenWidth;
    }else if (indexPath.section == 3) {
        if ([self takeIntroduceValue].length > 80) {
            return [self takeIntroduceHeight]+0.1*kScreenWidth+10;
        }else {
            return [self takeIntroduceHeight]+20;
        }
    }else if (indexPath.section == 4) {
        if (self.productArray.count <=3 ) {
            return 0.425*kScreenWidth;
        }else if (self.productArray.count <= 6 && self.productArray.count >3) {
            return 0.825*kScreenWidth;
        }else {
            return 1.225*kScreenWidth;
        }
    }else if (indexPath.section == 5) {
        if (self.dynamicsArray.count == 0) {
            return 0.4*kScreenWidth;
        }else {
            return 0.25*kScreenWidth;
        }
    } else {
        
        if (self.contactArray.count == 0) {
            return 0.4*kScreenWidth;
        }else {
            return 0.28*kScreenWidth+20;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1;
    }else {
        return 0.1*kScreenWidth;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.02*kScreenWidth;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    
    if (section != 0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth-1, kScreenWidth, 1)];
        lineView.backgroundColor = zwGrayColor;
        [view addSubview:lineView];
        
        NSArray *titles = @[@"公司信息",@"所属行业",@"公司简介",@"产品展示",@"历史参展",@"联系方式"];
        NSArray *icons = @[@"enterprise_information_icon",@"enterprise_industries_icon",@"exhibitor_company_icon",@"exhibitor_product_icon",@"enterprise_history_icon",@"exhibitor_contactus_icon"];
        ZWLeftImageBtn *btn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.03*kScreenWidth, 0.5*kScreenWidth, 0.04*kScreenWidth)];
        [btn setImage:[UIImage imageNamed:icons[section-1]] forState:UIControlStateNormal];
        [btn setTitle:titles[section-1] forState:UIControlStateNormal];
        btn.titleLabel.font = boldNormalFont;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:btn];
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
    
    if (indexPath.section == 5) {
        if (self.dynamicsArray.count != 0) {
            ZWNewDynamicModel *model = self.dynamicsArray[indexPath.row];
            
            ZWExExhibitorsModel *shareModel = [ZWExExhibitorsModel alloc];
            shareModel.coverImages = model.images[@"url"];
            shareModel.exhibitionId = model.exhibitionId;
            shareModel.exhibitorId = model.exhibitorId;
            shareModel.merchantId = model.merchantId;
            
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
                detailsVC.shareModel = shareModel;
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

    ZWProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWProductCell" forIndexPath:indexPath];
    ZWProductListModel *model = self.productArray[indexPath.item];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.font = smallFont;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = zwGrayColor.CGColor;
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productArray.count == 0) {
        return CGSizeMake(kScreenWidth, 0.4*kScreenWidth);
    }else {
        return CGSizeMake((0.85*kScreenWidth)/3, (0.85*kScreenWidth)/3+0.08*kScreenWidth);
    }
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
                NSLog(@"----我的公司信息%@",data);
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
               [strongSelf.collectionView reloadData];
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
