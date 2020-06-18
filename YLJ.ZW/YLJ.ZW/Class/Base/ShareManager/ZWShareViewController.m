//
//  ZWShareViewController.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareViewController.h"
#import "ZWShareCollectionCell.h"
#import "ZWShareItemModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <Social/Social.h>

#import "ZWCustomActivity.h"

#import "ZWExExhibitorsQrCodeVC.h"

#define CONTENTH  0.25*kScreenWidth
@interface ZWShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UICollectionViewFlowLayout *layout;
@property(nonatomic, strong)NSMutableArray *itemArray;
@property(nonatomic, strong)NSMutableArray *Qrcodes;

@property(nonatomic, strong)UIImage *shareImage;
@property(nonatomic, strong)NSDictionary *shareDic;

@end

@implementation ZWShareViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0.05*kScreenWidth, kScreenWidth, CONTENTH) collectionViewLayout:_layout];
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

- (NSMutableArray *)Qrcodes {
    if (!_Qrcodes) {
        _Qrcodes = [NSMutableArray array];
        NSArray *data = @[@{
                             @"text":@"二维码",
                             @"img":@"QrCode_icon"
                        }];
        for (NSDictionary *mydic in data) {
            ZWShareItemModel *model = [ZWShareItemModel parseJSON:mydic];
            [_Qrcodes addObject:model];
        }
    }
    return _Qrcodes;
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
    
    if ([self.extension isKindOfClass:[UIImage class]]) {
        self.shareImage = self.extension;
    }else {
        self.shareDic = self.extension;
    }
}

- (void)createUI {
    self.view.backgroundColor = zwGrayColor;
    
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.3*kScreenWidth, kScreenWidth, zwTabBarHeight)];
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
    
    NSLog(@"%@",self.Qrcodes[0]);
    
    if (self.type == 1) {
        [self.itemArray insertObject:self.Qrcodes[0] atIndex:0];
    }
    [self.view addSubview:self.collectionView];
    
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
    ZWShareItemModel *model = self.itemArray[indexPath.item];
    static NSString *cellId=@"cellID";
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
    
    if (self.type == 1) {
        switch (indexPath.row) {
            case 0:
                [self letsCreateQrCode];
                break;
            case 1:
                //微信
                [self createShare:SSDKPlatformTypeWechat withData:self.model];
                break;
            case 2:
                //微信朋友圈
                [self createShare:SSDKPlatformSubTypeWechatTimeline withData:self.model];
                break;
            case 3:
                //新浪微博
                [self createShare:SSDKPlatformTypeSinaWeibo withData:self.model];
                break;
            case 4:
                //QQ好友
                [self createShare:SSDKPlatformSubTypeQQFriend withData:self.model];
                break;
            case 5:
                //企业微信
                [self createShare:SSDKPlatformTypeWework withData:self.model];
                break;
            case 6:
                //QQ空间
                [self createShare:SSDKPlatformSubTypeQZone withData:self.model];
                break;
            case 7:
                //系统分享
                [self shareExtensionWithModel:self.model];
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                //微信
                [self createShare:SSDKPlatformTypeWechat withData:self.model];
                break;
            case 1:
                //微信朋友圈
                [self createShare:SSDKPlatformSubTypeWechatTimeline withData:self.model];
                break;
            case 2:
                //新浪微博
                [self createShare:SSDKPlatformTypeSinaWeibo withData:self.model];
                break;
            case 3:
                //QQ好友
                [self createShare:SSDKPlatformSubTypeQQFriend withData:self.model];
                break;
            case 4:
                //企业微信
                [self createWeworkShareWithModel:self.model];
                break;
            case 5:
                //QQ空间
                [self createShare:SSDKPlatformSubTypeQZone withData:self.model];
                break;
            case 6:
                //系统分享
                if ([self.extension isKindOfClass:[UIImage class]]) {
                    [self shareExtensionWithImage:self.extension];
                }else {
                    [self shareExtensionWithModel:self.model];
                }
                break;
            default:
                break;
        }
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
    if (model.shareUrl.length == 0) {
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:self.shareImage
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeAuto];
    }else {
        [shareParams SSDKSetupShareParamsByText:text
                                         images:model.shareTitleImage
                                            url:[NSURL URLWithString:model.shareUrl]
                                          title:model.shareName
                                           type:SSDKContentTypeAuto];
    }
    [self createActionWithType:type withParams:shareParams];
    
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

- (void)shareExtensionWithImage:(UIImage *)image {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWhatsAppParamsByText:nil image:image audio:nil video:nil menuDisplayPoint:CGPointMake(0, 0) type:SSDKContentTypeImage];
    [self createActionWithType:SSDKPlatformTypeWhatsApp withParams:shareParams];
}

- (void)shareExtensionWithModel:(ZWShareModel *)model {
    NSString *shareText = model.shareName;
    UIImage *shareImage = [UIImage imageNamed:@"app_store"];
    NSURL *shareUrl = [NSURL URLWithString:model.shareUrl];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    ZWCustomActivity *customActivity = [[ZWCustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"app_store"] URL:shareUrl ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");
        }
    };
    activityVC.completionWithItemsHandler = itemsBlock;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)createWeworkShareWithModel:(ZWShareModel *)model {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if ([self.extension isKindOfClass:[UIImage class]]) {
        [shareParams SSDKSetupWeWorkParamsByText:@"--" title:@"--" url:nil thumbImage:nil image:self.extension video:nil fileData:self.extension type:SSDKContentTypeImage];
    }else {
        
        NSLog(@"%@",model.shareTitleImage);
        [shareParams SSDKSetupWeWorkParamsByText:model.shareDetail title:model.shareName url:[NSURL URLWithString:model.shareUrl] thumbImage:[NSURL URLWithString:model.shareTitleImage] image:nil video:nil fileData:nil type:SSDKContentTypeAuto];
    }
    [self createActionWithType:SSDKPlatformTypeWework withParams:shareParams];
    
}

- (void)letsCreateQrCode {
    
    ZWExExhibitorsQrCodeVC *QrCodeVC = [[ZWExExhibitorsQrCodeVC alloc]init];
    QrCodeVC.logoImageStr = self.extension[@"coverImages"];
    QrCodeVC.qrDic = [self createQrCodeData];
    [self yc_centerPresentController:QrCodeVC presentedSize:CGSizeMake(0.65*kScreenWidth, 0.65*kScreenWidth) completeHandle:^(BOOL presented) {
    
    }];
    
}

- (NSDictionary *)createQrCodeData {
    
    NSLog(@"%@",self.extension);
    NSDictionary *QrCodeData = @{
         @"zw_status":@"1",//0为邀请二维码
         @"zw_content":self.extension[@"zw_content"]
    };
    return QrCodeData;
}

@end
