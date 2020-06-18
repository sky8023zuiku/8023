//
//  ZWMyExhibitionIndustriesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/7.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyExhibitionIndustriesVC.h"
#import "ZWMyIndustrinesCell.h"
#import "ZWChosenIndustriesModel.h"
#import "ZWSelectExhibitionIndustriesVC.h"

@interface ZWMyExhibitionIndustriesVC ()<UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation ZWMyExhibitionIndustriesVC
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0.03*kScreenWidth, kScreenWidth, kScreenHeight) collectionViewLayout:_layout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZWMyIndustrinesCell class] forCellWithReuseIdentifier:@"ZWMyIndustrinesCell"];
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = zwGrayColor;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRequest];
    [self createNavigationBar];
    [self createNotice];
}
- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createRequest) name:@"refreshCanReadExhibitionIndustryList" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshCanReadExhibitionIndustryList" object:nil];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithTitle:@"编辑" barItem:self.navigationItem target:self action:@selector(rightItemClick:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick:(UIButton *)btn {
    
    __weak typeof(self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            ZWSelectExhibitionIndustriesVC *industriesVC = [[ZWSelectExhibitionIndustriesVC alloc]init];
            industriesVC.myIndustries = data[@"data"];
            industriesVC.title = @"选择您感兴趣的展商行业";
            industriesVC.industriesArr = strongSelf.dataArray;
            [strongSelf.navigationController pushViewController:industriesVC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
}

- (void)createUI {
    self.view.backgroundColor = zwGrayColor;
    
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
    _layout.minimumLineSpacing=0.03*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.view addSubview:self.collectionView];
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
    return cell;
            
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-0.12*kScreenWidth)/3, (kScreenWidth-0.12*kScreenWidth)/3);
}
- (void)createRequest {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCanCheckOutTheExhibitionIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSArray *myData = data[@"data"][@"zwMerchantIndustryList"];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in myData) {
                ZWChosenIndustriesModel *model = [ZWChosenIndustriesModel parseJSON:myDic];
                [myArray addObject:model];
            }
            strongSelf.dataArray = myArray;
            [strongSelf.collectionView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}
@end
