//
//  ZWHallDetailModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWHallDetailModel : NSObject

@property(nonatomic, copy)NSString *hallId;//展馆ID
@property(nonatomic, copy)NSString *website;//展馆网址
@property(nonatomic, copy)NSString *address;//展馆地址
@property(nonatomic, copy)NSString *country;//展馆所属国家
@property(nonatomic, copy)NSString *city;//展馆所属城市
@property(nonatomic, copy)NSString *longitude;//经度
@property(nonatomic, copy)NSString *latitude;//纬度
@property(nonatomic, copy)NSString *hallName;//展馆名称
@property(nonatomic, copy)NSString *telephone;//电话
@property(nonatomic, copy)NSString *profile;//简介
@property(nonatomic, strong)NSArray *imageVos;//轮播图
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
