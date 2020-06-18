//
//  ZWShareScreenshotsViewController.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/21.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareScreenshotsViewController.h"
#import "ZWShareCollectionCell.h"
#import "ZWShareItemModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZWShareModel.h"

#define CONTENTH  0.25*kScreenWidth
@interface ZWShareScreenshotsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSMutableArray *itemArray;

@property(nonatomic, strong)UIScrollView *scrollView;

@end

@implementation ZWShareScreenshotsViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, kScreenHeight-zwNavBarHeight-zwTabBarHeight-CONTENTH, kScreenWidth, CONTENTH) collectionViewLayout:_layout];
    }
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = zwGrayColor;
    [_collectionView registerClass:[ZWShareCollectionCell class] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.bounces = NO;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    return _collectionView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-zwTabBarHeight-zwNavBarHeight-CONTENTH)];
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    return _scrollView;
}



-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"微信",
                              @"img" : @"weixing",
                          },
                          @{
                              @"text" : @"朋友圈",
                              @"img" : @"friends",
                              
                          },
                          @{
                              @"text" : @"微博",
                              @"img" : @"sina",
                          },
                          @{
                              @"text" : @"QQ",
                              @"img" : @"qq",
                              
                          },
                          @{
                              @"text" : @"企业微信",
                              @"img" : @"wxwork_icon",
                          },
                          @{
                              @"text" : @"QQ空间",
                              @"img" : @"kongjian",
                              
                          },
                          @{
                              @"text" : @"更多",
                              @"img" : @"share_more_icon",
                          }];
        
        for (NSDictionary *mydic in data) {
            ZWShareItemModel *model = [ZWShareItemModel parseJSON:mydic];
            [_itemArray addObject:model];
        }
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-zwTabBarHeight-zwNavBarHeight, kScreenWidth, zwTabBarHeight)];
    cancelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cancelView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, kScreenWidth, 49);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = normalFont;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelBtn];
        
    _layout=[[UICollectionViewFlowLayout alloc]init];
    [_layout prepareLayout];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing=1;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:self.collectionView];
    
    
    UIImageView *screenshots = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    screenshots.image = self.screenshots;
    [self.scrollView addSubview:screenshots];
    [self.view addSubview:self.scrollView];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.collectionView.frame)-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    
}

- (void)cancelBtnClick:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*UICollectionView*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellID";
    ZWShareItemModel *model = self.itemArray[indexPath.item];
    ZWShareCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:model.img];
    cell.backgroundColor = zwGrayColor;
    cell.textLabel.text = model.text;
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/5-1, kScreenWidth/5-1);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZWShareModel *model = [[ZWShareModel alloc]init];
    
        switch (indexPath.row) {
            case 0:
                //微信
                [self createShare:SSDKPlatformTypeWechat withData:model];
                break;
            case 1:
                //微信朋友圈
                [self createShare:SSDKPlatformSubTypeWechatTimeline withData:model];
                break;
            case 2:
                //新浪微博
                [self createShare:SSDKPlatformTypeSinaWeibo withData:model];
                break;
            case 3:
                //QQ好友
                [self createShare:SSDKPlatformSubTypeQQFriend withData:model];
                break;
            case 4:
                //企业微信
                [self createWeworkShare];
                break;
            case 5:
                //QQ空间
                [self createShare:SSDKPlatformSubTypeQZone withData:model];
                break;
            case 6:
                //系统分享
                [self ShareExtension];
                break;
            default:
                break;
        }
}

- (void)createShare:(SSDKPlatformType)type withData:(ZWShareModel *)model {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text;
    if (type == SSDKPlatformTypeSinaWeibo) {
        text = model.shareUrl;
    }else {
        text = model.shareDetail;
    }
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:@[self.screenshots]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeAuto];
    
    [self createActionWithType:type withParams:shareParams];
}


- (void)createWeworkShare {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeWorkParamsByText:@"11" title:@"22" url:nil thumbImage:nil image:self.screenshots video:nil fileData:self.screenshots type:SSDKContentTypeImage];
    [self createActionWithType:SSDKPlatformTypeWework withParams:shareParams];
}

- (void)ShareExtension {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWhatsAppParamsByText:nil image:self.screenshots audio:nil video:nil menuDisplayPoint:CGPointMake(0, 0) type:SSDKContentTypeImage];
    [self createActionWithType:SSDKPlatformTypeWhatsApp withParams:shareParams];
}

- (void)createActionWithType:(SSDKPlatformType)type withParams:(NSMutableDictionary *)shareParams {
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功");
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败=%@",error.userInfo);
                break;
            }
            default:
                break;
        }
    }];
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}


@end
