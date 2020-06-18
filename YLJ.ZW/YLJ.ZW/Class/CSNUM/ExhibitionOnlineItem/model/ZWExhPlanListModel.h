//
//  ZWExhPlanListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/8.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhPlanListModel : NSObject

@property(nonatomic, copy)NSString *city;//城市
@property(nonatomic, copy)NSString *country;//国家
@property(nonatomic, copy)NSString *ID;//列表id
@property(nonatomic, copy)NSString *endTime;//结束时间
@property(nonatomic, copy)NSString *startTime;//开始时间
@property(nonatomic, copy)NSString *name;//开始时间
@property(nonatomic, copy)NSString *url;//标题图
@property(nonatomic, copy)NSString *developingState;//0正常，1延期，2取消
@property(nonatomic, copy)NSString *announcementImages;//公告图片
@property(nonatomic, copy)NSString *myNewStartTime;//最新的开始时间
@property(nonatomic, copy)NSString *myNewEndTime;//最新的结束时间
@property(nonatomic, copy)NSString *exhibitionHallName;//展馆名称
@property(nonatomic, copy)NSString *sponsor;//主办方

+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
