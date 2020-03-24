//
//  ZWServiceVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWServiceVC.h"
#import "DCCycleScrollView.h"
#import "UButton.h"
#import "ZWCompanyDesignVC.h"
#import "ZWCompanyDetailVC.h"
#import "ZWSpellListVC.h"
#import "ZWServiceRequst.h"
#import "ZWServiceResponse.h"
#import <UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
#import "GYZChooseCityController.h"
#import "UIViewController+YCPopover.h"
#import "ZWImageBrowser.h"

#import "CSTurnsView.h"
#import "CSBannerView.h"

#import "ZWExhServiceListCell.h"

#import <SDCycleScrollView.h>

#import "UIImage+ZWCustomImage.h"

@interface ZWServiceVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,GYZChooseCityDelegate,CLLocationManagerDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *lbtAarry;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)UIButton *LeftItem;
@property(nonatomic, strong)NSString *selectedCity;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic, strong)NSArray *dataImages;

@end

@implementation ZWServiceVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight-zwTabBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createRequstLBT];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationStart];
    [self createNavigationBar];
    [self createUI];
    [self refreshHeader];
    [self refreshFooter];
    
}

- (void)createRequstLBT {
    ZWServiceLBTRequst *requst = [[ZWServiceLBTRequst alloc]init];
    __weak typeof(self) weakSelf = self;
    [requst getRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        if (respense.isFinished) {
            NSLog(@"%@",respense.data);
            strongSelf.lbtAarry = respense.data;
            [strongSelf.tableView reloadData];
        }else {
            NSLog(@"%@",respense.result);
        }
    }];
}
//刷新
- (void)refreshHeader {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf createRequest:self.page];
        [strongSelf createRequstLBT];
    }];
}
//加载
- (void)refreshFooter {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.page += 1;
        [strongSelf createRequest:self.page];
    }];
}
- (void)createRequest:(NSInteger)page {
    ZWServiceProvidersListRequst *requst = [[ZWServiceProvidersListRequst alloc]init];
    requst.status = 2;
    requst.merchantName = @"";
    requst.city = self.selectedCity;
    requst.type = @"";
    requst.pageNo = (int)page;
    requst.pageSize = 10;
    __weak typeof(self) weakSelf = self;
    [requst postRequestCompleted:^(YHBaseRespense *respense) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if (respense.isFinished) {
            if (page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSLog(@"%@",[[ZWToolActon shareAction]transformDic:respense.data[@"result"]]);
            NSArray *array = respense.data[@"result"];
            NSMutableArray *myArr = [NSMutableArray array];
            for (NSDictionary *myDic in array) {
                ZWServiceProvidersListModel *model = [ZWServiceProvidersListModel parseJSON:myDic];
                [myArr addObject:model];
            }
            [strongSelf.dataArray addObjectsFromArray:myArr];
            [strongSelf.tableView reloadData];
        }else {
            
        }
    }];
}

//- (NSString *)transformDic:(NSDictionary *)dic {
//    if (![dic count]) {
//        return nil;
//    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
//    return str;
//}

- (void)createNavigationBar {
//    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
//    [[YNavigationBar sharedInstance]createLeftBarWithTitle:@"上海市▼" barItem:self.navigationItem target:self action:@selector(leftItemClick:)];
}
- (void)createUI {
//    self.title = @"会展服务";
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];

    self.LeftItem = [ZWRightImageBtn buttonWithType:UIButtonTypeCustom];
    self.LeftItem.frame  = CGRectMake(0, 0, 80, 30);
    NSDictionary *cityDic = [[ZWSaveDataAction shareAction]takeCityName];
    if (cityDic) {
        [self.LeftItem setTitle:cityDic[@"cityName"] forState:UIControlStateNormal];
        [self setCityName:cityDic[@"cityName"]];
    }else {
        [self.LeftItem setTitle:@"选择城市" forState:UIControlStateNormal];
    }
    self.LeftItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.LeftItem setImage:[UIImage imageNamed:@"down_white_icon"] forState:UIControlStateNormal];
    [self.LeftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItemBtn = [[UIBarButtonItem alloc] initWithCustomView:self.LeftItem];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
}
- (void)leftItemClick:(UIButton *)btn {
    
    GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
//    cityPickerVC.locationCityID = @"1400010000";
//    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];// 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self yc_bottomPresentController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] presentedHeight:kScreenHeight completeHandle:nil];
    
}
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [[ZWSaveDataAction shareAction]saveCityName:@{@"cityName":city.cityName}];
    NSString *last = [city.shortName substringFromIndex:city.shortName.length-1];//字符串结尾
    NSString *shortCity = city.shortName;
    if ([last isEqualToString:@"市"]) {
        shortCity = [city.shortName substringToIndex:city.shortName.length-1];
    }
    city.shortName = shortCity;
    [self.LeftItem setTitle:city.cityName forState:UIControlStateNormal];
    self.selectedCity = city.shortName;
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];

    [self.dataArray removeAllObjects];
    self.page = 1;
    [self createRequest:self.page];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else {
        if (self.dataArray.count == 0) {
            return 1;
        }else {
            return self.dataArray.count;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)createBlankPagesWithCell:(UITableViewCell *)cell {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0, 0.6*kScreenWidth, 0.3*kScreenWidth)];
    imageView.image = [UIImage imageNamed:blankPagesImageName];
    [cell.contentView addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kScreenWidth, 30)];
    myLabel.text = @"暂无数据";
    myLabel.font = normalFont;
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:myLabel];
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGFloat itemWidth = kScreenWidth/5;
            CGFloat itemHeight = kScreenWidth/5;
            NSArray *titleArr = @[@"设计公司",
                                  @"展览工厂",
                                  @"制作拼单",
                                  @"会展租赁",
                                  @"会展餐饮",
                                  @"广告制作",
                                  @"五金建材",
                                  @"保险拼单",
                                  @"看馆拼单",
                                  @"货车拼单"];
            
            NSArray *iconArr = @[@"fu_icon_sheji",
                                 @"fu_icon_gogncang",
                                 @"fu_icon_zhantai",
                                 @"fu_icon_zulin",
                                 @"fu_icon_canyin",
                                 @"fu_icon_guanggao",
                                 @"fu_icon_wu",
                                 @"fu_icon_baoxian",
                                 @"fu_icon_kanguang",
                                 @"fu_icon_huoche"];
            
            for (int i = 0; i<titleArr.count; i++) {
                
                int row = i/5;
                int col = i%5;
                
                UIButton *mainBtn = [UButton buttonWithType:UIButtonTypeCustom];
                mainBtn.frame = CGRectMake(itemWidth*col, 15+row*itemHeight, itemWidth, itemHeight);
                mainBtn.titleLabel.font = [UIFont systemFontOfSize:0.03*kScreenWidth];
                [mainBtn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
                [mainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [mainBtn setTitle:titleArr[i] forState:UIControlStateNormal];
                mainBtn.tag = 1000+i;
                [mainBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mainBtn];
            }
        }else {
            NSMutableArray *images = [NSMutableArray array];
            for (int i=0; i<self.lbtAarry.count; i++) {
                NSString *imageStr = [NSString stringWithFormat:@"%@%@",httpImageUrl,self.lbtAarry[i]];
                [images addObject:imageStr];
            }

            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.94*kScreenWidth, 0.23*kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"fu_img_no_01"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.delegate = self;
            cycleScrollView.layer.cornerRadius = 3;
            cycleScrollView.layer.masksToBounds = YES;
            cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
            cycleScrollView.showPageControl = YES;
            cycleScrollView.imageURLStringsGroup = images;
            cycleScrollView.autoScrollTimeInterval = 3;
            cycleScrollView.currentPageDotImage = [UIImage imageWithColor:[UIColor whiteColor] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
            cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1] withCornerRadius:1.5 forSize:CGSizeMake(15, 3)];
            [cell.contentView addSubview:cycleScrollView];
            self.dataImages = images;
        }
    }else {
        
        if (self.dataArray.count == 0) {
            [self createBlankPagesWithCell:cell];
        }else {
            ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
            ZWExhServiceListCell *showCell = [[ZWExhServiceListCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3*kScreenWidth)];
            showCell.model = model;
            [cell.contentView addSubview:showCell];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.045*kScreenWidth, 0.3*kScreenWidth-1, 0.91*kScreenWidth, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1.0];
            [cell.contentView addSubview:lineView];
        }
        
    }

}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 30+kScreenWidth/5*2;
        }else {
            return 0.28*kScreenWidth;
        }
    }else {
        if (self.dataArray.count == 0) {
            return kScreenWidth;
        }else {
            return 0.3*kScreenWidth;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.45*kScreenWidth+30+kScreenWidth/5*2;
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.03*kScreenWidth;
    }else {
        return 0.1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        ZWServiceProvidersListModel *model = self.dataArray[indexPath.row];
        ZWCompanyDetailVC *companyDetailVC = [[ZWCompanyDetailVC alloc]init];
        companyDetailVC.serviceId = [NSString stringWithFormat:@"%@",model.providersId];
        companyDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyDetailVC animated:YES];
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tool = [[UIView alloc]init];
    tool.backgroundColor = zwGrayColor;
    return tool;
}

//点击图片的代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
   NSLog(@"index = %ld",(long)index);
    [[ZWPhotoBrowserAction shareAction]showImageViewUrls:self.dataImages tapIndex:index];
}


-(void)itemClick:(UIButton *)btn {
    //公司页面
    ZWCompanyDesignVC *companyDesignVC = [[ZWCompanyDesignVC alloc]init];
    companyDesignVC.selectedCity = self.selectedCity;
    companyDesignVC.hidesBottomBarWhenPushed = YES;
    ZWSpellListVC *spellListVC = [[ZWSpellListVC alloc]init];
    spellListVC.selectedCity = self.selectedCity;
    spellListVC.hidesBottomBarWhenPushed = YES;
    
    if (btn.tag == 1000) {
        companyDesignVC.title = @"设计公司";
        companyDesignVC.type = @"1";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1001) {
        companyDesignVC.title = @"展览工厂";
        companyDesignVC.type = @"4";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1002) {
        spellListVC.title = @"制作拼单";
        spellListVC.type = @"1";
        [self.navigationController pushViewController:spellListVC animated:YES];
    } else if (btn.tag == 1003) {
        companyDesignVC.title = @"展会租赁";
        companyDesignVC.type = @"6";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1004) {
        companyDesignVC.title = @"会展餐饮";
        companyDesignVC.type = @"5";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1005) {
        companyDesignVC.title = @"广告制作";
        companyDesignVC.type = @"3";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1006) {
        companyDesignVC.title = @"五金建材";
        companyDesignVC.type = @"2";
        [self.navigationController pushViewController:companyDesignVC animated:YES];
    } else if (btn.tag == 1007) {
        spellListVC.title = @"保险拼单";
        spellListVC.type = @"3";
        [self.navigationController pushViewController:spellListVC animated:YES];
    } else if (btn.tag == 1008) {
        spellListVC.title = @"看馆拼单";
        spellListVC.type = @"2";
        [self.navigationController pushViewController:spellListVC animated:YES];
    } else {
        spellListVC.title = @"货车拼单";
        spellListVC.type = @"4";
        [self.navigationController pushViewController:spellListVC animated:YES];
    }
    
}

//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
        
    }
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    __weak typeof (self) weakSelf = self;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        __strong typeof (weakSelf) strongSelf = weakSelf;
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
//             NSLog(@"我的国家：%@",placemark.country);
             NSLog(@"我的：%@",placemark.administrativeArea);
//             NSLog(@"我的城市：%@",placemark.locality);
             NSDictionary *locationCity = [[ZWSaveDataAction shareAction]takeCityName];
             
             NSLog(@"%@---%@",locationCity[@"cityName"],placemark.locality);
             
             if (locationCity) {
                 if ([placemark.locality isEqualToString:locationCity[@"cityName"]]) {
                     
                     if ([placemark.country isEqualToString:@"中国"]) {
                         [strongSelf setCityName:placemark.locality];
                     }else {
                         [strongSelf setCityName:placemark.country];
                     }
                 }else {
                     [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"系统检测到您当前所在的城市和之前选择的城市不一致，是否需要切换到您当前所在的城市？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                         __strong typeof (weakSelf) strongSelf = weakSelf;
                         if ([placemark.country isEqualToString:@"中国"]) {
                             [strongSelf setCityName:placemark.locality];
                         }else {
                             [strongSelf setCityName:placemark.country];
                         }
                     } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
                         __strong typeof (weakSelf) strongSelf = weakSelf;
                         [strongSelf setCityName:locationCity[@"cityName"]];
                     } showInView:self];
                 }
             }else {
                 if ([placemark.country isEqualToString:@"中国"]) {
                     [strongSelf setCityName:placemark.locality];
                 }else {
                     [strongSelf setCityName:placemark.country];
                 }
             }

         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

- (void)setCityName:(NSString *)cityName {
    [[ZWSaveDataAction shareAction]saveCityName:@{@"cityName":cityName}];
    NSLog(@"我的城市：%@",cityName);
    [self.LeftItem setTitle:cityName forState:UIControlStateNormal];
    if (cityName.length != 0) {
        NSString *last = [cityName substringFromIndex:cityName.length-1];//字符串结尾
        NSString *shortCity = cityName;
        if ([last isEqualToString:@"市"]) {
            shortCity = [cityName substringToIndex:cityName.length-1];
        }
        self.selectedCity = shortCity;
        NSLog(@"我的城市：%@",cityName);
        NSLog(@"截取的值为：%@",last);
        self.page = 1;
        [self createRequest:self.page];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        
    }
}
@end
