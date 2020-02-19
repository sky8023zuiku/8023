//
//  CustomCalloutView.h
//  Team
//
//  Created by G G on 2018/11/16.
//  Copyright © 2018 G G. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCalloutView : UIView
@property (nonatomic, strong) UIImage *image;//活动标题图片
@property (nonatomic, copy) NSString *title;//活动名称
@property (nonatomic, copy) NSString *subtitle;//活动地址
@property (nonatomic, strong) UIImageView *portraitView;
@end

NS_ASSUME_NONNULL_END
