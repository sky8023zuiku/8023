//
//  PointModel.h
//  Team
//
//  Created by G G on 2018/11/15.
//  Copyright © 2018 G G. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointModel : MAPointAnnotation

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *titleImage;//标题图
@property (nonatomic, copy) NSString *addressStr;//地址

@end

NS_ASSUME_NONNULL_END
