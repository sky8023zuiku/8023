//
//  ZWExhibitionTimelineModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionTimelineModel : NSObject

@property(nonatomic, copy)NSString *listID;//列表id
@property(nonatomic, copy)NSString *startTime;//开始时间
@property(nonatomic, copy)NSString *endTime;//结束时间
@property(nonatomic, copy)NSString *name;//展会名称
@property(nonatomic, copy)NSString *sponsor;//主办方
@property(nonatomic, copy)NSString *url;//标题图
@property(nonatomic, copy)NSString *announcementImages;//公告
@property(nonatomic, copy)NSString *developingState;//0为正常，1为延期，2为取消
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
