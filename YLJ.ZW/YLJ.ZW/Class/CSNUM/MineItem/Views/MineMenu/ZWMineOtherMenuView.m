//
//  ZWMineOtherMenuView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineOtherMenuView.h"
#import "ZWMineMenuViewCell.h"
#import "ZWSetVC.h"

@interface ZWMineOtherMenuView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSArray *otherItems;
@end

@implementation ZWMineOtherMenuView
//普通用户菜单
- (NSArray *)otherItems {
    if (!_otherItems) {
        _otherItems = @[
            @{
                @"name":@"设置",
                @"image":@"ren_icon_she",
            }
        ];
    }
    return _otherItems;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_layout];
    }
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZWMineMenuViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    _collectionView.showsVerticalScrollIndicator=YES;
    _collectionView.showsHorizontalScrollIndicator=YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.layer.cornerRadius = 6;
    _collectionView.layer.masksToBounds = YES;
    return _collectionView;
}

- (void)createFlowLayout {
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing= 0;
    [_layout setHeaderReferenceSize:CGSizeMake(kScreenWidth, 0.1*kScreenWidth)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self createFlowLayout];
        [self addSubview:self.collectionView];
    }
    return self;
}
/*UICollectionView*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.otherItems.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * headerV =(UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = headerV;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*self.frame.size.width, 0.02*kScreenWidth, 0.5*self.frame.size.width, 0.08*kScreenWidth)];
        titleLabel.text = @"其他服务";
        titleLabel.font = normalFont;
        [headerV addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth, self.frame.size.width, 1)];
        lineView.backgroundColor = zwGrayColor;
        [headerV addSubview:lineView];
        
    }
    return reusableView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    ZWMineMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.mianImageView.image = [UIImage imageNamed:self.otherItems[indexPath.item][@"image"]];
    cell.titleLabel.text = self.otherItems[indexPath.item][@"name"];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/3, self.frame.size.width/3);
}
//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ZWSetVC *setVC= [[ZWSetVC alloc]init];
        setVC.title = @"设置";
        setVC.hidesBottomBarWhenPushed = YES;
        [self.ff_navViewController pushViewController:setVC animated:YES];
    }
}
#pragma mark - collectionViewCell点击高亮

// 高亮时调用
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = zwGrayColor;
}

// 高亮结束调用
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

// 是否可以高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
