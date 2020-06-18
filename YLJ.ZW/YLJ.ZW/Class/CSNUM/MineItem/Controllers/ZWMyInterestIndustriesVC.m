//
//  ZWMyInterestIndustriesVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInterestIndustriesVC.h"
#import "MPGestureLayout.h"
#import "ZWMyIndustrinesCell.h"
#import "ZWChosenIndustriesModel.h"
#import "ZWSelectExIntIndustriesVC.h"

@interface ZWMyInterestIndustriesVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource ,UICollectionViewDelegate,MPGestureLayout>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)MPGestureLayout *layout;
@property(nonatomic, strong)NSMutableArray *dataExhibitorArray;//展商行业数据
@property(nonatomic, strong)NSMutableArray *dataServerArray;//会展服务商行业数据
@property(nonatomic, strong)ZWChosenIndustriesModel *compareExhibitorModel;//展商行业
@property(nonatomic, strong)ZWChosenIndustriesModel *compareSeversModel;//会展服务商行业


@property(nonatomic, strong)UICollectionView *exhibitorCollectionView;
@property(nonatomic, strong)UICollectionView *serverCollectionView;

@property(nonatomic, assign)NSInteger selectCollectionindex;
@end

@implementation ZWMyInterestIndustriesVC
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwNavBarHeight) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.showsHorizontalScrollIndicator = NO;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
    [self createRequest];
    [self createNotice];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UINavigationItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createRequest) name:@"refreshIndustryDataInterest" object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshIndustryDataInterest" object:nil];
}

- (void)createUI {
    self.title = @"我感兴趣的行业";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self ceateTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)ceateTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editorBtn.frame = CGRectMake(kScreenWidth-0.15*kScreenWidth, 0, 0.15*kScreenWidth, 0.065*kScreenWidth);
    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editorBtn.backgroundColor = skinColor;
    editorBtn.titleLabel.textColor = [UIColor whiteColor];
    editorBtn.titleLabel.font = normalFont;
    editorBtn.tag = indexPath.section;
    [editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editorBtn];
    
    
    _layout=[[MPGestureLayout alloc]init];
    [_layout prepareLayout];
    //设置每个cell与相邻的cell之间的间距
    _layout.minimumInteritemSpacing = 1;
    _layout.delegate = self;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
    _layout.minimumLineSpacing=0.03*kScreenWidth;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth, kScreenWidth, 0.3*kScreenWidth) collectionViewLayout:_layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZWMyIndustrinesCell class] forCellWithReuseIdentifier:@"ZWMyIndustrinesCell"];
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.tag = indexPath.section;
    if (indexPath.section == 0) {
        self.exhibitorCollectionView = _collectionView;
        [cell.contentView addSubview:self.exhibitorCollectionView];
    }else {
        self.serverCollectionView = _collectionView;
        [cell.contentView addSubview:self.serverCollectionView];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.4*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"感兴趣的展商行业",@"感兴趣的服务商行业"];
    return titles[section];
}


-(void)editorBtnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        __weak typeof(self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                ZWSelectExIntIndustriesVC *industriesVC = [[ZWSelectExIntIndustriesVC alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您感兴趣的展商行业";
                industriesVC.industriesArr = strongSelf.dataExhibitorArray;
                industriesVC.type = @"2";
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self.view];
    } else {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]getReqeustWithURL:zwGetExhibitionServerIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                ZWSelectExIntIndustriesVC *industriesVC = [[ZWSelectExIntIndustriesVC alloc]init];
                industriesVC.myIndustries = data[@"data"];
                industriesVC.title = @"选择您感兴趣的会展服务商行业";
                industriesVC.industriesArr = strongSelf.dataServerArray;
                industriesVC.type = @"3";
                [strongSelf.navigationController pushViewController:industriesVC animated:YES];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            
        } showInView:self.view];
    }
}

//****************************************************************测试********************************************************************/


#pragma UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 0) {
        return self.dataExhibitorArray.count;
    }else {
        return self.dataServerArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWChosenIndustriesModel *model;
    if (collectionView.tag == 0) {
        model = self.dataExhibitorArray[indexPath.row];
    }else {
        model = self.dataServerArray[indexPath.row];
    }
    ZWMyIndustrinesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWMyIndustrinesCell" forIndexPath:indexPath];
    cell.backgroundColor = zwGrayColor;
    cell.layer.cornerRadius = 5;
    cell.secondLB.text = model.industries2Name;
    cell.secondLB.font = smallMediumFont;
    cell.thirdLB.text = model.industries3Name;
    cell.thirdLB.font = smallFont;
    cell.layer.masksToBounds = YES;
    
    CGFloat width = (kScreenWidth-0.12*kScreenWidth)/5;
    CGFloat height = (kScreenWidth-0.12*kScreenWidth)/5;

    CGFloat labelW = [[ZWToolActon shareAction]adaptiveTextWidth:@"默认" labelFont:smallFont]+10;
    UILabel*defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-labelW, 0, labelW, 0.165*height)];
    defaultLabel.text = @"默认";
    defaultLabel.font = [UIFont systemFontOfSize:0.02*kScreenWidth];
    defaultLabel.backgroundColor = skinColor;
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.textColor = [UIColor whiteColor];
    [cell addSubview:defaultLabel];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: defaultLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = defaultLabel.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    defaultLabel.layer.mask = maskLayer;

    if (indexPath.row == 0) {
        cell.layer.borderColor = skinColor.CGColor;
        cell.layer.borderWidth = 2;
        defaultLabel.backgroundColor = skinColor;
        defaultLabel.textColor = [UIColor whiteColor];
    }else {
        cell.layer.borderColor = zwGrayColor.CGColor;
        cell.layer.borderWidth = 0;
        defaultLabel.backgroundColor = zwGrayColor;
        defaultLabel.textColor = zwGrayColor;
    }
    
    return cell;
            
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-0.12*kScreenWidth)/5, (kScreenWidth-0.12*kScreenWidth)/5);
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

- (void)mp_moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (_layout.collectionIndex == 0) {
        [self.dataExhibitorArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }else {
        [self.dataServerArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
}

- (void)mp_removeDataObjectAtIndex:(NSIndexPath *)index {

//      [self.dataArray removeObjectAtIndex:index.row];
}

- (CGRect)mp_RectForDelete {

    return  CGRectMake(0, self.view.frame.size.height-50, YScreenWidth, 50);

}

//- (NSArray<NSIndexPath *> *)mp_disableMoveItemArray {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
//    return @[indexPath];
//
//}

- (void)mp_didEndGesture {
   NSLog(@"----22222----%ld",_layout.collectionIndex);
    if (_layout.collectionIndex == 0) {
        ZWChosenIndustriesModel *model = self.dataExhibitorArray[0];
        if (![self.compareExhibitorModel.industries3Id isEqualToNumber:model.industries3Id]) {
            [self updateMyMainIndustries:self.dataExhibitorArray withType:@"2"];
        }
    }else {
        ZWChosenIndustriesModel *model = self.dataServerArray[0];
        if (![self.compareSeversModel.industries3Id isEqualToNumber:model.industries3Id]) {
            [self updateMyMainIndustries:self.dataServerArray withType:@"3"];
        }
    }
}
- (void)updateMyMainIndustries:(NSMutableArray *)array withType:(NSString *)type{
    NSMutableArray *myArray = [NSMutableArray array];
    for (ZWChosenIndustriesModel *model in array) {
        [myArray addObject:model.industries3Id];
    }
    NSDictionary *parametes;
    if (myArray) {
        parametes = @{@"idList":myArray,
                      @"type":type};
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwUpdateMyInterestIndustriesList parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshExhibitorsPageData" object:nil];
            [strongSelf createRequest];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self.view];
    
}

- (void)createRequest {
    [[ZWDataAction sharedAction]getReqeustWithURL:zwGetInterestIndustriesList parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            //感兴趣的展商行业
            NSArray *merchants = data[@"data"][@"zwMerchantIndustryList"];
            self.dataExhibitorArray = [self takeArrayWithArray:merchants];
            if (self.dataExhibitorArray.count != 0 ) {
                self.compareExhibitorModel = self.dataExhibitorArray[0];
            }
            //感兴趣的服务商行业
            NSArray *services = data[@"data"][@"zwServiceIndustryList"];
            self.dataServerArray = [self takeArrayWithArray:services];;
            if (self.dataServerArray.count != 0 ) {
                self.compareSeversModel = self.dataServerArray[0];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

-(NSMutableArray *)takeArrayWithArray:(NSArray *)data {
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in data) {
        ZWChosenIndustriesModel *model = [[ZWChosenIndustriesModel alloc]init];
        model.industries2Id = myDic[@"secondIndustryId"];
        model.industries2Name = myDic[@"secondIndustryName"];
        model.industries3Id = myDic[@"thirdIndustryId"];
        model.industries3Name = myDic[@"thirdIndustryName"];
        [myArray addObject:model];
    }
    return myArray;
}



@end
