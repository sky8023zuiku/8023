//
//  ZWHallFloorPlanVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallFloorPlanVC.h"
#import "ZWHallFloorPlanCell.h"

@interface ZWHallFloorPlanVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
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
//    [self createUI];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.2*kScreenWidth, 0.5*kScreenWidth, 0.6*kScreenWidth, 0.1*kScreenWidth)];
    label.text = @"功能建设中，敬请期待";
    label.textColor = [UIColor lightGrayColor];
    label.font = normalFont;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
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
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZWHallFloorPlanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.layer.borderWidth = 0.5;
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = @"W3馆";
    cell.titleLabel.font = normalFont;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake((0.7*kScreenWidth)/3, (0.23*kScreenWidth)/3);
}

@end
