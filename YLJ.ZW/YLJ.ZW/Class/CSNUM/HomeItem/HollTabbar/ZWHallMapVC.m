//
//  ZWHallMapVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallMapVC.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomAnnotationView.h"
#import "PointModel.h"

@interface ZWHallMapVC ()<MAMapViewDelegate,CustomAnnotationViewDelegate>
@property(nonatomic, strong)MAMapView *mapView;
@property(nonatomic, strong)NSMutableArray *searchPoiArray;// 坐标数据源
@property(nonatomic, assign)CLLocationCoordinate2D centerCoordinate;
@end

@implementation ZWHallMapVC
// 装载数据坐标
-(NSMutableArray *)searchPoiArray
{
    if (!_searchPoiArray) {
        _searchPoiArray = [[NSMutableArray alloc]init];
    }
    return _searchPoiArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initMap];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"展馆位置";
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"more_icon"] barItem:self.tabBarController.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)rightItemClick:(UIBarButtonItem *)item {

    [self navThirdMapWithLocation:self.centerCoordinate andTitle:self.model.hallName];
}
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initMap {
    
    self.centerCoordinate = CLLocationCoordinate2DMake([self.model.latitude doubleValue],[self.model.longitude doubleValue]);
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwTabBarHeight)];
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 13;
    self.mapView.centerCoordinate = self.centerCoordinate;
    self.mapView.minZoomLevel = 3;
    self.mapView.maxZoomLevel = 19;
    self.mapView.showsUserLocation = NO;
    [self.mapView performSelector:@selector(setShowsWorldMap:) withObject:@YES];
    [self.view addSubview:self.mapView];
    
    PointModel *pointAnnotation = [[PointModel alloc]init];
    pointAnnotation.coordinate = self.centerCoordinate;
    pointAnnotation.titleStr = self.model.hallName;
    pointAnnotation.titleImage =[NSString stringWithFormat:@"%@%@",httpImageUrl,self.model.coverImage];
    pointAnnotation.addressStr = self.model.address;
    [self.searchPoiArray addObject:pointAnnotation];
    [self.mapView addAnnotations:self.searchPoiArray];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.delegate =self;
        PointModel *ann = (PointModel *)annotation;
        [annotationView sendModel:ann];
        annotationView.centerOffset = CGPointMake(0, -annotationView.bounds.size.height/2);
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    return nil;
}

- (void)tapCallout:(PointModel *)model {
    
    [self navThirdMapWithLocation:self.centerCoordinate andTitle:self.model.hallName];
}

-(void)navThirdMapWithLocation:(CLLocationCoordinate2D)endLocation andTitle:(NSString *)titleStr{
    
    NSMutableArray *mapsA = [NSMutableArray array];
    //苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [mapsA addObject:iosMapDic];
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=ios.blackfish.XHY&dlat=%f&dlon=%f&dname=%@&style=2",endLocation.latitude,endLocation.longitude,titleStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [mapsA addObject:gaodeMapDic];
    }
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&coord_type=gcj02&mode=driving&src=ios.blackfish.XHY",endLocation.latitude,endLocation.longitude,titleStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [mapsA addObject:baiduMapDic];
    }
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&to=%@&tocoord=%f,%f&coord_type=1&referer={ios.blackfish.XHY}",titleStr,endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [mapsA addObject:qqMapDic];
    }
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航",@"导航",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [mapsA addObject:googleMapDic];
    }
    //手机地图个数判断
    if (mapsA.count > 0) {
        //选择
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"使用导航" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSInteger index = mapsA.count;
        
        for (int i = 0; i < index; i++) {
            
            NSString *title = mapsA[i][@"title"];
            NSString *urlString = mapsA[i][@"url"];
            if (i == 0) {
                
                UIAlertAction *iosAntion = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self appleNaiWithCoordinate:endLocation andWithMapTitle:titleStr];
                }];
                [alertVC addAction:iosAntion];
                continue;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            
            [alertVC addAction:action];
        }
        
        UIAlertAction *cancleAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:cancleAct];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        NSLog(@"未检测到地图应用");
    }
}

//唤醒苹果自带导航
- (void)appleNaiWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    tolocation.name = map_title;
    [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                        MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}


@end
