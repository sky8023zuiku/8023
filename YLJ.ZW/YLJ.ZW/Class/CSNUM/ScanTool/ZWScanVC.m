//
//  ZWScanVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWScanVC.h"
#import "LBXScanVideoZoomView.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "ZWScanErrorVC.h"
#import "ZWScanResultVC.h"
#import "ZWScanRecommendCoderVC.h"

#import "UIViewController+YCPopover.h"

#import "ZWMainTabBarController.h"
#import "ZWMainLoginVC.h"

#import "ZWExExhibitorsDetailsVC.h"
#import "ZWExExhibitorsModel.h"

@interface ZWScanVC ()

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@property (nonatomic, strong) UIButton *popBtn;

@end

@implementation ZWScanVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
    self.title = @"扫一扫";
    [self createNavigationBar];
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(20, zwStatusBarHeight+3.5, 35, 35);
    [popBtn setBackgroundImage:[UIImage imageNamed:@"zai_zxiang_icon_chanx"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.popBtn = popBtn;
    [self.view addSubview:self.popBtn];
    
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    toolView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:toolView];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight-180, kScreenWidth, 50)];
    noticeLabel.text = @"扫描二维码";
    noticeLabel.font = normalFont;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor grayColor];
    [self.view addSubview:noticeLabel];

}
- (void)backBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(backBtn:)];
}
- (void)backBtn:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createScan];
}

- (void)createScan {
   [self drawBottomItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
    [self.view bringSubviewToFront:_popBtn];
    [[YNavigationBar sharedInstance]createNavigationBarWithStatusBarStyle:UIStatusBarStyleLightContent withType:0];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, zwNavBarHeight-zwStatusBarHeight);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, (zwNavBarHeight+zwStatusBarHeight)/2);
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"扫一扫";
        _topTitle.font = bigFont;
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
        CGRect frame = self.view.frame;

        int XRetangleLeft = self.style.xScanRetangleOffset;

        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
//        CGSize sizeRetangle = CGSizeMake(frame.size.width, frame.size.height);

        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;

            NSInteger hInt = (NSInteger)h;
            h  = hInt;

            sizeRetangle = CGSizeMake(w, h);
        }

        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value) {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }

    return _zoomView;

}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-100,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = CGRectMake(0, 0, 50, 50);
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setBackgroundImage:[UIImage imageNamed:@"scan_photo"] forState:UIControlStateNormal];
    [_btnPhoto setBackgroundImage:[UIImage imageNamed:@"scan_photo"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];

    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnPhoto.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setBackgroundImage:[UIImage imageNamed:@"scan_code"] forState:UIControlStateNormal];
    [_btnMyQR setBackgroundImage:[UIImage imageNamed:@"scan_code"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
//    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnMyQR];
    
}

- (void)showError:(NSString*)str
{
//    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        NSLog(@"scanResult:%@",result.strScanned);
        
        NSDictionary *myDic = [self dictionaryWithJsonString:result.strScanned];
        if ([myDic[@"zw_status"] isEqualToString:@"0"]) {
            ZWScanResultVC *resultVC = [[ZWScanResultVC alloc]init];
            resultVC.QrCodeStr = result.strScanned;
            [self.navigationController pushViewController:resultVC animated:YES];
        }else if ([myDic[@"zw_status"] isEqualToString:@"1"]) {
            [self gotoExExhibitorDetailsWithData:myDic[@"zw_content"]];
        }else {
            ZWScanErrorVC *errorVC = [[ZWScanErrorVC alloc]init];
            errorVC.QrCodeStr = result.strScanned;
            [self.navigationController pushViewController:errorVC animated:YES];
        }

    }
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    //震动提醒
//    [LBXScanWrapper systemVibrate];
    //声音提醒
//    [LBXScanWrapper systemSound];
    
//    [self getChatMessageGoToSound];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)gotoExExhibitorDetailsWithData:(NSDictionary *)data {
    //进入展会展商详情
    NSDictionary *userInfo = [[ZWSaveDataAction shareAction]takeUserInfoData];
    NSLog(@"--------%@",userInfo);
    if (userInfo) {
        ZWExExhibitorsModel *model = [ZWExExhibitorsModel alloc];
        model.exhibitionId = data[@"exhibitionId"];
        model.exhibitorId = data[@"exhibitorId"];
        model.merchantId = data[@"merchantId"];
        model.coverImages = data[@"coverImages"];
        ZWExExhibitorsDetailsVC *detailsVC = [[ZWExExhibitorsDetailsVC alloc]init];
        detailsVC.title = @"展商详情";
        detailsVC.shareModel = model;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"温馨提示" message:@"是否允许对方获取您的信息？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf bindUserInfoWithModel:model withUserId:userInfo[@"userId"]];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:self];
        
    } else {
        [self gotoLogin];
    }
}

- (void)bindUserInfoWithModel:(ZWExExhibitorsModel *)model withUserId:(NSString *)userId {
    if (userId) {
        NSDictionary *myParametes = @{
            @"exhibitionId":model.exhibitionId,
            @"merchantId":model.merchantId,
            @"userId":userId
        };
        if (myParametes) {
            [[ZWDataAction sharedAction]postReqeustWithURL:zwShareExhibitorDetailBind parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
                if (zw_issuccess) {
                    NSLog(@"用户绑定成功");
                } else {
                    NSLog(@"用户绑定失败");
                }
            } failureBlock:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}


- (void)getChatMessageGoToSound
{
    //调用系统声音
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"low_power",@"caf"];
    if (path) {
        SystemSoundID sd;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sd);
        //获取声音的时候出现错误
        if (error != kAudioServicesNoError) {
            NSLog(@"----调用系统声音出错----");
            sd = 0;
        }
        AudioServicesPlaySystemSound(sd);
    }
}



- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        strResult = @"识别失败";
    }
//    __weak __typeof(self) weakSelf = self;
//    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
//
//        [weakSelf reStartDevice];
//    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
//    ScanResultViewController *vc = [ScanResultViewController new];
//    vc.imgScan = strResult.imgScanned;
//    vc.strScan = strResult.strScanned;
//    vc.strCodeType = strResult.strBarCodeType;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
   
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode {

    NSDictionary *userInfo = [[ZWSaveDataAction shareAction]takeUserInfoData];
    if (userInfo) {
        ZWScanRecommendCoderVC *VC = [[ZWScanRecommendCoderVC alloc]init];
        VC.title = @"邀请码";
        VC.userInfo = userInfo;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        [self gotoLogin];
    }
    
}

- (void)gotoLogin {
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"您还未登陆展网，是否前去登陆" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ZWMainLoginVC alloc] init]];
        [strongSelf yc_bottomPresentController:nav presentedHeight:kScreenHeight completeHandle:^(BOOL presented) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (presented) {
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
            }else {
                [strongSelf createScan];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTheStatusBarColor" object:nil];
            }
        }];
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self];
}



- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

@end
