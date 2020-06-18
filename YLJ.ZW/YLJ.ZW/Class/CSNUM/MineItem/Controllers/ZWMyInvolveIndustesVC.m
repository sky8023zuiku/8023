//
//  ZWMyInvolveIndustesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/6.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInvolveIndustesVC.h"
#import "ZWMyIndustrinesCell.h"
#import "ZWCollectionViewAddCell.h"
#import "ZWChosenIndustriesModel.h"
#import "MPGestureLayout.h"
#import "ZWSelectIndustriesVC.h"
#import "ZWSelectIndustriesVC_v2.h"
#import <MBProgressHUD.h>

#import "ZWExhibitionServerSelectIndustriesVC.h"

@interface ZWMyInvolveIndustesVC ()<UICollectionViewDataSource ,UICollectionViewDelegate,MPGestureLayout>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)MPGestureLayout *layout;
@property(nonatomic, assign)NSInteger itemNum;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (strong, nonatomic)UIView *deleteView;
@property(nonatomic, strong)ZWChosenIndustriesModel *compareModel;

@end

@implementation ZWMyInvolveIndustesVC

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth, kScreenWidth, kScreenHeight) collectionViewLayout:_layout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZWMyIndustrinesCell class] forCellWithReuseIdentifier:@"ZWMyIndustrinesCell"];
        [_collectionView registerClass:[ZWCollectionViewAddCell class] forCellWithReuseIdentifier:@"ZWCollectionViewAddCell"];
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = zwGrayColor;
    }
    return _collectionView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self takeIndustriesList];
}

- (void)takeIndustriesList {
    
//    NSDictionary *userInfo = [[ZWSaveDataAction shareAction]takeUserInfoData];
//    NSArray *myData = userInfo[@"industryVoList"];
//    NSMutableArray *myArray = [NSMutableArray array];
//    for (NSDictionary *myDic in myData) {
//        ZWChosenIndustriesModel *model = [[ZWChosenIndustriesModel alloc]init];
//        model.industries2Id = myDic[@"secondIndustryId"];
//        model.industries2Name = myDic[@"secondIndustryName"];
//        model.industries3Id = myDic[@"thirdIndustryId"];
//        model.industries3Name = myDic[@"thirdIndustryName"];
//        [myArray addObject:model];
//    }
//    self.dataArray = myArray;
//    if (self.dataArray.count != 0 ) {
//        self.compareModel = self.dataArray[0];
//    }
//    [self.collectionView reloadData];
    
    [[ZWDataAction sharedAction]getReqeustWithURL:zwGetInvolveIndustresList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWChosenIndustriesModel *model = [[ZWChosenIndustriesModel alloc]init];
                model.industries2Id = myDic[@"secondIndustryId"];
                model.industries2Name = myDic[@"secondIndustryName"];
                model.industries3Id = myDic[@"thirdIndustryId"];
                model.industries3Name = myDic[@"thirdIndustryName"];
                [myArray addObject:model];
            }
            self.dataArray = myArray;
            if (self.dataArray.count != 0 ) {
                self.compareModel = self.dataArray[0];
            }
            [self.collectionView reloadData];
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"编辑" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UINavigationItem *)item {
    [self takeListOfIndustries];
}
- (void)takeListOfIndustries {
    
    if ([self.roleId isEqualToNumber:@2]||[self.roleId isEqualToNumber:@3]||[self.roleId isEqualToNumber:@3]) {
        __weak typeof(self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {

                ZWSelectIndustriesVC_v2 *industriesVC = [[ZWSelectIndustriesVC_v2 alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您所涉及的行业";
                industriesVC.industriesArr = strongSelf.dataArray;
                industriesVC.type = 2;
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
                
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self.view];
    } else {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwGetExhibitionServerIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                
                ZWExhibitionServerSelectIndustriesVC *industriesVC = [[ZWExhibitionServerSelectIndustriesVC alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您所涉及的行业";
                industriesVC.industriesArr = strongSelf.dataArray;
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
                
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
}

- (void)createUI {
    self.view.backgroundColor = zwGrayColor;
    
    _layout=[[MPGestureLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.delegate = self;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
    _layout.minimumLineSpacing=0.03*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.view addSubview:self.collectionView];
    
    
    CGRect deleteRect = CGRectMake(0, kScreenHeight-zwNavBarHeight, kScreenWidth, zwTabBarHeight);
    UIView *view  = [[UIView alloc] initWithFrame:deleteRect];
    view.backgroundColor = [UIColor redColor];
    
    self.deleteView = view;
    [self.view addSubview:view];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0, 0.9*kScreenWidth, 0.15*kScreenWidth)];
    noticeLabel.text = @"注：将按钮拖拽到第一个位置可变更默认行业！";
    noticeLabel.font = normalFont;
    noticeLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    [self.view addSubview:noticeLabel];
    
}


#pragma UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWChosenIndustriesModel *model = self.dataArray[indexPath.row];
    ZWMyIndustrinesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWMyIndustrinesCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.secondLB.text = model.industries2Name;
    cell.thirdLB.text = model.industries3Name;
    cell.layer.masksToBounds = YES;
    
    
//    CGFloat width = (kScreenWidth-0.12*kScreenWidth)/3;
//    CGFloat height = (kScreenWidth-0.12*kScreenWidth)/3;
//
//    CGFloat labelW = [[ZWToolActon shareAction]adaptiveTextWidth:@"默认" labelFont:smallFont]+10;
//    UILabel*defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-labelW, 0, labelW, 0.13*height)];
//    defaultLabel.text = @"默认";
//    defaultLabel.font = smallFont;
//    defaultLabel.backgroundColor = skinColor;
//    defaultLabel.textAlignment = NSTextAlignmentCenter;
//    defaultLabel.textColor = [UIColor whiteColor];
//    [cell addSubview:defaultLabel];
//
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: defaultLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
//    //创建 layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = defaultLabel.bounds;
//    //赋值
//    maskLayer.path = maskPath.CGPath;
//    defaultLabel.layer.mask = maskLayer;
//
//    if (indexPath.row == 0) {
//        cell.layer.borderColor = skinColor.CGColor;
//        cell.layer.borderWidth = 2;
//        defaultLabel.backgroundColor = skinColor;
//    }else {
//        cell.layer.borderColor = zwGrayColor.CGColor;
//        cell.layer.borderWidth = 0;
//        defaultLabel.backgroundColor = [UIColor whiteColor];
//    }
    
    return cell;
            
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-0.12*kScreenWidth)/3, (kScreenWidth-0.12*kScreenWidth)/3);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"确认选择");
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"取消选择");
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"彻底取消");
    return true;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(kScreenWidth, 0.03*kScreenWidth);
    return size;
}
//
//- (void)mp_moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//    [self.dataArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//
//}
//
//- (void)mp_removeDataObjectAtIndex:(NSIndexPath *)index {
//
//      [self.dataArray removeObjectAtIndex:index.row];
//}

//- (CGRect)mp_RectForDelete {
//
//    return  CGRectMake(0, self.view.frame.size.height-50, YScreenWidth, 50);
//
//}

//- (NSArray<NSIndexPath *> *)mp_disableMoveItemArray {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
//    return @[indexPath];
//
//}

//- (void)mp_didMoveToDeleteArea {
//
//}
//
//- (void)mp_didLeaveToDeleteArea {
//
//
//}
//
//- (void)mp_willBeginGesture {
//
//}

//- (void)mp_didEndGesture {
//    ZWChosenIndustriesModel *model = self.dataArray[0];
//    if (![self.compareModel.industries3Id isEqualToNumber:model.industries3Id]) {
//        [self updateMyMainIndustries];
//    }
//}
//- (void)updateMyMainIndustries {
//    NSMutableArray *myArray = [NSMutableArray array];
//    for (ZWChosenIndustriesModel *model in self.dataArray) {
//        [myArray addObject:model.industries3Id];
//    }
//
//    NSDictionary *parametes;
//    if (myArray) {
//        parametes = @{@"industryList":myArray,
//                      @"defaultIndustryId":myArray[0]};
//    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    __weak typeof (self) weakSelf = self;
//    [[ZWDataAction sharedAction]postReqeustWithURL:zwUpdateMyIndustriesList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        if (zw_issuccess) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshExhibitorsPageData" object:nil];
//            [strongSelf updateUserInfo];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}

//- (void)updateUserInfo {
//    __weak typeof (self) weakSelf = self;
//    [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeUserInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (zw_issuccess) {
//
//            NSDictionary *myDic = data[@"data"];
//            if (myDic) {
//                [[ZWSaveDataAction shareAction]saveUserInfoData:myDic];
//            }
//            [strongSelf takeIndustriesList];
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//       [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}
//
//- (UIView *)mp_moveMainView{
//    return self.view;
//}

@end
