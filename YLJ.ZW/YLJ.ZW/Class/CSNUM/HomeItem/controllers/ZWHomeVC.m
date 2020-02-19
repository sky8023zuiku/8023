//
//  ZWHomeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHomeVC.h"
#import "UButton.h"
#import "ZWCollectionTool.h"
#import "ZWHomeTuiExhibitorsView.h"
#import <UIView+MJExtension.h>
#import "CSSearchVC.h"
#import "ZWCompanyDesignVC.h"
#import "ZWVisitListVC.h"
#import "ZWPageContorller.h"
#import <SDCycleScrollView.h>

#import "UIImage+ZWCustomImage.h"
#import <Masonry.h>

#import "ZWPavilionHallVC.h"

#import "ZWMineResponse.h"
#import "ZWInduExhibitorsModel.h"

#import "ZWEditCompanyInfoVC.h"
#import "ZWCertificationStatusVC.h"
#import "ZWExhibitorsDetailsVC.h"

#import "ZWMainLoginVC.h"

#import "UIViewController+YCPopover.h"

#import "ZWScanVC.h"
#import "Global.h"
#import "StyleDIY.h"

@interface ZWHomeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SDCycleScrollViewDelegate,ZWHomeTuiExhibitorsViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSArray *imageArray;//轮播图数组
@property(nonatomic, strong)NSArray *exhibitionArray;//展会数组
@property(nonatomic, strong)NSMutableArray *recommentArray;//推荐展商
@property(nonatomic, strong)NSArray *httpImages;
@end

@implementation ZWHomeVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, zwNavBarHeight, kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = zwGrayColor;
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleDefault withType:1];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self createRequst];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNotice];
    [self createNavigation];

}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rollingTableView:) name:@"rollingTableView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheStatusBarColor:) name:@"changeTheStatusBarColor" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"rollingTableView" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeTheStatusBarColor" object:nil];
}

- (void)changeTheStatusBarColor:(NSNotification *)notice {
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleDefault withType:1];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)createNavigation {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, zwNavBarHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, zwStatusBarHeight, 0.6*kScreenWidth, 44)];
    titleLabel.text = @"首页";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
//    UIImageView *scanImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-35, zwStatusBarHeight+10, 25, 25)];
//    scanImage.image = [UIImage imageNamed:@"scan_icon"];
//    [navView addSubview:scanImage];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kScreenWidth-35, zwStatusBarHeight+10, 25, 25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
}

- (void)rightBtnClick:(UIButton *)btn {
    ZWScanVC *VC = [[ZWScanVC alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.libraryType = [Global sharedManager].libraryType;
    VC.scanCodeType = [Global sharedManager].scanCodeType;
    VC.style = [StyleDIY customStyle];
    //镜头拉远拉近功能
    VC.isVideoZoom = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)rollingTableView:(NSNotification *)notice {
    
    NSInteger type = [notice.object integerValue];
    if (type == 1) {
        CGFloat itemHeight = (0.95*kScreenWidth-5)/2+0.15*kScreenWidth;
        CGFloat rollHeight = itemHeight*2+0.81*kScreenWidth;
        [self.tableView setContentOffset:CGPointMake(0, rollHeight) animated:YES];
    }else {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(zwHomeTableRollValue:)]) {
        [self.delegate zwHomeTableRollValue:self.tableView.contentOffset.y];
    }
}

- (void)postNotice:(NSInteger)type {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"homeTableViewRollLocation" object:[NSString stringWithFormat:@"%ld",type]];
}

- (void)createUI {
    self.recommentArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.recommentArray.count;
    }else {
        return 1;
    }
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
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor= [UIColor clearColor];
    
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.95*kScreenWidth, 0.25*kScreenWidth)];
    
    [cell.contentView addSubview:toolView];
    
    if (indexPath.section == 0) {
        
        CGFloat itemWidth = 0.95*kScreenWidth/5;
        CGFloat itemHeight = 0.95*kScreenWidth/5;
        
        NSArray *titleArr = @[@"速查展商",
                              @"计划展会",
                              @"展览工厂",
                              @"企业入驻",
                              @"展馆展厅"];
        
        NSArray *iconArr = @[@"quick_exhibitors_icon",
                             @"registered_visit_icon",
                             @"exhibition_factory_icon",
                             @"enterprises_icon",
                             @"pavilion_hall_icon"];
        
        for (int i = 0; i<titleArr.count; i++) {
            
//            int row = i/4;
            int col = i%5;

            UIButton *mainBtn = [UButton buttonWithType:UIButtonTypeCustom];
            mainBtn.frame = CGRectMake(itemWidth*col, 0.03*kScreenWidth, itemWidth, itemHeight);
            mainBtn.titleLabel.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
            [mainBtn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
            [mainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [mainBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            mainBtn.tag = 1000+i;
            [mainBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:mainBtn];
        }
    }else if (indexPath.section == 1) {
        CGFloat itemHeight = (0.95*kScreenWidth-5)/2+0.15*kScreenWidth;
        ZWCollectionTool *tool = [[ZWCollectionTool alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.95*kScreenWidth, itemHeight*2+0.04*kScreenWidth) withData:self.exhibitionArray];
        [cell.contentView addSubview:tool];
    }else {
        ZWInduExhibitorsModel *model = self.recommentArray[indexPath.row];
        ZWHomeTuiExhibitorsView *tuiExhibitorsView = [[ZWHomeTuiExhibitorsView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.95*kScreenWidth, 0.25*kScreenWidth)];
        tuiExhibitorsView.backgroundColor = [UIColor whiteColor];
        tuiExhibitorsView.layer.cornerRadius = 0.02*kScreenWidth;
        tuiExhibitorsView.model = model;
        tuiExhibitorsView.collectionBtn.tag = indexPath.row;
        tuiExhibitorsView.delegate = self;
        [cell.contentView addSubview:tuiExhibitorsView];
    }
}

- (void)itemClick:(UIButton *)btn {
    
    if ([self goToLogin] != YES) {
        if (btn.tag == 1000) {
            CSSearchVC *searchVC = [[CSSearchVC alloc]init];
            searchVC.type = 5;
            searchVC.hidesBottomBarWhenPushed = YES;
            searchVC.navigationController.navigationBar.barTintColor = skinColor;
            [self.navigationController pushViewController:searchVC animated:YES];
        }else if (btn.tag == 1001) {
            ZWVisitListVC *visitVC = [[ZWVisitListVC alloc]init];
            visitVC.title = @"计划展会";
            visitVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:visitVC animated:YES];
        }else if (btn.tag == 1002) {
            ZWCompanyDesignVC *companyDesignVC = [[ZWCompanyDesignVC alloc]init];
            companyDesignVC.hidesBottomBarWhenPushed = YES;
            companyDesignVC.title = @"展览工厂";
            companyDesignVC.type = @"4";
            [self.navigationController pushViewController:companyDesignVC animated:YES];
        }else if (btn.tag == 1003) {
            [self takeCompanyCertificationStatus];
        }else {
            ZWPavilionHallVC *pavilionHallVC = [[ZWPavilionHallVC alloc]init];
            pavilionHallVC.title = @"展馆展厅";
            pavilionHallVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pavilionHallVC animated:YES];
        }
    }
}

- (void)takeCompanyCertificationStatus {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCompanyCertification parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSInteger merchantStatus = [data[@"data"] integerValue];
            if (merchantStatus == 0) {
                ZWEditCompanyInfoVC *companyInfoVC = [[ZWEditCompanyInfoVC alloc]init];
                companyInfoVC.title = @"企业信息上传";
                companyInfoVC.merchantStatus = merchantStatus;
                companyInfoVC.status = 0;
                companyInfoVC.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:companyInfoVC animated:YES];
            }else {
                ZWCertificationStatusVC *certificationStatusVC = [[ZWCertificationStatusVC alloc]init];
                certificationStatusVC.title = @"认证结果";
                certificationStatusVC.merchantStatus = merchantStatus;
                certificationStatusVC.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:certificationStatusVC animated:YES];
            }
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    } showInView:self.view];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0.24*kScreenWidth;
    }else if (indexPath.section == 1) {
        CGFloat itemHeight = (0.95*kScreenWidth-5)/2+0.15*kScreenWidth;
        return itemHeight*2+0.04*kScreenWidth;
    }else {
        return 0.2635*kScreenWidth;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.45*kScreenWidth;
    }else {
        return 0.1*kScreenWidth;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (section == 0) {
                
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (NSString *urlName in self.imageArray) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,urlName];
            [imageUrls addObject:urlStr];
        }
        self.httpImages = imageUrls;
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.45*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        cycleScrollView.showPageControl = YES;
        cycleScrollView.imageURLStringsGroup = imageUrls;
        cycleScrollView.autoScrollTimeInterval = 3;
        cycleScrollView.currentPageDotImage = [UIImage imageWithColor:[UIColor whiteColor] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
        [view addSubview:cycleScrollView];

    }else if (section == 1) {
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.05*kScreenWidth, 0.065*kScreenWidth)];
        titleImage.image = [UIImage imageNamed:@"hot_fire_icon"];
        [view addSubview:titleImage];
        
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+8, CGRectGetMinY(titleImage.frame)+3, 0.5*kScreenWidth, CGRectGetHeight(titleImage.frame))];
        myLabel.text = @"热门展会";
        myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.042*kScreenWidth];
        [view addSubview:myLabel];
        
    }else {
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.05*kScreenWidth, 0.065*kScreenWidth)];
        titleImage.image = [UIImage imageNamed:@"recommended_icon"];
        [view addSubview:titleImage];
        
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+8, CGRectGetMinY(titleImage.frame)+3, 0.5*kScreenWidth, CGRectGetHeight(titleImage.frame))];
        myLabel.text = @"推荐展商";
        myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.042*kScreenWidth];
        [view addSubview:myLabel];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self goToLogin] != YES) {
        ZWInduExhibitorsModel *model = self.recommentArray[indexPath.row];
        ZWExhibitorsDetailsVC *detailsVC = [[ZWExhibitorsDetailsVC alloc]init];
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.title = @"展商详情";
        detailsVC.merchantId = model.merchantId;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
}

//点击图片的代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
   NSLog(@"index = %ld",(long)index);
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.httpImages tapIndex:index];
}

- (void)industryCancelTheCollection:(ZWHomeTuiExhibitorsView *)cell withIndex:(NSInteger)index {
    
    if ([self goToLogin] != YES) {
        ZWInduExhibitorsModel *model = self.recommentArray[index];
        [[ZWDataAction sharedAction]getReqeustWithURL:zwInduExhibitorsCollectionAndCancel parametes:@{@"merchantId":model.merchantId} successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                ZWHomeTuiExhibitorsView *myCell = cell;
                if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                    myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
                }else {
                    myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
                }
                [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self.view];
    }
    
}


- (void)createRequst {
    [self refreshHotData];
    self.page = 1;
    [self refreshRecommentData:self.page];
    [self refreshHeader];
    [self refreshFooter];
}

//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf refreshHotData];
        [strongSelf refreshRecommentData:strongSelf.page];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
       [strongSelf refreshRecommentData:strongSelf.page];
    }];
}

- (void)refreshHotData {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwHomeHot parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSLog(@"%@",data[@"data"][@"images"]);
            strongSelf.imageArray = data[@"data"][@"images"];
            NSArray *myData = data[@"data"][@"exhibitionVoList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWExhibitionListModel *model = [ZWExhibitionListModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.exhibitionArray = myArray;
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (void)refreshRecommentData:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwRecommendExhibitors parametes:@{@"pageNo":[NSString stringWithFormat:@"%ld",(long)page],@"pageSize":@"10"} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (zw_issuccess) {
            if (page == 1) {
                [strongSelf.recommentArray removeAllObjects];
            }
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWInduExhibitorsModel *model = [ZWInduExhibitorsModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [strongSelf.recommentArray addObjectsFromArray:myArray];
            [strongSelf.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (BOOL)goToLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([user.uuid isEqualToString:@""]||!user.uuid) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
        [self yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
            if (presented) {
                [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
            }else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTheStatusBarColor" object:nil];
            }
        }];
        return YES;
    }else {
        return NO;
    }
}
@end
