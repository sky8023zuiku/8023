//
//  ZWExExhibitorsDetailsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExExhibitorsDetailsVC.h"
#import "DCCycleScrollView.h"
#import "ZWProductCell.h"
#import "ZWMineResponse.h"
#import "ZWProductDetailVC.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <QuickLook/QuickLook.h>

#import "ZWDeliverMessageVC.h"

#import <YYLabel.h>
#import <YYText.h>

#import "UButton.h"

@interface ZWExExhibitorsDetailsVC ()<UITableViewDataSource,UITableViewDelegate,DCCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,QLPreviewControllerDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)DCCycleScrollView *banner;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)ZWExhibitorDetailsModel *model;
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, strong)NSString *companyIntroduction;//公司简介
@property(nonatomic, strong)NSArray *productArray;
@property(nonatomic, strong)NSArray *contactArray;
@property(nonatomic, strong)NSString *pdfUrl;//获取pdf
@property(nonatomic, strong)NSArray *dataImages;

//@property (nonatomic,strong) ZWNavExhibitorModel *ExhibitorModel;
@property (strong, nonatomic) QLPreviewController *previewController;
@property (copy, nonatomic) NSURL *fileURL;

@property (nonatomic, assign)NSInteger imagesStatus;

@property (nonatomic, strong)NSMutableArray *exhibitorInfoValues;//展商

@end

@implementation ZWExExhibitorsDetailsVC

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
//        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.8*kScreenWidth) collectionViewLayout:_layout];
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
    _layout.minimumLineSpacing=0.025*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.previewController  =  [[QLPreviewController alloc]  init];
    self.previewController.dataSource  = self;
    
//    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    delBtn.frame = CGRectMake(0.75*kScreenWidth, kScreenHeight-zwTabBarHeight-0.45*kScreenWidth-zwNavBarHeight, 0.25*kScreenWidth, 0.25*kScreenWidth);
//    [delBtn setBackgroundImage:[UIImage imageNamed:@"icon_act"] forState:UIControlStateNormal];
//    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:delBtn];
//
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0.085*kScreenWidth, 0.06*kScreenWidth, 0.08*kScreenWidth, 0.08*kScreenWidth)];
//    imageV.image = [UIImage imageNamed:@"edit"];
//    [delBtn addSubview:imageV];
//
//    UILabel *deliMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), 0.25*kScreenWidth, 0.04*kScreenWidth)];
//    deliMessage.textAlignment = NSTextAlignmentCenter;
//    deliMessage.font = smallFont;
//    deliMessage.textColor = [UIColor whiteColor];
//    deliMessage.text = @"投递消息";
//    [delBtn addSubview:deliMessage];
    
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0.05*kScreenWidth , kScreenHeight-zwTabBarStausHeight-0.1*kScreenWidth-zwNavBarHeight, 0.9*kScreenWidth, 0.1*kScreenWidth);
    [delBtn setTitle:@"投递消息" forState:UIControlStateNormal];
    delBtn.backgroundColor = skinColor;
    delBtn.layer.cornerRadius = 5;
    delBtn.layer.masksToBounds = YES;
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBtn];
    
}
- (void)delBtnClick:(UIButton *)btn {
    
    ZWDeliverMessageVC *messageVC = [[ZWDeliverMessageVC alloc]init];
    messageVC.merchantId = self.model.merchantId;
    messageVC.title = @"投递消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section==0) {
//        return 10;
//    }else if (section == 1) {
//        return 1;
//    }else if (section == 2) {
//        return 1;
//    }else {

//    }
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 7;
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }else if (section == 4) {
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
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *imageDic in self.imageArray) {
            NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,imageDic[@"url"]];
            [images addObject:url];
        }
        self.dataImages = images;
            
        self.banner = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5625*kScreenWidth) shouldInfiniteLoop:YES imageGroups:@[]];
        self.banner.placeholderImage = [UIImage imageNamed:@"fu_img_no_02"];
        self.banner.autoScrollTimeInterval = 5;
        self.banner.autoScroll = YES;
        self.banner.isZoom = NO;
        if (self.imagesStatus == 2) {
            self.banner.imgArr = images;
        }
        
        self.banner.itemSpace = 0;
        self.banner.imgCornerRadius = 0;
        self.banner.itemWidth = kScreenWidth;
        self.banner.delegate = self;
        self.banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:self.banner];
    }else if (indexPath.section == 1) {
        NSArray *titles = @[@"展会名称：",@"公司名称：",@"主营项目：",@"展位号：",@"展台属性：",@"需求说明：",@"产品手册："];
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.exhibitorInfoValues[indexPath.row] font:normalFont];
        
        UILabel *exNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.2*kScreenWidth, height+10)];
        exNameLabel.text = titles[indexPath.row];
        exNameLabel.font = normalFont;
        [cell.contentView addSubview:exNameLabel];
        exNameLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:exNameLabel textAlignmentWith:CGRectGetWidth(exNameLabel.frame)];
        
        UILabel *exNameValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(exNameLabel.frame), CGRectGetMinY(exNameLabel.frame), 0.95*kScreenWidth-CGRectGetMaxX(exNameLabel.frame), height+10)];
        exNameValue.text = self.exhibitorInfoValues[indexPath.row];
        exNameValue.font = normalFont;
        exNameValue.numberOfLines = 0;
        [cell.contentView addSubview:exNameValue];
        
        if (indexPath.row == 6) {
            
            UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            browseBtn.frame = CGRectMake(CGRectGetMaxX(exNameLabel.frame), 0, 0.1*kScreenWidth, CGRectGetHeight(exNameLabel.frame));
            [browseBtn setTitle:@"预览" forState:UIControlStateNormal];
            [browseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            browseBtn.titleLabel.font = normalFont;
            [browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:browseBtn];
            
            UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            downloadBtn.frame = CGRectMake(CGRectGetMaxX(browseBtn.frame), 0, 0.1*kScreenWidth, CGRectGetHeight(browseBtn.frame));
            [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
            [downloadBtn setTitleColor:skinColor forState:UIControlStateNormal];
            downloadBtn.titleLabel.font = normalFont;
            [downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:downloadBtn];
            
        }
        
        
    }else if (indexPath.section == 2) {
        
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.productArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 10, 0.9*kScreenWidth, 0.4*kScreenWidth-20)];
            myNotice.text = @"暂无产品";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
        }else {
            
            if (self.productArray.count <=3 ) {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.9*kScreenWidth, 0.4*kScreenWidth) collectionViewLayout:_layout];
            }else if (self.productArray.count <= 6 && self.productArray.count >3) {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.9*kScreenWidth, 0.8*kScreenWidth) collectionViewLayout:_layout];
            }else {
                _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.025*kScreenWidth, 0.9*kScreenWidth, 1.2*kScreenWidth) collectionViewLayout:_layout];
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
                
    }else if (indexPath.section == 3) {
        
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.companyIntroduction  font:smallMediumFont]+50;
        UILabel *introduceDetail = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 10, 0.9*kScreenWidth, height)];
        if (self.companyIntroduction.length == 0) {
            introduceDetail.text = @"暂无";
        }else {
            introduceDetail.text = self.companyIntroduction;
        }
        introduceDetail.font = smallMediumFont;
        introduceDetail.numberOfLines = 0;
        [cell.contentView addSubview:introduceDetail];
        
    }else if (indexPath.section == 4) {
        
        UILabel *myNotice;
        if (myNotice) {
            [myNotice removeFromSuperview];
        }
        if (self.contactArray.count == 0) {
            myNotice = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 10, 0.9*kScreenWidth, 0.4*kScreenWidth-20)];
            myNotice.text = @"暂无联系人";
            myNotice.textAlignment = NSTextAlignmentCenter;
            myNotice.backgroundColor = zwGrayColor;
            myNotice.textColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
            [cell.contentView addSubview:myNotice];
                    
        }else {
            ZWContactListModel *model = self.contactArray[indexPath.row];
            CGFloat height = 0.28*kScreenWidth/8;
            CGFloat magin = 0.28*kScreenWidth/2/5;
            CGFloat width = 0.9*kScreenWidth/2;
            
            UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 0.28*kScreenWidth)];
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
                [phoneBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
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
                [telBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
            }
            [telBtn setTitleColor:skinColor forState:UIControlStateNormal];
            [telBtn setImage:[UIImage imageNamed:@"exhibitors_contects_tel_icon"] forState:UIControlStateNormal];
            telBtn.titleLabel.font = smallMediumFont;
            [toolView addSubview:telBtn];
                        
            //qq
            ZWLeftImageBtn *qqBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneBtn.frame), CGRectGetMaxY(telBtn.frame)+magin, 2*width, height)];
            if (model.wechat.length == 0) {
                [qqBtn setTitle:@"暂无" forState:UIControlStateNormal];
            }else {
                [qqBtn setTitle:model.wechat forState:UIControlStateNormal];
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
          
    }else {
        
        CGFloat height = 0.4*kScreenWidth/10;
        CGFloat magin = 0.4*kScreenWidth/2/5;
        CGFloat width = 0.8*kScreenWidth/2;
        
        //邮箱
        ZWLeftImageBtn *emailBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, magin, width, height)];
        if (self.model.email.length == 0) {
            [emailBtn setTitle:@"暂无" forState:UIControlStateNormal];
        }else {
            [emailBtn setTitle:self.model.email forState:UIControlStateNormal];
        }
        emailBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [emailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [emailBtn setImage:[UIImage imageNamed:@"exhibitor_contects_email_icon"] forState:UIControlStateNormal];
        emailBtn.titleLabel.font = smallMediumFont;
        [cell.contentView addSubview:emailBtn];
        
        //电话
        ZWLeftImageBtn *telBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(emailBtn.frame), CGRectGetMaxY(emailBtn.frame)+magin, width, height)];
        if (self.model.telephone.length == 0) {
            [telBtn setTitle:@"暂无" forState:UIControlStateNormal];
        }else {
            [telBtn setTitle:self.model.telephone forState:UIControlStateNormal];
            [telBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
        }
        telBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [telBtn setTitleColor:skinColor forState:UIControlStateNormal];
        [telBtn setImage:[UIImage imageNamed:@"exhibitors_contects_tel_icon"] forState:UIControlStateNormal];
        telBtn.titleLabel.font = smallMediumFont;
        [cell.contentView addSubview:telBtn];
        
        //网址
        ZWLeftImageBtn *websiteBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(telBtn.frame), CGRectGetMaxY(telBtn.frame)+magin, width, height)];
        if (self.model.website.length == 0) {
            [websiteBtn setTitle:@"暂无" forState:UIControlStateNormal];
        }else {
            [websiteBtn setTitle:self.model.website forState:UIControlStateNormal];
        }
        [websiteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [websiteBtn setImage:[UIImage imageNamed:@"exhibitor_contectus_website_icon"] forState:UIControlStateNormal];
        websiteBtn.titleLabel.font = smallMediumFont;
        [cell.contentView addSubview:websiteBtn];
        
        //地址
        ZWLeftImageBtn *addressBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(websiteBtn.frame), CGRectGetMaxY(websiteBtn.frame)+magin, 2*width, height)];
        if (self.model.website.length == 0) {
            [addressBtn setTitle:@"暂无" forState:UIControlStateNormal];
        }else {
            [addressBtn setTitle:self.model.address forState:UIControlStateNormal];
        }
        [addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addressBtn setImage:[UIImage imageNamed:@"exhibitor_contectus_adress_icon"] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = smallMediumFont;
        [cell.contentView addSubview:addressBtn];
                
    }
    
}

- (void)makePhoneCall:(UIButton *)btn {
    [self takeCallWithValue:btn.titleLabel.text];
}

- (void)takeCallWithValue:(NSString *)value {
    NSLog(@"我的值是什么%@",value);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",value];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL];
}

- (void)previewBtnClick:(UIButton *)btn {
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0.5625*kScreenWidth;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 6) {
            return 0.1*kScreenWidth;
        }else {
            CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.exhibitorInfoValues[indexPath.row] font:normalFont];
            if (height) {
                return height+10;
            }else {
                return 0.04*kScreenWidth;
            }
        }
    }else if (indexPath.section == 2) {
        if (self.productArray.count <=3 ) {
            return 0.425*kScreenWidth;
        }else if (self.productArray.count <= 6 && self.productArray.count >3) {
            return 0.825*kScreenWidth;
        }else {
            return 1.225*kScreenWidth;
        }
        
    }else if (indexPath.section == 3) {
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.companyIntroduction font:smallMediumFont]+50;
        return height+20;
    }else if (indexPath.section == 4) {
        if (self.contactArray.count == 0) {
            return 0.4*kScreenWidth;
        }else {
            if (indexPath.row == self.contactArray.count-1) {
                return 0.28*kScreenWidth+20;
            }else {
                return 0.28*kScreenWidth+10;
            }
        }
    } else {
        return 0.4*kScreenWidth;
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
    if (section == 5) {
        return zwTabBarHeight;
    }else {
        return 0.02*kScreenWidth;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    if (section != 0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth-1, kScreenWidth, 1)];
        lineView.backgroundColor = zwGrayColor;
        [view addSubview:lineView];
        
        NSArray *titles = @[@"展商信息",@"产品展示",@"公司介绍",@"联系方式",@"联系我们"];
        NSArray *icons = @[@"exhibitor_info_icon",@"exhibitor_product_icon",@"exhibitor_company_icon",@"exhibitor_contact_icon",@"exhibitor_contactus_icon"];
        ZWLeftImageBtn *btn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(15, 0.025*kScreenWidth, 0.5*kScreenWidth, 0.05*kScreenWidth)];
        [btn setImage:[UIImage imageNamed:icons[section-1]] forState:UIControlStateNormal];
        [btn setTitle:titles[section-1] forState:UIControlStateNormal];
        btn.titleLabel.font = boldNormalFont;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:btn];
    }

    return view;
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
    if (self.productArray.count == 0) {
        return 1;
    }else {
        return self.productArray.count;
    }
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
//    cell.backgroundColor = [UIColor whiteColor];
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
    vc.productType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}


//**********************************************************网络请求**************************************************

- (void)createRequest {
    [self requestExExhibitorsDetail];
}
- (void)requestExExhibitorsDetail {
    if (self.exhibitorId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwExhibitionExhibitorDetails parametes:@{@"exhibitorId":self.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                strongSelf.imageArray = data[@"data"][@"images"];
                NSDictionary *dataDic = data[@"data"][@"exhibitor"];
                NSString *myStatus = data[@"data"][@"imagesStatus"];
                strongSelf.imagesStatus = [myStatus integerValue];
                ZWExhibitorDetailsModel *model = [ZWExhibitorDetailsModel  parseJSON:dataDic];
                strongSelf.model = model;
                [self createExhibitorInfomation:model];
                NSLog(@"---====++++++++%@",strongSelf.model.productUrl);
//                [strongSelf.tableView reloadData];
                [strongSelf requestExExhibitorsProfile];
            }
        } failureBlock:^(NSError * _Nonnull error) {
        
        }];
    }
}

- (void)createExhibitorInfomation:(ZWExhibitorDetailsModel *)model {
    
    self.exhibitorInfoValues = [NSMutableArray array];
    //展会名称
    if (model.exhibitionName == nil||[model.exhibitionName isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@"暂无"];
    }else {
        [self.exhibitorInfoValues  addObject:model.exhibitionName];
    }
    //公司名称
    if (model.merchantName == nil||[model.merchantName isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@"暂无"];
    }else {
        [self.exhibitorInfoValues  addObject:model.merchantName];
    }
    //主营项目
    if (model.product == nil||[model.product isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@"暂无"];
    }else {
        [self.exhibitorInfoValues  addObject:model.product];
    }
    //展位编号
    if (model.exposition == nil||[model.exposition isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@"暂无"];
    }else {
        [self.exhibitorInfoValues  addObject:model.exposition];
    }
//    //公司邮箱
//    if (model.email == nil||[model.email isEqualToString:@""]) {
//        [self.exhibitorInfoValues  addObject:@"暂无"];
//    }else {
//        [self.exhibitorInfoValues  addObject:model.email];
//    }
    //展台属性
    if (model.nature) {
        if ([model.nature isEqualToString:@"1"]) {
            [self.exhibitorInfoValues  addObject:@"标摊"];
        }else if ([model.nature isEqualToString:@"2"]) {
            [self.exhibitorInfoValues  addObject:@"特装"];
        }else {
            [self.exhibitorInfoValues  addObject:@"未标注"];
        }
    }
//    //公司网址
//    if (model.website == nil||[model.website isEqualToString:@""]) {
//        [self.exhibitorInfoValues  addObject:@"暂无"];
//    }else {
//        [self.exhibitorInfoValues  addObject:model.website];
//    }
//    //公司电话
//    if (model.telephone == nil||[model.telephone isEqualToString:@""]) {
//        [self.exhibitorInfoValues  addObject:@"暂无"];
//    }else {
//        [self.exhibitorInfoValues  addObject:model.telephone];
//    }
//    //公司地址
//    if (model.address == nil||[model.address isEqualToString:@""]) {
//        [self.exhibitorInfoValues  addObject:@"暂无"];
//    }else {
//        [self.exhibitorInfoValues  addObject:model.address];
//    }
    //需求说明
    if (model.requirement == nil||[model.requirement isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@"暂无"];
    }else {
        [self.exhibitorInfoValues  addObject:model.requirement];
    }
    
    //需求说明
    if (model.requirement == nil||[model.requirement isEqualToString:@""]) {
        [self.exhibitorInfoValues  addObject:@""];
    }else {
        [self.exhibitorInfoValues  addObject:@""];
    }
}

- (void)requestExExhibitorsProfile {
    if (self.merchantId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExExhibitorProfile parametes:@{@"merchantId":self.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                strongSelf.companyIntroduction = data[@"data"][@"zwMerchantVo"][@"profile"];
                [strongSelf.tableView reloadData];
                [self requestExExhibitorsProductList];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (void)requestExExhibitorsProductList {
    if (self.exhibitorId) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExExhibitorProductList parametes:@{@"exhibitorId":self.exhibitorId,@"status":@""} successBlock:^(NSDictionary * _Nonnull data) {
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
                [self requestExExhibitorsContactList];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (void)requestExExhibitorsContactList {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postFormDataReqeustWithURL:zwExExhibitorContactersList parametes:@{@"exhibitorId":self.exhibitorId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *dataArray = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in dataArray) {
                ZWContactListModel *model = [ZWContactListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.contactArray = myArray;
            [strongSelf.tableView reloadData];
            [strongSelf.collectionView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


- (void)browseBtnClick:(UIButton *)btn {
    NSLog(@"%@",self.model.productUrl);
    if (!self.model.productUrl||[self.model.productUrl isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"暂无产品手册"];
        return;
    }
    [self downloadWithUrl:self.model.productUrl withType:0];
}
//下载文件
- (void)downloadWithUrl:(NSString *)URLStr withType:(NSInteger)type{
    
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
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
            self.fileURL = filePath;
            if (type == 0) {
                [self presentViewController:self.previewController animated:YES completion:nil];
            }else {
                [self shareLog:filePath];
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

- (void)downloadBtnClick:(UIButton *)btn {
    if (! self.model.productUrl||[self.model.productUrl isEqualToString:@""]) {
        [self showOneAlertWithMessage:@"暂无产品手册"];
        return;
    }
    [self downloadWithUrl:self.model.productUrl withType:1];
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
