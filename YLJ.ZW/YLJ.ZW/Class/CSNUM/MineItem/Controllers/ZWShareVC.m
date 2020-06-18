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
    
    ZWShareModel *model = [[ZWShareModel alloc]init];
    model.shareName = @"app下载";
    model.shareTitleImage = @"http://zhanwang.oss-cn-shanghai.aliyuncs.com/zwmds/2019_09_18_ios/app_store_zhanlogo.jpg";
    model.shareUrl = @"http://www.enet720.com/share/html/share.html";
    model.shareDetail = @"展网";
    [[ZWShareManager shareManager]showShareAlertWithViewController:self withDataModel:model withExtension:@{} withType:0];

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
