//
//  ZWFilterConditionsVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWFilterConditionsVC.h"
#import "ZWFilterConditionsCell.h"
#import "ZWConditionsListVC.h"
#import "ZWExExhibitorsModel.h"
#import "ZWIndustrysModel.h"

@interface ZWFilterConditionsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSMutableArray *industryArray;
@property(nonatomic, strong)NSNumber *industryId;

@end

@implementation ZWFilterConditionsVC

-(UICollectionView *)collectionView {
    
    _layout = [[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    _layout.minimumInteritemSpacing = 0.03*kScreenWidth;
    _layout.minimumLineSpacing= 0.03*kScreenWidth;
    [_layout setHeaderReferenceSize:CGSizeMake(kScreenWidth, 0.05*kScreenWidth)];
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, 0.94*kScreenWidth, kScreenHeight-zwNavBarHeight) collectionViewLayout:_layout];
    }
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZWFilterConditionsCell class] forCellWithReuseIdentifier:@"myCell"];
    _collectionView.showsVerticalScrollIndicator = NO;
//    _collectionView.allowsMultipleSelection = YES;//实现多选必须实现这个方法2、
    return _collectionView;
    
}

- (NSMutableArray *)industryArray {
    if (!_industryArray) {
        _industryArray = [NSMutableArray array];
    }
    return _industryArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createUI];
    [self createData];
}

- (void)createData {
    [self.industryArray addObjectsFromArray:self.industries];
    [self.industryArray removeObjectAtIndex:0];
    [self.collectionView reloadData];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}

- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.title = @"配对展商";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(0.03*kScreenWidth, kScreenHeight-zwTabBarHeight-ZWMasNavHeight-0.3*kScreenWidth, 0.94*kScreenWidth, 0.1*kScreenWidth);
    startBtn.backgroundColor = skinColor;
    startBtn.layer.cornerRadius = 3;
    [startBtn setTitle:@"开始匹配" forState:UIControlStateNormal];
    startBtn.layer.masksToBounds = YES;
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
}

- (void)startBtnClick:(UIButton *)btn {
    [self takePairData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.industryArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"myCell";
    ZWFilterConditionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myCell forIndexPath:indexPath];
    cell.backgroundColor = zwGrayColor;
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    ZWIndustrysModel *model = self.industryArray[indexPath.row];
    
    cell.titleLabel.text = model.industryName;

    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(0.88*kScreenWidth/3, 0.08*kScreenWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZWIndustrysModel *model = self.industryArray[indexPath.row];
    self.industryId = @([model.industryId integerValue]);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)takePairData {
    if (!self.industryId) {
        [self showAlertWithMessage:@"请选择需要配对的行业"];
        return;
    }
    NSDictionary *myDic = @{
        @"exhibitionId":self.exhibitionId,
        @"industryId":[NSString stringWithFormat:@"%@",self.industryId]
    };
    if (myDic) {
        [[ZWDataAction sharedAction]postReqeustWithURL:zwExExhibitoersPairList parametes:myDic successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                
                NSArray *myData = data[@"data"][@"exhibitorList"];
                NSMutableArray *myArray = [NSMutableArray array];
                for (NSDictionary *myDic in myData) {
                    ZWExExhibitorsModel *model = [ZWExExhibitorsModel parseJSON:myDic];
                    [myArray addObject:model];
                }
                ZWConditionsListVC *listVC = [[ZWConditionsListVC alloc]init];
                listVC.exhibitionId = self.exhibitionId;
                listVC.industryId = self.industryId;
                listVC.dataArray = myArray;
                [self.navigationController pushViewController:listVC animated:YES];
            }
        } failureBlock:^(NSError * _Nonnull error) {
                
        } showInView:self.view];
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
