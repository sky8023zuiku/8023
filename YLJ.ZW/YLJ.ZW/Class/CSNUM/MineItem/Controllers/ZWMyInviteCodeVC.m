//
//  ZWMyInviteCodeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInviteCodeVC.h"
#import <CoreImage/CoreImage.h>

#import "JhScrollActionSheetView.h"
#import "JhPageItemModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "UIImage+ZWCustomImage.h"

#import "ZWImageBrowser.h"

@interface ZWMyInviteCodeVC ()
@property(nonatomic, strong)NSMutableArray *shareArray;
@property(nonatomic, strong)UIImageView *QRimageView;
@end

@implementation ZWMyInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI {
    
    NSLog(@"%@",self.QrCodeDic);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*kScreenWidth, 0.05*kScreenWidth, 0.15*kScreenWidth, 0.15*kScreenWidth)];
    headImage.image = [UIImage imageNamed:@"h1.jpg"];
    headImage.layer.cornerRadius = 0.075*kScreenWidth;
    headImage.layer.masksToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.QrCodeDic[@"zw_content"][@"headImages"]]] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.01*kScreenWidth, CGRectGetMinY(headImage.frame)+CGRectGetHeight(headImage.frame)/4, 0.55*kScreenWidth, CGRectGetHeight(headImage.frame)/4)];
    nameLabel.text = self.QrCodeDic[@"zw_content"][@"userName"];
    nameLabel.font = boldNormalFont;
    [self.view addSubview:nameLabel];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+0.01*kScreenWidth, CGRectGetMaxY(nameLabel.frame)+0.03*kScreenWidth, 0.55*kScreenWidth, CGRectGetHeight(headImage.frame)/4)];
    companyLabel.text = self.QrCodeDic[@"zw_content"][@"merchantName"];
    companyLabel.font = smallMediumFont;
    companyLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:companyLabel];
    

    self.QRimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, CGRectGetMaxY(headImage.frame)+0.05*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth)];
    self.QRimageView.backgroundColor = [UIColor redColor];
    self.QRimageView.userInteractionEnabled = YES;
    self.QRimageView.image =  [self createQRCodeWithUrl:[self dictionaryToJson:self.QrCodeDic]];
    [self.view addSubview:self.QRimageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    [self.QRimageView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *pressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [self.QRimageView addGestureRecognizer:pressGesture];

    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.QRimageView.frame), CGRectGetMaxY(self.QRimageView.frame), 0.5*kScreenWidth, 0.1*kScreenWidth)];
    scanLabel.text = @"面对面扫码邀请";
    scanLabel.font = normalFont;
    scanLabel.textColor = [UIColor lightGrayColor];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scanLabel];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0.05*kScreenWidth, CGRectGetMaxY(scanLabel.frame)+0.02*kScreenWidth, 0.7*kScreenWidth, 0.08*kScreenWidth);
    shareBtn.backgroundColor = skinColor;
    [shareBtn setTitle:@"分享APP" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 0.04*kScreenWidth;
    shareBtn.titleLabel.font = normalFont;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
}

- (void)tapGestureClick:(UIGestureRecognizer *)tap {
    [ZWImageBrowser showImageV_img:self.QRimageView];
}



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

- (void)shareBtnClick:(UIButton *)btn {
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
                NSLog(@"分享失败%@",error.userInfo);
                break;
            }
            default:
                break;
        }
    }];
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
            
            [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                NSLog(@" 点击分享 index %ld ",(long)index);
                switch (index) {
                    case 0:
                        [strongSelf createImageShare:SSDKPlatformTypeWechat];
                        break;
                    case 1:
                        [strongSelf createImageShare:SSDKPlatformSubTypeWechatTimeline];
                        break;
                    case 2:
                        [strongSelf createImageShare:SSDKPlatformTypeSinaWeibo];
                        break;
                    case 3:
                        [strongSelf createImageShare:SSDKPlatformSubTypeQQFriend];
                        break;
                    case 4:
                        [strongSelf createImageShare:SSDKPlatformSubTypeQZone];
                        break;
                    default:
                        break;
                }
                
            }];
            
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

- (void)createImageShare:(SSDKPlatformType)type {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil images:self.QRimageView.image url:nil title:nil type:SSDKContentTypeImage];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功");
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败%@",error.userInfo);
                break;
            }
            default:
                break;
        }
    }];
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
