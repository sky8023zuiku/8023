//
//  ZWMineMenuView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineMenuView.h"
#import "ZWMineMenuViewCell.h"

#import "ZWMyOrderVC.h"
#import "ZWMyCollectionVC.h"
#import "ZWMyIndustriesVC.h"
#import "ZWMyInvitationVC.h"
#import "ZWMyBusinessCardListVC.h"
#import "ZWSelectCertificationVC.h"
#import "ZWMyReleaseVC.h"
#import "ZWMyShareVC.h"
#import "ZWChildUserManagerVC.h"
#import "ZWMineSpellListVC.h"


@interface ZWMineMenuView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSArray *ordiArray;//普通用户显示菜单
@property(nonatomic, strong)NSArray *exhibitorArray;//展商显示菜单
@property(nonatomic, strong)NSArray *serviceArray;//会展服务商显示菜单
@property(nonatomic, assign)NSInteger roleId;//身份id
@end

@implementation ZWMineMenuView
//普通用户菜单
- (NSArray *)ordiArray {
    if (!_ordiArray) {
        _ordiArray = @[
            @{
                @"name":@"企业入驻",
                @"image":@"mine_enterprises_icon",
            },
            @{
                @"name":@"我的拼单",
                @"image":@"my_spell_list_icon",
            },
            @{
                @"name":@"我的名片",
                @"image":@"My_business_card_icon",
            },
            @{
                @"name":@"我的订单",
                @"image":@"ren_icon_dingdan",
            },
            @{
                @"name":@"我的收藏",
                @"image":@"ren_icon_shouc",
            },
            @{
                @"name":@"我的行业",
                @"image":@"my_industries_icon",
            },
            @{
                @"name":@"我的邀请",
                @"image":@"my_invitation_icon",
            },
        ];
    }
    return _ordiArray;
}

- (NSArray *)exhibitorArray {
    if (!_exhibitorArray) {
        _exhibitorArray = @[
            @{
                @"name":@"企业入驻",
                @"image":@"mine_enterprises_icon",
            },
            @{
                @"name":@"我的拼单",
                @"image":@"my_spell_list_icon",
            },
            @{
                @"name":@"我的名片",
                @"image":@"My_business_card_icon",
            },
            @{
                @"name":@"我的订单",
                @"image":@"ren_icon_dingdan",
            },
            @{
                @"name":@"我的收藏",
                @"image":@"ren_icon_shouc",
            },
            @{
                @"name":@"我的发布",
                @"image":@"ren_icon_fabu",
            },
            @{
                @"name":@"我的行业",
                @"image":@"my_industries_icon",
            },
            @{
                @"name":@"我的分享",
                @"image":@"my_share_icon",
            },
            @{
                @"name":@"我的邀请",
                @"image":@"my_invitation_icon",
            },
            @{
                @"name":@"子用户管理",
                @"image":@"child_users_icon",
            },
        ];
    }
    return _exhibitorArray;
}


- (NSArray *)serviceArray {
    if (!_serviceArray) {
        _serviceArray = @[
            @{
                @"name":@"企业入驻",
                @"image":@"mine_enterprises_icon",
            },
            @{
                @"name":@"我的拼单",
                @"image":@"my_spell_list_icon",
            },
            @{
                @"name":@"我的名片",
                @"image":@"My_business_card_icon",
            },
            @{
                @"name":@"我的订单",
                @"image":@"ren_icon_dingdan",
            },
            @{
                @"name":@"我的收藏",
                @"image":@"ren_icon_shouc",
            },
            @{
                @"name":@"我的行业",
                @"image":@"my_industries_icon",
            },
            @{
                @"name":@"我的邀请",
                @"image":@"my_invitation_icon",
            },
            @{
                @"name":@"子用户管理",
                @"image":@"child_users_icon",
            },
        ];
    }
    return _serviceArray;
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
        
        NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
        self.roleId = [myDic[@"roleId"] intValue];
        
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
    
    
    if(self.roleId ==2||self.roleId==3 ||self.roleId ==4) {
        return self.exhibitorArray.count;
    }else if (self.roleId==5||self.roleId ==6||self.roleId ==7) {
        return self.serviceArray.count;
    }else {
        return self.ordiArray.count;
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * headerV =(UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = headerV;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*self.frame.size.width, 0.02*kScreenWidth, 0.5*self.frame.size.width, 0.08*kScreenWidth)];
        titleLabel.text = @"平台服务";
        titleLabel.font = normalFont;
        [headerV addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.1*kScreenWidth, self.frame.size.width, 1)];
        lineView.backgroundColor = zwGrayColor;
        [headerV addSubview:lineView];
        
    }
    return reusableView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *valuse;
    if(self.roleId ==2||self.roleId==3 ||self.roleId ==4) {
        valuse = self.exhibitorArray;
    }else if (self.roleId==5||self.roleId ==6||self.roleId ==7) {
        valuse = self.serviceArray;
    }else {
        valuse = self.ordiArray;
    }
    static NSString *cellId=@"cellID";
    ZWMineMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.mianImageView.image = [UIImage imageNamed:valuse[indexPath.item][@"image"]];
    cell.titleLabel.text = valuse[indexPath.item][@"name"];
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
    
    
    if(self.roleId ==2||self.roleId==3 ||self.roleId ==4) {
        [self gotoExhibitorItem:indexPath];
    }else if (self.roleId==5||self.roleId ==6||self.roleId ==7) {
        [self gotoServiceItem:indexPath];
    }else {
        [self gotoAverageUserItem:indexPath];
    }
}
- (void)gotoExhibitorItem:(NSIndexPath *)indexPath {
    NSDictionary *myDic = [[ZWSaveDataAction shareAction]takeUserInfoData];
    if (indexPath.item == 0) {
        [self zwGoToEnterprisesVC];
    }else if (indexPath.item == 1) {
        [self gotoSpellSistVC];
    }else if (indexPath.item == 2) {
        [self zwGoToBusinessCardListVC];
    }else if (indexPath.item == 3) {
        [self gotoMyOrderVC];
    }else if (indexPath.item == 4) {
        [self gotoMyCollectionVC];
    }else if (indexPath.item == 5) {
        ZWMyReleaseVC *ReleaseVC = [[ZWMyReleaseVC alloc]init];
        ReleaseVC.title = @"我的发布";
        ReleaseVC.hidesBottomBarWhenPushed = YES;
        [self.ff_navViewController pushViewController:ReleaseVC animated:YES];
    }else if (indexPath.item == 6) {
        [self gotoMyIndustriesVC];
    }else if (indexPath.item == 7) {
        ZWMyShareVC *shareVC = [[ZWMyShareVC alloc]init];
        shareVC.title = @"我的分享";
        shareVC.userId = myDic[@"userId"];
        shareVC.hidesBottomBarWhenPushed = YES;
        [self.ff_navViewController pushViewController:shareVC animated:YES];
    }else if (indexPath.item == 8) {
        [self gotoMyInvitationVC];
    }else {
        [self gotoSubuserManagerVC];
    }
}
- (void)gotoServiceItem:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        [self zwGoToEnterprisesVC];
    }else if (indexPath.item == 1) {
        [self gotoSpellSistVC];
    }else if (indexPath.item == 2) {
        [self zwGoToBusinessCardListVC];
    }else if (indexPath.item == 3) {
        [self gotoMyOrderVC];
    }else if (indexPath.item == 4) {
        [self gotoMyCollectionVC];
    }else if (indexPath.item == 5) {
        [self gotoMyIndustriesVC];
    }else if (indexPath.item == 5) {
        [self gotoMyInvitationVC];
    }else {
        [self gotoSubuserManagerVC];
    }
}
- (void)gotoAverageUserItem:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        [self zwGoToEnterprisesVC];
    }else if (indexPath.item == 1) {
        [self gotoSpellSistVC];
    }else if (indexPath.item == 2) {
        [self zwGoToBusinessCardListVC];
    }else if (indexPath.item == 3) {
        [self gotoMyOrderVC];
    }else if (indexPath.item == 4) {
        [self gotoMyCollectionVC];
    }else if (indexPath.item == 5) {
        [self gotoMyIndustriesVC];
    }else {
        [self gotoMyInvitationVC];
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

- (void)gotoMyOrderVC {
    ZWMyOrderVC *myOrderVC = [[ZWMyOrderVC alloc]init];
    myOrderVC.title = @"我的订单";
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:myOrderVC animated:YES];
}
- (void)gotoMyCollectionVC {
    ZWMyCollectionVC *collectionVC = [[ZWMyCollectionVC alloc]init];
    collectionVC.title = @"我的收藏";
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:collectionVC animated:YES];
}
- (void)gotoMyIndustriesVC {
    __weak typeof (self) weakSelf = self;
       [[ZWDataAction sharedAction]getReqeustWithURL:zwTakeUserInfo parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
           __strong typeof (weakSelf) strongSelf = weakSelf;
           if (zw_issuccess) {
               NSDictionary *myDic = data[@"data"];
               if (myDic) {
                   [[ZWSaveDataAction shareAction]saveUserInfoData:myDic];
                   ZWMyIndustriesVC *industriesVC = [[ZWMyIndustriesVC alloc]init];
                   industriesVC.title = @"我的行业";
                   industriesVC.hidesBottomBarWhenPushed = YES;
                   industriesVC.roleId = (NSNumber *)myDic[@"roleId"];
                   [strongSelf.ff_navViewController pushViewController:industriesVC animated:YES];
               }
           }else {
//               [strongSelf showAlretWithMessage:@"获取身份失败，请稍后再试或联系客服"];
           }
       } failureBlock:^(NSError * _Nonnull error) {
           
       } showInView:self];
}

- (void)gotoMyInvitationVC {
    ZWMyInvitationVC *invitationVC = [[ZWMyInvitationVC alloc]init];
    invitationVC.title = @"我的邀请";
    invitationVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:invitationVC animated:YES];
}

- (void)zwGoToBusinessCardListVC {
    ZWMyBusinessCardListVC *cardListVC = [[ZWMyBusinessCardListVC alloc]init];
    cardListVC.title = @"我的名片";
    cardListVC.type = 1;
    cardListVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:cardListVC animated:YES];
}
//企业入驻
- (void)zwGoToEnterprisesVC {
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]getReqeustWithURL:zwCompanyCertification parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            NSDictionary *myData = data[@"data"];
            ZWSelectCertificationVC *selectVC = [[ZWSelectCertificationVC alloc]init];
            selectVC.title = @"选择企业类型";
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.authenticationStatus = [myData[@"authenticationStatus"] integerValue];
            selectVC.identityId = [myData[@"identityId"] integerValue];
            [strongSelf.ff_navViewController pushViewController:selectVC animated:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:self];
}

- (void)gotoSubuserManagerVC {
    ZWChildUserManagerVC *userManagerVC = [[ZWChildUserManagerVC alloc]init];
    userManagerVC.title = @"子用户管理";
    userManagerVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:userManagerVC animated:YES];
}

- (void)gotoSpellSistVC {
    ZWMineSpellListVC *spellListVC = [[ZWMineSpellListVC alloc]init];
    spellListVC.title = @"我的拼单";
    spellListVC.hidesBottomBarWhenPushed = YES;
    [self.ff_navViewController pushViewController:spellListVC animated:YES];
}

@end
