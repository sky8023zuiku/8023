//
//  ZWSpellListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSpellListModel : NSObject
@property(nonatomic, copy)NSString * contacts;//服务商ID
@property(nonatomic, copy)NSString * decorateEndTime;//布展结束时间
@property(nonatomic, copy)NSString * decorateStartTime;//布展开始时间
@property(nonatomic, copy)NSString * endTime;//展会结束时间
@property(nonatomic, copy)NSString * exhibitionHall;//展馆名称
@property(nonatomic, copy)NSString * exhibitionName;//展会名称
@property(nonatomic, copy)NSString * hallNumber;//展馆号
@property(nonatomic, copy)NSString * invalidTime;//拼单截止时间
@property(nonatomic, copy)NSString * origin;//出发地点
@property(nonatomic, copy)NSString * remarks;//备注
@property(nonatomic, copy)NSString * requirement;//需求
@property(nonatomic, copy)NSString * size;//展台面积
@property(nonatomic, copy)NSString * spellId;//拼单id
@property(nonatomic, copy)NSString * startTime;//展会开始时间
@property(nonatomic, copy)NSString * status;//可见状态，1.不可见，2.可见，3违规
@property(nonatomic, copy)NSString * telephone;//手机号码
@property(nonatomic, copy)NSString * title;//拼单名称
@property(nonatomic, copy)NSString * material;//材质
@property(nonatomic, copy)NSString * exhibitorCount;//材质
@property(nonatomic, copy)NSString * dismanted;//撤展时间
@property(nonatomic, copy)NSString * destination;//目的地
@property(nonatomic, copy)NSString * type;//1.2.3 制作拼单 4.看馆拼单 5.保险拼单 6.货车拼单




+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
