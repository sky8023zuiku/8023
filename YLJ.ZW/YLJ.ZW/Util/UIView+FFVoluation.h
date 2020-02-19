//
//  UIView+FFVoluation.h
//  Funmily
//
//  Created by zhangyong on 16/8/17.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FFVoluation)
#pragma mark - 赋值相关的
/**
 *  frame.origin.x
 */
@property (nonatomic, assign) CGFloat ff_x;

/**
    frame.origin.x + frame.size.width
 */
@property (nonatomic, assign) CGFloat ff_right;

/**
 *  frame.origin.y
 */
@property (nonatomic, assign) CGFloat ff_y;

/**
 frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat ff_bottom;

/**
 *  center.x
 */
@property (nonatomic, assign) CGFloat ff_centerX;

/**
 *  center.y
 */
@property (nonatomic, assign) CGFloat ff_centerY;

/**
 *  frame.size.width
 */
@property (nonatomic, assign) CGFloat ff_width;

/**
 *  frame.size.height
 */
@property (nonatomic, assign) CGFloat ff_height;

/**
 *  frame.size
 */
@property (nonatomic, assign) CGSize ff_size;

/**
 *  frame.origin
 */
@property (nonatomic, assign) CGPoint  ff_orgin;

/**
 *  frame
 */
@property (nonatomic, assign) CGRect  ff_frame;


#pragma mark - 取当前view的父控制器
/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *ff_viewController;


@property (nullable, nonatomic, readonly) UINavigationController *ff_navViewController;

@property (nonatomic,retain) CALayer * _Nullable zy_shadowLayer;
@property (nonatomic,retain) CALayer * _Nullable zy_gradientLayer;


-(void)zy_setShadowColor:(UIColor *_Nullable)shadowColor
         shadowOffset:(CGSize)shadowOffset
         shadowRadius:(CGFloat)shadowRadius
        shadowOpacity:(CGFloat)shadowOpacity;

-(void)zy_cornerRaidus:(CGFloat)radius;
-(void)zy_borderWidth:(CGFloat)borderWidth BorderColor:(UIColor *_Nullable)color;

//颜色渐变
-(void)zy_addGradientLayerStartPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
                          startColor:(UIColor *_Nullable)startColor
                            endColor:(UIColor *_Nullable)endColor
                        cornerRadius:(CGFloat)cornerRadius;
//切某角
-(void)zy_adRectCorner:(UIRectCorner)rectCorner
           cornerRadii:(CGSize)cornerRadii;
@end
