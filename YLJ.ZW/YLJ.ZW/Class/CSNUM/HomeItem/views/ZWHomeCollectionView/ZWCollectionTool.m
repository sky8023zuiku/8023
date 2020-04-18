//
//  ZWCollectionTool.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWCollectionTool.h"
#import "ZWHotExhibitionsCollectionViewCell.h"
#import "ZWMineResponse.h"
#import "ZWExhibitionNaviVC.h"
#import "UIViewController+YCPopover.h"
#import "ZWMainLoginVC.h"

@interface ZWCollectionTool()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZWHotExhibitionsCollectionViewCellDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation ZWCollectionTool
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZWHotExhibitionsCollectionViewCell class] forCellWithReuseIdentifier:@"ZWHotExhibitionsCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame withData:(id)data {
    if (self == [super initWithFrame:frame]) {
        NSArray *dataArr = data;
        if (dataArr.count <=4) {
            self.dataArray = data;
        }else {
            self.dataArray = [(NSArray *)data subarrayWithRange:NSMakeRange(0, 4)];
        }
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0.0235*kScreenWidth;
        _layout.minimumInteritemSpacing = 0.02*kScreenWidth;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWExhibitionListModel *model = self.dataArray[indexPath.item];
    ZWHotExhibitionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWHotExhibitionsCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    cell.collectionBtn.tag = indexPath.item;
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 0.02*kScreenWidth;
    cell.layer.masksToBounds = YES;
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake((0.95*kScreenWidth-0.0235*kScreenWidth)/2, (0.95*kScreenWidth-0.0235*kScreenWidth)/2+0.15*kScreenWidth);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self goToLogin] != YES) {
        ZWExhibitionListModel *model = self.dataArray[indexPath.row];
        NSDictionary *shareData = @{
            @"exhibitionId":model.listId,
            @"exhibitionName":model.name,
            @"exhibitionTitleImage":model.imageUrl
        };
        ZWExhibitionNaviVC *naviVC = [[ZWExhibitionNaviVC alloc]init];
        naviVC.hidesBottomBarWhenPushed = YES;
        naviVC.title = @"展会导航";
        naviVC.exhibitionId = model.listId;
        naviVC.price = model.price;
        naviVC.shareData = shareData;
        [self.ff_navViewController pushViewController:naviVC animated:YES];
    }
    
}

-(void)collectionItemWithIndex:(ZWHotExhibitionsCollectionViewCell *)cell withIndex:(NSInteger)index {
    
    if ([self goToLogin] != YES) {
        ZWExhibitionListModel *model = self.dataArray[index];
        NSDictionary *parametes;
        if (model.listId) {
            parametes = @{@"exhibitionId":model.listId};
        }
        [[ZWDataAction sharedAction]getReqeustWithURL:zwCollectionAndCancelExhibition parametes:parametes successBlock:^(NSDictionary * _Nonnull data) {
            if (zw_issuccess) {
                ZWHotExhibitionsCollectionViewCell *myCell = cell;
                if ([cell.collectionBtnBackImageName isEqualToString:@"zhanlist_icon_xin_wei"]) {
                    myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
                }else {
                    myCell.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
                }
                [myCell.collectionBtn setBackgroundImage:[UIImage imageNamed:myCell.collectionBtnBackImageName] forState:UIControlStateNormal];
            }else {

            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self];
    }
    
}


- (BOOL)goToLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([user.uuid isEqualToString:@""]||!user.uuid) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
        [self.ff_navViewController yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
            if (presented) {
                [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
            }else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTheStatusBarColor" object:nil];
            }
        }];
        return YES;
    }else {
        return NO;
    }
}


@end
