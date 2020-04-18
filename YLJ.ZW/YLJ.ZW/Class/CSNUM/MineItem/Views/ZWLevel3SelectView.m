//
//  ZWLevel3SelectView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWLevel3SelectView.h"
#import "ZWLevel3SelectCell.h"
#import "ZWLevel3SelectReusableView.h"
#import "ZWIndustriesModel.h"
#import "ZWChosenIndustriesModel.h"

@interface ZWLevel3SelectView()
@property(nonatomic, strong)ZWLevel3SelectReusableView *reusableView;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation ZWLevel3SelectView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        self.delegate=self;
        self.dataSource=self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[ZWLevel3SelectCell class] forCellWithReuseIdentifier:@"ZWLevel3SelectCell"];
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[ZWLevel3SelectReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZWLevel3SelectReusableView"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mySelectIndustries:) name:@"mySelectIndustries" object:nil];
    
    }
    return self;
}

- (void)mySelectIndustries:(NSNotification *)notice {
    self.dataArray = notice.object;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"mySelectIndustries" object:nil];
}

#pragma UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.thirdIndustryList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZW3IndustriesModel *model = self.model.thirdIndustryList[indexPath.row];
        
    ZWLevel3SelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWLevel3SelectCell" forIndexPath:indexPath];
    cell.backgroundColor = zwGrayColor;
    cell.layer.cornerRadius = 5;
    cell.titleLabel.text = model.name;
    cell.titleLabel.font = smallMediumFont;
    cell.layer.masksToBounds = YES;
    
    NSLog(@"我的值在这里还剩下几个 = %@",self.selectArray);
    
    for (ZWChosenIndustriesModel *chosenModel in self.selectArray) {
        if ([(NSNumber *)model.industryId isEqualToNumber:chosenModel.industries3Id]) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
//    for (ZWChosenIndustriesModel *chosenModel in self.selectArray) {
//           if ([[NSString stringWithFormat:@"%@",model.industryId] isEqualToString:[NSString stringWithFormat:@"%@",chosenModel.industries3Name]]) {
//               cell.selected = YES;
//               [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//           }
//       }
    
    return cell;
    
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-0.15*kScreenWidth)/4, 0.08*kScreenWidth);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZW3IndustriesModel *model = self.model.thirdIndustryList[indexPath.row];
    ZWChosenIndustriesModel *chosenModel = [[ZWChosenIndustriesModel alloc]init];
    chosenModel.industries2Id = self.model.secondIndustryId;
    chosenModel.industries2Name = self.model.secondIndustryName;
    chosenModel.industries3Id = model.industryId;
    chosenModel.industries3Name = model.name;
        
    [[NSNotificationCenter defaultCenter]postNotificationName:@"takeIndustriesModel" object:chosenModel];
    
    NSLog(@"确认选择");
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"取消选择");
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"彻底取消");
    if([collectionView cellForItemAtIndexPath:indexPath].selected) {
        
        ZW3IndustriesModel *model = self.model.thirdIndustryList[indexPath.row];
        for (int i = 0; i < self.selectArray.count; i ++) {
            ZWChosenIndustriesModel *chosenModel = self.selectArray[i];
            if ([model.industryId isEqualToNumber:chosenModel.industries3Id]) {
                [self.selectArray removeObjectAtIndex:i];
            }
        }
        NSLog(@"我的数组的值还剩下几个 = %@",self.selectArray);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteIndustriesItem" object:self.selectArray];
        [self deselectItemAtIndexPath:indexPath animated:NO];
        [self collectionView:self didDeselectItemAtIndexPath:indexPath];
        return false;
    }
    return true;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(kScreenWidth, 0.13*kScreenWidth);
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {//定制头部视图的内容
        self.reusableView =(ZWLevel3SelectReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZWLevel3SelectReusableView" forIndexPath:indexPath];
        self.reusableView.titleLabel.text = self.model.secondIndustryName;
        self.reusableView.titleLabel.font = boldSmallMediumFont;
        self.reusableView.tag = indexPath.section;
        reusableView = self.reusableView;
    }
    return reusableView;
}



@end
