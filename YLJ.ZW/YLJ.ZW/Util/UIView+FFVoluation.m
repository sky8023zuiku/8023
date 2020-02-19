//
//  UIView+FFVoluation.m
//  Funmily
//
//  Created by zhangyong on 16/8/17.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import "UIView+FFVoluation.h"
#import <objc/runtime.h>

@implementation UIView (FFVoluation)

#pragma mark - view frame
- (void)setFf_x:(CGFloat)ff_x {
    CGRect frame = self.frame;
    frame.origin.x = ff_x;
    self.frame = frame;
}

- (CGFloat)ff_x {
    return self.frame.origin.x;
}

- (void)setFf_right:(CGFloat)ff_right {
    CGRect frame = self.frame;
    frame.origin.x = ff_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ff_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFf_y:(CGFloat)ff_y {
    CGRect frame = self.frame;
    frame.origin.y = ff_y;
    self.frame = frame;
}

- (CGFloat)ff_y {
    return self.frame.origin.y;
}

- (void)setFf_bottom:(CGFloat)ff_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ff_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ff_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFf_centerX:(CGFloat)ff_centerX {
    CGPoint center = self.center;
    center.x = ff_centerX;
    self.center = center;
}

- (CGFloat)ff_centerX {
    return self.center.x;
}

- (void)setFf_centerY:(CGFloat)ff_centerY {
    CGPoint center = self.center;
    center.y = ff_centerY;
    self.center = center;
}

- (CGFloat)ff_centerY {
    return self.center.y;
}

- (void)setFf_width:(CGFloat)ff_width {
    CGRect frame = self.frame;
    frame.size.width = ff_width;
    self.frame = frame;
}

- (CGFloat)ff_width {
    return self.frame.size.width;
}

- (void)setFf_height:(CGFloat)ff_height {
    CGRect frame = self.frame;
    frame.size.height = ff_height;
    self.frame = frame;
}

- (CGFloat)ff_height {
    return self.frame.size.height;
}

- (void)setFf_size:(CGSize)ff_size {
    CGRect frame = self.frame;
    frame.size = ff_size;
    self.frame = frame;
}

- (CGSize)ff_size {
    return self.frame.size;
}

- (void)setFf_orgin:(CGPoint)ff_orgin {
    CGRect frame = self.frame;
    frame.origin = ff_orgin;
    self.frame = frame;
}

- (CGPoint)ff_orgin {
    return self.frame.origin;
}

- (void)setFf_frame:(CGRect)ff_frame {
    CGRect frame = self.frame;
    frame = ff_frame;
    self.frame = frame;
}

- (CGRect)ff_frame {
    return self.frame;
}

#pragma mark - 取当前view的父控制器
- (UIViewController *)ff_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 取当前view的导航栏控制器
- (UINavigationController *)ff_navViewController{
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

-(void)setZy_shadowLayer:(CALayer *)zy_shadowLayer{
    objc_setAssociatedObject(self, @selector(zy_shadowLayer), zy_shadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CALayer *)zy_shadowLayer{
    return  objc_getAssociatedObject(self, @selector(zy_shadowLayer));
}
-(void)setZy_gradientLayer:(CALayer *)zy_gradientLayer{
    objc_setAssociatedObject(self, @selector(zy_gradientLayer), zy_gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CALayer *)zy_gradientLayer{
    return  objc_getAssociatedObject(self, @selector(zy_shadowLayer));
}


-(void)zy_setShadowColor:(UIColor *)shadowColor
         shadowOffset:(CGSize)shadowOffset
         shadowRadius:(CGFloat)shadowRadius
        shadowOpacity:(CGFloat)shadowOpacity {
  
    [self.superview layoutIfNeeded];
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.ff_frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=5;
    subLayer.backgroundColor=[UIColor whiteColor].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    subLayer.shadowRadius = shadowRadius;//阴影半径，默认3
    subLayer.shouldRasterize = YES;
    subLayer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    CALayer *oldLayer = self.zy_shadowLayer;
    if (oldLayer) {
        [self.superview.layer replaceSublayer:self.zy_shadowLayer with:subLayer];
    }else{
        [self.superview.layer insertSublayer:subLayer below:self.layer];
    }
    self.zy_shadowLayer = subLayer;
}

-(void)zy_cornerRaidus:(CGFloat)radius{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)zy_borderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)color{
    
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

-(void)zy_addGradientLayerStartPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
                          startColor:(UIColor *)startColor
                            endColor:(UIColor *)endColor
                        cornerRadius:(CGFloat)cornerRadius{
    
    [self.superview layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,  (__bridge id)endColor.CGColor];//这里颜色渐变
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = self.frame;
    gradientLayer.cornerRadius = cornerRadius;
    CALayer *oldLayer = self.zy_gradientLayer;
    if (oldLayer) {
        [self.superview.layer replaceSublayer:self.zy_gradientLayer with:gradientLayer];
    }else{
        [self.superview.layer insertSublayer:gradientLayer below:self.layer];
    }
}

-(void)zy_adRectCorner:(UIRectCorner)rectCorner
           cornerRadii:(CGSize)cornerRadii{
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    self.layer.masksToBounds = YES;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
//    self.view_shadow.contentMode  = UIViewContentModeScaleAspectFill;
}

@end
