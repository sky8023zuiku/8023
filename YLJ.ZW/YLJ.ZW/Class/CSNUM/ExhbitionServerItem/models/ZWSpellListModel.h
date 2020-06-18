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
@property(nonatomic, copy)NSString * contacts;//联系人
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
@property(nonatomic, copy)NSString * exhibitorCount;//展台数量
@property(nonatomic, copy)NSString * dismanted;//撤展时间
@property(nonatomic, copy)NSString * destination;//目的地
@property(nonatomic, copy)NSString * type;//1.2.3 制作拼单 4.看馆拼单 5.保险拼单 6.货车拼单
@property(nonatomic, copy)NSString * spellStatus;//1.拼单中，2.拼单成功，3.拼单失败
@property(nonatomic, copy)NSString * city;//城市
@property(nonatomic, copy)NSString * topRemaining;//0为不可置顶，1为可以置顶
@property(nonatomic, copy)NSString * exhibitorSize;//展台数量
@property(nonatomic, copy)NSString * created;//发布日期
@end

NS_ASSUME_NONNULL_END
