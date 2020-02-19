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
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0.75*kScreenWidth, kScreenHeight-zwTabBarHeight-0.45*kScreenWidth-zwNavBarHeight, 0.25*kScreenWidth, 0.25*kScreenWidth);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"icon_act"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBtn];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0.085*kScreenWidth, 0.06*kScreenWidth, 0.08*kScreenWidth, 0.08*kScreenWidth)];
    imageV.image = [UIImage imageNamed:@"edit"];
    [delBtn addSubview:imageV];
    
    UILabel *deliMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), 0.25*kScreenWidth, 0.04*kScreenWidth)];
    deliMessage.textAlignment = NSTextAlignmentCenter;
    deliMessage.font = smallFont;
    deliMessage.textColor = [UIColor whiteColor];
    deliMessage.text = @"投递消息";
    [delBtn addSubview:deliMessage];
    
}
- (void)delBtnClick:(UIButton *)btn {
    
    ZWDeliverMessageVC *messageVC = [[ZWDeliverMessageVC alloc]init];
    messageVC.merchantId = self.model.merchantId;
    messageVC.title = @"投递消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 1;
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
        if (indexPath.row == 0) {
            
            CGFloat unitH = 0.8*kScreenWidth/12;
            NSArray *titles = @[@"展会名称：",@"公司名称：",@"主营项目：",@"展位编号：",@"公司邮箱：",@"展台属性：",@"公司网址：",@"公司电话：",@"公司地址：",@"需求说明："];
            for (int i = 0; i < titles.count; i++) {
                UILabel *exNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, i*unitH, 0.2*kScreenWidth, unitH)];
                exNameLabel.text = titles[i];
                exNameLabel.font = normalFont;
                [cell.contentView addSubview:exNameLabel];
                
                YYLabel *exNameValue = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(exNameLabel.frame), CGRectGetMinY(exNameLabel.frame), 0.95*kScreenWidth-CGRectGetMaxX(exNameLabel.frame), CGRectGetHeight(exNameLabel.frame))];
                if (i == 0) {
                    if (self.model.exhibitionName == nil||[self.model.exhibitionName isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.exhibitionName;
                    }
                }else if(i == 1) {
                    if (self.model.merchantName == nil||[self.model.merchantName isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.merchantName;
                    }
                }else if (i == 2) {
                    if (self.model.product == nil||[self.model.product isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.product;
                    }
                }else if (i == 3) {
                    if (self.model.exposition == nil||[self.model.exposition isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.exposition;
                    }
                }else if (i == 4) {
                    if (self.model.email == nil||[self.model.email isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.email;
                    }
                }else if (i == 5) {
                    if (self.model.nature) {
                        if ([self.model.nature isEqualToString:@"1"]) {
                            exNameValue.text = @"标摊";
                        }else if ([self.model.nature isEqualToString:@"2"]) {
                            exNameValue.text = @"特装";
                        }else {
                            exNameValue.text = @"未标注";
                        }
                    }
                }else if (i == 6) {
                    if (self.model.website == nil||[self.model.website isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.website;
                    }
                }else if (i == 7) {
                    if (self.model.telephone == nil||[self.model.telephone isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc] initWithString:self.model.telephone];
                        NSRange phoneRange = [[phoneString string]rangeOfString:self.model.telephone];
                        [phoneString setYy_color:[UIColor blackColor]];
                        __weak typeof (self) weakSelf = self;
                        [phoneString yy_setTextHighlightRange:phoneRange color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                            __strong typeof (weakSelf) strongSelf = weakSelf;
                            [strongSelf takeCallWithValue:self.model.telephone];
                        }];
                        exNameValue.attributedText = phoneString;
                    }
                }else if (i == 8) {
                    if (self.model.address == nil||[self.model.address isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.address;
                    }
                }else {
                    if (self.model.requirement == nil||[self.model.requirement isEqualToString:@""]) {
                        exNameValue.text = @"暂无";
                    }else {
                        exNameValue.text = self.model.requirement;
                    }
                }
                exNameValue.font = normalFont;
                [cell.contentView addSubview:exNameValue];
            }
            
            UILabel *manualLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 10*unitH, 0.2*kScreenWidth, unitH)];
            manualLabel.text = @"产品手册：";
            manualLabel.font = normalFont;
            [cell.contentView addSubview:manualLabel];
            
            UIImageView *pdfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(manualLabel.frame), CGRectGetMidY(manualLabel.frame)-0.022*kScreenWidth, 1.2*unitH, 1.5*unitH)];
            pdfImageView.image = [UIImage imageNamed:@"icon_pdf"];
            [cell.contentView addSubview:pdfImageView];
            
            
            NSArray *array = [self.model.productUrl componentsSeparatedByString:@","];
            
            UILabel *gsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pdfImageView.frame)+5, CGRectGetMinY(pdfImageView.frame)+2, 0.95*kScreenWidth-CGRectGetMaxX(pdfImageView.frame)-5, 0.025*kScreenWidth)];
            if (array[0]) {
                gsLabel.text = array[0];
            }else {
                gsLabel.text = @"暂无产品手册";
            }
            
            gsLabel.font = smallFont;
            [cell.contentView addSubview:gsLabel];
            
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
            
        }
    }else if (indexPath.section == 1){
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.companyIntroduction  font:smallMediumFont]+20;
        UILabel *introduceDetail = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, height)];
        if (self.companyIntroduction.length == 0) {
            introduceDetail.text = @"暂无";
        }else {
            introduceDetail.text = self.companyIntroduction;
        }
        introduceDetail.font = smallMediumFont;
        introduceDetail.numberOfLines = 0;
        [cell.contentView addSubview:introduceDetail];
    }else if (indexPath.section == 2) {
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
            
            ZWContactListModel *model = self.contactArray[indexPath.row];
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
            NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手机：%@",model.phone]];
            NSRange phoneRange = [[phoneString string]rangeOfString:model.phone];
            [phoneString setYy_color:[UIColor blackColor]];
            __weak typeof (self) weakSelf = self;
            [phoneString yy_setTextHighlightRange:phoneRange color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf takeCallWithValue:model.phone];
            }];
            phoneLabel.attributedText = phoneString;
            [toolView addSubview:phoneLabel];
            
            
            YYLabel *telLabel = [[YYLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame), CGRectGetMinY(phoneLabel.frame), width, height)];
            NSMutableAttributedString *telString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话：%@",model.telephone]];
            NSRange telRange = [[telString string]rangeOfString:model.telephone];
            [telString setYy_color:[UIColor blackColor]];
            [telString yy_setTextHighlightRange:telRange color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf takeCallWithValue:model.telephone];
            }];
            telLabel.attributedText = telString;
            [toolView addSubview:telLabel];
                        
            UILabel *qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(phoneLabel.frame), width, height)];
            qqLabel.text = [NSString stringWithFormat:@"Q  Q：%@",model.wechat];
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
        return 0.8*kScreenWidth;
    } else if (indexPath.section == 1) {
        CGFloat height = [[ZWToolActon shareAction]adaptiveTextHeight:self.companyIntroduction font:smallMediumFont]+20;
        return height;
    } else if (indexPath.section == 2) {
        return 0.4*kScreenWidth;
    }else {
        if (self.contactArray.count == 0) {
            return 0.45*kScreenWidth;
        }else {
            return 0.3*kScreenWidth;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5625*kScreenWidth+0.1*kScreenWidth;
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
    
    NSMutableArray *images = [NSMutableArray array];
    for (NSDictionary *imageDic in self.imageArray) {
        NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,imageDic[@"url"]];
        [images addObject:url];
    }
    self.dataImages = images;
    if (section == 0) {
        
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
        [view addSubview:self.banner];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, CGRectGetMaxY(self.banner.frame)+0.03*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth)];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.layer.cornerRadius = 0.005*kScreenWidth;
        lineView.layer.masksToBounds = YES;
        [view addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, CGRectGetMaxY(self.banner.frame), 0.5*kScreenWidth, 0.1*kScreenWidth)];
        titleLabel.text = @"展商信息";
        titleLabel.font = boldBigFont;
        [view addSubview:titleLabel];
        
    } else {
        
        if (section != 0 ) {
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0.03*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth)];
            lineView.backgroundColor = [UIColor blackColor];
            lineView.layer.cornerRadius = 0.005*kScreenWidth;
            lineView.layer.masksToBounds = YES;
            [view addSubview:lineView];
            
            NSArray *titles = @[@"公司简介",@"产品展示",@"联系方式"];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, 0, 0.5*kScreenWidth, 0.1*kScreenWidth)];
            titleLabel.text = titles[section-1];
            titleLabel.font = boldBigFont;
            [view addSubview:titleLabel];
            
        }
        
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
    cell.backgroundColor = zwGrayColor;
    return cell;

}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productArray.count == 0) {
        return CGSizeMake(kScreenWidth, 0.4*kScreenWidth);
    }else {
        return CGSizeMake((0.8*kScreenWidth)/3, (0.8*kScreenWidth)/3+0.08*kScreenWidth);
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
                NSLog(@"---====++++++++%@",strongSelf.model.productUrl);
//                [strongSelf.tableView reloadData];
                [strongSelf requestExExhibitorsProfile];
            }
        } failureBlock:^(NSError * _Nonnull error) {
        
        }];
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
            [strongSelf.collectView reloadData];
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
