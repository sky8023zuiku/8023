//
//  ZWScanRecommendCoderVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/19.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWScanRecommendCoderVC.h"
#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "UIImage+ZWCustomImage.h"
#import "ZWImageBrowser.h"

@interface ZWScanRecommendCoderVC ()
@property(nonatomic, strong)NSMutableArray *shareArray;
@property(nonatomic, strong)UIImageView *QRimageView;
@property(nonatomic, strong)NSDictionary *QrCodeDic;
@end

@implementation ZWScanRecommendCoderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self createUI];
}

- (void)createNavigationBar {
    [[YNavigationBar sharedInstance]createLeftBarWithImage:[UIImage imageNamed:@"zai_dao_icon_left"] barItem:self.navigationItem target:self action:@selector(goBack:)];
}
- (void)goBack:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.view.backgroundColor = zwGrayColor;
    NSLog(@"----%@",self.userInfo);
        
    self.QrCodeDic = @{
        @"zw_status":@"0",//0为邀请二维码
        @"zw_content":@{
                @"headImages":self.userInfo[@"headImages"],
                @"merchantName":self.userInfo[@"merchantName"],
                @"phone":self.userInfo[@"phone"],
                @"userName":self.userInfo[@"userName"]
        }
    };
                                        
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0.1*kScreenWidth, zwNavBarHeight+0.1*kScreenWidth, 0.8*kScreenWidth, kScreenWidth)];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.layer.cornerRadius = 5;
    toolView.layer.masksToBounds = YES;
    [self.view addSubview:toolView];
    
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    headImage.image = [UIImage imageNamed:@"h1.jpg"];
    headImage.layer.cornerRadius = 0.075*kScreenWidth;
    headImage.layer.masksToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.userInfo[@"headImages"]]] placeholderImage:[UIImage imageNamed:@""]];
    [toolView addSubview:headImage];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.01*kScreenWidth, CGRectGetMinY(headImage.frame)+CGRectGetHeight(headImage.frame)/4, 0.55*kScreenWidth, CGRectGetHeight(headImage.frame)/4)];
    nameLabel.text = self.userInfo[@"userName"];
    nameLabel.font = boldNormalFont;
    [toolView addSubview:nameLabel];

    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.01*kScreenWidth, CGRectGetMaxY(nameLabel.frame)+0.03*kScreenWidth, 0.55*kScreenWidth, CGRectGetHeight(headImage.frame)/4)];
    companyLabel.text = self.userInfo[@"merchantName"];
    companyLabel.font = smallMediumFont;
    companyLabel.textColor = [UIColor lightGrayColor];
    [toolView addSubview:companyLabel];

    self.QRimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, CGRectGetMaxY(headImage.frame)+0.05*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth)];
    self.QRimageView.backgroundColor = [UIColor redColor];
    self.QRimageView.userInteractionEnabled = YES;
    self.QRimageView.image =  [self createQRCodeWithUrl:[self dictionaryToJson:self.QrCodeDic]];
    [toolView addSubview:self.QRimageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    [self.QRimageView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *pressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [self.QRimageView addGestureRecognizer:pressGesture];

    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.QRimageView.frame), CGRectGetMaxY(self.QRimageView.frame), 0.5*kScreenWidth, 0.1*kScreenWidth)];
    scanLabel.text = @"面对面扫码邀请";
    scanLabel.font = normalFont;
    scanLabel.textColor = [UIColor lightGrayColor];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [toolView addSubview:scanLabel];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(scanLabel.frame)+0.02*kScreenWidth, 0.7*kScreenWidth, 0.08*kScreenWidth);
    shareBtn.backgroundColor = skinColor;
    [shareBtn setTitle:@"分享APP" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 0.04*kScreenWidth;
    shareBtn.titleLabel.font = normalFont;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:shareBtn];
    
}

- (void)tapGestureClick:(UIGestureRecognizer *)tap {
    [ZWImageBrowser showImageV_img:self.QRimageView];
}

- (void)shareBtnClick:(UIButton *)btn {
    
    ZWShareModel *model = [[ZWShareModel alloc]init];
    model.shareName = @"app下载";
    model.shareTitleImage = @"http://zhanwang.oss-cn-shanghai.aliyuncs.com/zwmds/2019_09_18_ios/app_store_zhanlogo.jpg";
    model.shareUrl = @"http://www.enet720.com/share/html/share.html";
    model.shareDetail = @"展网";
    [[ZWShareManager shareManager]showShareAlertWithViewController:self withDataModel:model withExtension:@{} withType:0];
}

//生成二维码
- (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size
{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:size];
    return img;
}
//二维码清晰
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture {

    if(gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){

        }];
        __weak typeof (self) weakSelf = self;
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"发送给好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            
            [strongSelf createImageShare];
            
        }];
        UIAlertAction *share = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    UIImageWriteToSavedPhotosAlbum(strongSelf.QRimageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }];
        [alert addAction:cancle];
        [alert addAction:camera];
        [alert addAction:share];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)createImageShare {
    ZWShareModel *model = [[ZWShareModel alloc]init];
    model.shareName = @"";
    model.shareTitleImage = @"";
    model.shareUrl = @"";
    model.shareDetail = @"";
    [[ZWShareManager shareManager]showShareAlertWithViewController:self withDataModel:model withExtension:self.QRimageView.image withType:0];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        [self showOneAlertWithMessage:@"保存到相册失败，请联系客服"];
    }else {
        [self showOneAlertWithMessage:@"成功保存到相册"];
    }
}

- (void)showOneAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self];
}

- (UIImage *)createQRCodeWithUrl:(NSString *)url {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    // 添加logo
    UIImage *centerImg = [UIImage createRoundedRectImage:[self getImageFromUrl:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.QrCodeDic[@"zw_content"][@"headImages"]]] size:CGSizeMake(kScreenWidth, kScreenWidth) radius:0.5*kScreenWidth];
    qrcode = [self drawImage:centerImg inImage:qrcode];
    return qrcode;
}

// 将二维码转成高清的格式
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

// 添加logo
- (UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画 自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    // 注意logo的尺寸不要太大,否则可能无法识别
    CGRect rect = CGRectMake(imageSize.width / 2 - 0.065*kScreenWidth, imageSize.height / 2 - 0.065*kScreenWidth, 0.13*kScreenWidth, 0.13*kScreenWidth);
//    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [newImage drawInRect:rect];
    
    //返回绘制的新图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)getImageFromUrl:(NSString *)url {
    
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    if (result) {
        return result;
    }else {
        return [UIImage imageNamed:@"icon_no_60"];
    }
    
}


@end
