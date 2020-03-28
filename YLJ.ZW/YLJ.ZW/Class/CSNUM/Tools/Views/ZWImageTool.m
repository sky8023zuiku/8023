//
//  ZWImageTool.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/27.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWImageTool.h"

@implementation ZWImageTool

-(UIImage*)imageWithCornerRadius:(CGFloat)radius{
    CGRect rect = (CGRect){0.f,0.f,self.size};
    // void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
    //size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    //    opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    //    scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    //根据矩形画带圆角的曲线
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    [self drawInRect:rect];
    //图片缩放，是非线程安全的
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
