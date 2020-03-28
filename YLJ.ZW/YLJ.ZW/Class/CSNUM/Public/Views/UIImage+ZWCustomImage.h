//
//  UIImage+ZWCustomImage.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/7.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZWCustomImage)
+ (UIImage *)imageWithColor:(UIColor *)color withCornerRadius:(CGFloat)radius forSize:(CGSize)size;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)radius;

@end

NS_ASSUME_NONNULL_END
