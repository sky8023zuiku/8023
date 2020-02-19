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
@end

NS_ASSUME_NONNULL_END
