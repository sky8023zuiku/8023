//
//  ZWShareVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWShareVC.h"
#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZWImageBrowser.h"
@interface ZWShareVC ()
@property(nonatomic, strong)NSMutableArray *shareArray;
@property(nonatomic, strong)UIImageView *QrCode;
@end

@implementation ZWShareVC
-(NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray new];
        
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
                              @"text" : @"QQ空间",
                              @"img" : @"kongjian",
                              }];
        
        for (NSDictionary *mydic in data) {
            JhPageItemModel *model = [JhPageItemModel parseJSON:mydic];
            [self.shareArray addObject:model];
        }
    }
    return _shareArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigationBar];
}
- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
    [[YNavigationBar sharedInstance]createRightBarWithImage:[UIImage imageNamed:@"fenxiang_icon"] barItem:self.navigationItem target:self action:@selector(sharedItemClick:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sharedItemClick:(UIBarButtonItem *)item {
    [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
        NSLog(@" 点击分享 index %ld ",(long)index);
        switch (index) {
            case 0:
                [self createShare:SSDKPlatformTypeWechat];
                break;
            case 1:
                [self createShare:SSDKPlatformSubTypeWechatTimeline];
                break;
            case 2:
                [self createShare:SSDKPlatformTypeSinaWeibo];
                break;
            case 3:
                [self createShare:SSDKPlatformSubTypeQQFriend];
                break;
            case 4:
                [self createShare:SSDKPlatformSubTypeQZone];
                break;
            default:
                break;
        }
        
    }];
}
- (void)createShare:(SSDKPlatformType)type {
        
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text;
    if (type == SSDKPlatformTypeSinaWeibo) {
        text = @"http://www.enet720.com/share/html/share.html";
    }else {
        text = @"app下载";
    }
    [shareParams SSDKSetupShareParamsByText:text
                                     images:[UIImage imageNamed:@"app_store"]
                                        url:[NSURL URLWithString:@"http://www.enet720.com/share/html/share.html"]
                                      title:@"展网"
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功");
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败");
                break;
            }
            default:
                break;
        }
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *toolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    toolView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:toolView];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.35*kScreenWidth, 0.1*kScreenWidth, 0.3*kScreenWidth, 0.2*kScreenWidth)];
    logoImage.image = [UIImage imageNamed:@"logo"];
    [toolView addSubview:logoImage];
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, CGRectGetMaxY(logoImage.frame)+0.1*kScreenWidth, 0.7*kScreenWidth, 0.85*kScreenWidth)];
    shareView.layer.shadowColor = [UIColor blackColor].CGColor;
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.layer.shadowRadius = 5;
    shareView.layer.shadowOffset = CGSizeMake(0,0);
    shareView.layer.shadowOpacity = 0.1;
    shareView.layer.cornerRadius = 5;
    [toolView addSubview:shareView];
    
    self.QrCode = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, CGRectGetWidth(shareView.frame)-30, CGRectGetWidth(shareView.frame)-30)];
    self.QrCode.image = [UIImage imageNamed:@"share_image_qrcode"];
    self.QrCode.userInteractionEnabled = YES;
    [shareView addSubview:self.QrCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.QrCode addGestureRecognizer:tap];
    
    
    UILabel *oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.QrCode.frame)+10, CGRectGetWidth(shareView.frame), 20)];
    oneLabel.text = @"扫一扫 分享给好友";
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:oneLabel];
        
    
    UILabel *compayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight-40-zwNavBarHeight, kScreenWidth, 20)];
    compayLabel.text = @"上海展网网络科技有限公司竭诚为您服务";
    compayLabel.textAlignment = NSTextAlignmentCenter;
    compayLabel.font = normalFont;
    compayLabel.textColor = [UIColor grayColor];
    [toolView addSubview:compayLabel];
    
    
}
- (void)tapClick:(UIGestureRecognizer *)recognizer {
    [ZWImageBrowser showImageV_img:self.QrCode];
}

@end
