//
//  ZWHallListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWHallListModel : NSObject

@property(nonatomic, copy)NSString *hallName;//展馆名称
@property(nonatomic, copy)NSString *coverImage;//展馆标题图
@property(nonatomic, copy)NSString *website;//展馆网页
@property(nonatomic, copy)NSString *telephone;//展馆电话
@property(nonatomic, copy)NSString *address;//展馆地址
@property(nonatomic, copy)NSString *hallId;//展馆id
@property(nonatomic, copy)NSString *longitude;//经度
@property(nonatomic, copy)NSString *latitude;//纬度
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
