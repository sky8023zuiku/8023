//
//  UIImage+ZWCustomImage.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/7.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "UIImage+ZWCustomImage.h"

@implementation UIImage (ZWCustomImage)

+ (UIImage *)imageWithColor:(UIColor *)color withCornerRadius:(CGFloat)radius forSize:(CGSize)size {
    return [[self alloc]imageWithColor:color withCornerRadius:radius forSize:size];
}
- (UIImage*)imageWithColor:(UIColor *)color withCornerRadius:(CGFloat)radius forSize:(CGSize)size
{
    if (size.width <= 0 || size.height<= 0 )
    {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO,rect.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
