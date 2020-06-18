//
//  ZWExhibitorsMenu.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsMenu.h"

#import "ZWDrawerItem.h"
#import "ZWDrawerHeardView.h"
#import "ZWMainSaveLocation.h"

#import "CSDrawerCountriesModel.h"
#import "CSDrawerCitiesModel.h"
#import "CSDrawerIndustiesModel.h"

#import "CSDrawerToolModel.h"


@interface ZWExhibitorsMenu()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)ZWDrawerHeardView *headerView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)BOOL isSelected;

@property(nonatomic, strong)NSArray *tapTypes;

@end

@implementation ZWExhibitorsMenu

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self == [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.backgroundColor = zwGrayColor;
                
        _layout=[[UICollectionViewFlowLayout alloc]init];
        [_layout prepareLayout];
        //设置每个cell与相邻的cell之间的间距
        _layout.minimumInteritemSpacing = 1;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0.03*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
        _layout.minimumLineSpacing=0.03*kScreenWidth;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        NSInteger typesCount = 3;
        NSMutableArray *myTypes = [NSMutableArray array];
        for (int i = 0; i < typesCount; i ++) {
            CSDrawerToolModel *typeModel = [[CSDrawerToolModel alloc]init];
            typeModel.isOpen = 0;
            [myTypes addObject:typeModel];
        }
        self.tapTypes = myTypes;
        
        self.dataArray = [NSMutableArray array];
        [self initIndustries];
        [self initCountries];
        [self initCities];
        
    }
    return self;
}

#pragma 获取数据

- (void)initCountries {
    NSArray *countryArray = [[ZWMainSaveLocation shareAction]takeCountroiesListData];
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in countryArray) {
        CSDrawerCountriesModel *model = [CSDrawerCountriesModel parseJSON:myDic];
        [myArray addObject:model];
    }
    [self.dataArray addObject:myArray];
    [self reloadData];
}
- (void)initCities {
    NSArray *cityArray = [[ZWMainSaveLocation shareAction]takeCitiesListData];
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in cityArray) {
        CSDrawerCitiesModel *model = [CSDrawerCitiesModel parseJSON:myDic];
        [myArray addObject:model];
    }
    [self.dataArray addObject:myArray];
    [self reloadData];
}

- (void)initIndustries {
    NSArray *industryArray = [[ZWMainSaveLocation shareAction]takeIndustriesListData];
    NSMutableArray *myArray = [NSMutableArray array];
    for (NSDictionary *myDic in industryArray) {
        CSDrawerIndustiesModel *model = [CSDrawerIndustiesModel parseJSON:myDic];
        [myArray addObject:model];
    }
    [self.dataArray addObject:myArray];
    [self reloadData];
}


#define UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    if (indexPath.row == 0) {
        NSArray *myArray = @[@"行业",@"国家",@"城市"];
        self.headerView = [[ZWDrawerHeardView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3*2, 0.13*kScreenWidth)];
        self.headerView.titleLabel.text = myArray[indexPath.section];
        NSString *nameStr = self.selectData[indexPath.section][@"name"];
        if ([nameStr isEqualToString:@""]) {
            self.headerView.detailLabel.text = @"不限";
        }else {
            self.headerView.detailLabel.text = self.selectData[indexPath.section][@"name"];
        }
        self.headerView.tag = indexPath.section;

        CSDrawerToolModel *typeModel = self.tapTypes[indexPath.section];
        if (typeModel.isOpen == 1) {
            [self.headerView.arrowImageView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        }else {
            [self.headerView.arrowImageView setTransform:CGAffineTransformIdentity];
        }
        
        [cell.contentView addSubview:self.headerView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.headerView addGestureRecognizer:tap];
        
    }else {
        
        if ([self.selectData[1][@"name"] isEqualToString:@""]||[self.selectData[1][@"name"] isEqualToString:@"中国"]) {
            NSArray *cityArray = [[ZWMainSaveLocation shareAction]takeCitiesListData];
            NSMutableArray *myArray = [NSMutableArray array];
            for (NSDictionary *myDic in cityArray) {
                CSDrawerCitiesModel *model = [CSDrawerCitiesModel parseJSON:myDic];
                [myArray addObject:model];
            }
            [self.dataArray replaceObjectAtIndex:2 withObject:myArray];
        }else {
            [self.dataArray replaceObjectAtIndex:2 withObject:@[]];
        }
        
        //*******第一次*********/
        NSArray *myData = [self takeMyDataWithIndex:indexPath.section];
        
        NSInteger a = myData.count%4;
        NSInteger b = myData.count/4;
        CGFloat height;
        if (a!=0) {
            height = 0.03*kScreenWidth*(b+1) +0.065*kScreenWidth*(b+1);
        }else {
            height = 0.03*kScreenWidth*b +0.065*kScreenWidth*b;
        }
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height) collectionViewLayout:_layout];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[ZWDrawerItem class] forCellWithReuseIdentifier:@"ZWDrawerItem"];
        self.collectionView.showsVerticalScrollIndicator=NO;
        self.collectionView.showsHorizontalScrollIndicator=NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.tag = indexPath.section;
        [cell.contentView addSubview:self.collectionView];
        
    }
}

#define UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 0.13*kScreenWidth;
    }else {
        //*******第二次*********/
        NSArray *myData = [self takeMyDataWithIndex:indexPath.section];
        
        NSInteger a = myData.count%4;
        NSInteger b = myData.count/4;
        
        CGFloat height;
        if (a!=0) {
            height = 0.03*kScreenWidth*(b+1) +0.065*kScreenWidth*(b+1);
        }else {
            height = 0.03*kScreenWidth*b +0.065*kScreenWidth*b;
        }
        return height;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSLog(@"111--111");
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSLog(@"----%ld",(long)tap.view.tag);
    CSDrawerToolModel *model = self.tapTypes[tap.view.tag];
    if (model.isOpen == 0) {
        model.isOpen = 1;
    }else {
        model.isOpen = 0;
    }
    [self reloadData];
}

#define UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //*******第三次*********/
    NSArray *myData = [self takeMyDataWithIndex:collectionView.tag];
    return myData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //*******第四次*********/
    NSArray *myData = [self takeMyDataWithIndex:collectionView.tag];
    
    ZWDrawerItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWDrawerItem" forIndexPath:indexPath];
    item.backgroundColor = zwGrayColor;
    item.layer.cornerRadius = 5;
    item.layer.masksToBounds = YES;
    
    if (collectionView.tag == 0) {
        CSDrawerIndustiesModel *model = myData[indexPath.item];
        item.titleLabel.text = model.name;
        for (NSDictionary *myDic in self.selectData) {
            if ([myDic[@"name"] isEqualToString:model.name]) {
                item.selected = YES;
                [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }else if (collectionView.tag == 1) {
        
        CSDrawerCountriesModel *model = myData[indexPath.item];
        item.titleLabel.text = model.name;
        for (NSDictionary *myDic in self.selectData) {
            if ([myDic[@"name"] isEqualToString:model.name]) {
                item.selected = YES;
                [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }else {
        CSDrawerCitiesModel *model = myData[indexPath.item];
        item.titleLabel.text = model.name;
        for (NSDictionary *myDic in self.selectData) {
            if ([myDic[@"name"] isEqualToString:model.name]) {
                item.selected = YES;
                [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }
    return item;
}

- (NSArray *)takeMyDataWithIndex:(NSInteger)index {
    
    NSArray *myData = self.dataArray[index];
    NSArray *data;
    CSDrawerToolModel *model = self.tapTypes[index];
    if (model.isOpen == 0) {
        if (myData.count>8) {
            data = [myData subarrayWithRange:NSMakeRange(0, 8)];
        }else {
            data = myData;
        }
    }else {
        data = myData;
    }
    return data;
    
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth/3*2-0.15*kScreenWidth)/4, 0.065*kScreenWidth);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"选择");
    NSArray *myArray = [self takeMyDataWithIndex:collectionView.tag];
    
    NSLog(@"--- %@",myArray);
    
    if (collectionView.tag == 0) {
        CSDrawerIndustiesModel *model = myArray[indexPath.item];
        NSDictionary *myDic = @{@"id":model.industriesId,@"name":model.name};
        [self.selectData replaceObjectAtIndex:0 withObject:myDic];
    }else if (collectionView.tag == 1) {
        CSDrawerCountriesModel *model = myArray[indexPath.item];
        NSDictionary *myDic = @{@"id":model.countriesId,@"name":model.name};
        [self.selectData replaceObjectAtIndex:1 withObject:myDic];
        
        if ([model.name isEqualToString:@"中国"]) {
            [self refreshTheCitiesShow:YES];
        }else {
            [self refreshTheCitiesShow:NO];
        }
    }else {
        CSDrawerCitiesModel *model = myArray[indexPath.item];
        NSDictionary *myDic = @{@"id":model.citiesId,@"name":model.name};
        [self.selectData replaceObjectAtIndex:2 withObject:myDic];
    }
    [self refreshCellWithIndex:collectionView.tag];
    
}

- (void)refreshTheCitiesShow:(BOOL)isShow {
    
    if (isShow == YES) {
        NSArray *cityArray = [[ZWMainSaveLocation shareAction]takeCitiesListData];
        NSMutableArray *myArray = [NSMutableArray array];
        for (NSDictionary *myDic in cityArray) {
            CSDrawerCitiesModel *model = [CSDrawerCitiesModel parseJSON:myDic];
            [myArray addObject:model];
        }
        [self.dataArray replaceObjectAtIndex:2 withObject:myArray];
        
        NSIndexPath *myIndex = [NSIndexPath indexPathForRow:1 inSection:2];
        [self reloadRowsAtIndexPaths:@[myIndex] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        NSDictionary *myDic = @{@"id":@"",@"name":@""};
        [self.selectData replaceObjectAtIndex:2 withObject:myDic];
        [self refreshCellWithIndex:2];
        
        [self.dataArray replaceObjectAtIndex:2 withObject:@[]];
        
        NSIndexPath *myIndex = [NSIndexPath indexPathForRow:1 inSection:2];
        [self reloadRowsAtIndexPaths:@[myIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
}



-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"取消");
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"彻底取消");
    if([collectionView cellForItemAtIndexPath:indexPath].selected) {
        NSDictionary *myDic = @{@"id":@"",@"name":@""};
        if (collectionView.tag == 0) {
            [self.selectData replaceObjectAtIndex:0 withObject:myDic];
        }else if (collectionView.tag == 1) {
            [self.selectData replaceObjectAtIndex:1 withObject:myDic];
        }else {
            [self.selectData replaceObjectAtIndex:2 withObject:myDic];
        }
        [self refreshTheCitiesShow:YES];
        [self refreshCellWithIndex:collectionView.tag];
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        return false;
    }
    return true;
    
}

- (void)refreshCellWithIndex:(NSInteger)index {
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:0 inSection:index];
    [self reloadRowsAtIndexPaths:@[myIndex] withRowAnimation:UITableViewRowAnimationNone];
    
    NSLog(@"选择 = %@",self.selectData);
}

@end
