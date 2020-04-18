//
//  ZWHallFloorPlanVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallFloorPlanVC.h"
#import "ZWHallFloorPlanCell.h"
#import "ZWFloorPlanModel.h"

@interface ZWHallFloorPlanVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation ZWHallFloorPlanVC

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) collectionViewLayout:_flowLayout];
        [_collectionView registerClass:[ZWHallFloorPlanCell class] forCellWithReuseIdentifier:@"cell"];
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = zwGrayColor;
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"展厅平面图";
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@""] barItem:self.tabBarController.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)rightItemClick:(UIBarButtonItem *)item {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0.5*kScreenWidth, 0.6*kScreenWidth, 0.1*kScreenWidth)];
//    label.text = @"功能建设中，敬请期待";
//    label.textColor = [UIColor lightGrayColor];
//    label.font = normalFont;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
    
    [self requestAction];
}
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat with = 0.3*kScreenWidth/6;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = with;
    _flowLayout.minimumInteritemSpacing = 0.095*kScreenWidth;
    _flowLayout.sectionInset = UIEdgeInsetsMake(with, with, with, with);
    [self.view addSubview:self.collectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWFloorPlanModel *model = self.dataArray[indexPath.item];
    
    ZWHallFloorPlanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 0.5;
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = model.hallNumberName;
    cell.titleLabel.font = normalFont;
    return cell;
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake((0.7*kScreenWidth)/3, (0.23*kScreenWidth)/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZWFloorPlanModel *model = self.dataArray[indexPath.item];
    if (model.images.count > 0) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *imageStr in model.images) {
            NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,imageStr];
            [images addObject:url];
        }
        [[ZWPhotoBrowserAction shareAction]showImageViewUrls:images tapIndex:0];
    }else {
        [self showOneAlertWithMessage:@"暂无展厅平面图"];
    }
}


- (void)requestAction {
    
    NSLog(@"%@",self.hallId);
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwHallFloorPlan parametes:@{@"hallId":self.hallId} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWFloorPlanModel *model = [ZWFloorPlanModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataArray = myArray;
            [strongSelf.collectionView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {

        
    }];
    
}


- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
