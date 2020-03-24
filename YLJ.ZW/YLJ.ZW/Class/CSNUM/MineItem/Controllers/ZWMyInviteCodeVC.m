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

@interface ZWMyInviteCodeVC ()
@property(nonatomic, strong)NSMutableArray *shareArray;
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
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, CGRectGetMaxY(headImage.frame)+0.05*kScreenWidth, 0.5*kScreenWidth, 0.5*kScreenWidth)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.image =  [self generateQRCodeWithString:[self dictionaryToJson:self.QrCodeDic] Size:200];
    [self.view addSubview:imageView];
    
    
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.1*kScreenWidth, 0.1*kScreenWidth)];
    [centerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,self.QrCodeDic[@"zw_content"][@"headImages"]]] placeholderImage:[UIImage imageNamed:@""]];
    centerImage.layer.cornerRadius = 0.05*kScreenWidth;
    centerImage.layer.masksToBounds = YES;
    centerImage.center = imageView.center;
    [self.view addSubview:centerImage];
    
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame), 0.5*kScreenWidth, 0.1*kScreenWidth)];
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
                NSLog(@"分享失败");
                break;
            }
            default:
                break;
        }
    }];
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

@end
