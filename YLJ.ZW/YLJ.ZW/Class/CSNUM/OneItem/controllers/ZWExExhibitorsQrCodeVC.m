//
//  ZWExExhibitorsQrCodeVC.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExExhibitorsQrCodeVC.h"
#import "UIImage+ZWCustomImage.h"
#import "ZWImageBrowser.h"

@interface ZWExExhibitorsQrCodeVC ()
@property(nonatomic, strong)UIImageView *QrImageView;
@end

@implementation ZWExExhibitorsQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    self.QrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.025*kScreenWidth, 0.6*kScreenWidth, 0.6*kScreenWidth)];
    self.QrImageView.backgroundColor = [UIColor redColor];
    self.QrImageView.userInteractionEnabled = YES;
    self.QrImageView.image = [self createQRCodeWithUrl:[self dictionaryToJson:self.qrDic]];
    [self.view addSubview:self.QrImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    [self.QrImageView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *pressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [self.QrImageView addGestureRecognizer:pressGesture];
       
}

- (void)tapGestureClick:(UIGestureRecognizer *)tap {
    [ZWImageBrowser showImageV_img:self.QrImageView];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture {

    if(gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){

        }];
        __weak typeof (self) weakSelf = self;
        UIAlertAction *library = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    UIImageWriteToSavedPhotosAlbum(strongSelf.QrImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }];
        [alert addAction:cancle];
        [alert addAction:library];
        [self presentViewController:alert animated:YES completion:nil];
    }
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


- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:250];
    // 添加logo
    UIImage *centerImg = [UIImage createRoundedRectImage:[self getImageFromUrl:self.logoImageStr] size:CGSizeMake(kScreenWidth, kScreenWidth) radius:0];
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
