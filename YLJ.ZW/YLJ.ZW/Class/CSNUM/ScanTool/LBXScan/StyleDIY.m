//
//  DemoListViewModel.m
//  LBXScanDemo
//
//  Created by lbxia on 2017/4/1.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "StyleDIY.h"

#import <AVFoundation/AVFoundation.h>

#import "UIImage+ColorGradient.h"

#define navLeftColor [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1]
#define navRightColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]

@implementation StyleDIY

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)InnerStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    
    return style;
}

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)weixinStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_Scan_weixin_Line"];
    style.animationImage = imgLine;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    
    return style;
}

#pragma mark -框内区域识别
+ (LBXScanViewStyle*)recoCropRect
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 80;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    
    return style;
}

#pragma mark -4个角在矩形框线上,网格动画
+ (LBXScanViewStyle*)OnStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    style.animationImage = imgPartNet;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    
    return style;
}

#pragma mark -自定义4个角及矩形框颜色
+ (LBXScanViewStyle*)customStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
//    style.whRatio = kScreenWidth/(kScreenHeight-zwNavBarHeight-100);
    style.whRatio = kScreenWidth/kScreenWidth;
//    style.centerUpOffset = (100-zwNavBarHeight)/2;
    
    style.centerUpOffset = 0.5*kScreenHeight-zwNavBarHeight-0.75*kScreenWidth;
    style.xScanRetangleOffset = 0;
    //扫码框周围4个角的类型设置为在框的上面
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制线宽度
    style.photoframeLineW = 3;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //显示矩形框
    style.isNeedShowRetangle = NO;
    //动画类型：网格形式，模仿支付宝
//    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
//    style.animationImage = [UIImage gradientColorImageFromColors:@[navLeftColor,navRightColor] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(0.7*kScreenWidth, 0.1*kScreenWidth)];
    //码框周围4个角的颜色
    style.colorAngle = [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:0];
    //矩形框颜色
    style.colorRetangleLine = [UIColor whiteColor];
    //非矩形框区域颜色
    style.notRecoginitonArea = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    
    return style;
}

#pragma mark -改变扫码区域位置
+ (LBXScanViewStyle*)changeSize
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形框向上移动
    style.centerUpOffset = 60;
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 0;

    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;

    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

    
    return style;
}

#pragma mark -非正方形，可以用在扫码条形码界面

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (LBXScanViewStyle*)notSquare
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 4;
    style.photoframeAngleW = 28;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    style.animationImage = [[self class] createImageWithColor:[UIColor redColor]];
    //非正方形
    //设置矩形宽高比
    style.whRatio = 4.3/2.18;
    //离左边和右边距离
    style.xScanRetangleOffset = 30;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    
    return style;
}


+ (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat
{
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    
    
    return strAVMetadataObjectType;
}



@end
