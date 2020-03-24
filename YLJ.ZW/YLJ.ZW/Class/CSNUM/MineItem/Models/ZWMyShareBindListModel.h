//
//  ZWMyShareBindListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyShareBindListModel : NSObject

@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *merchantId;//展商id
@property(nonatomic, copy)NSString *exhibitionName;//用户电话号码
@property(nonatomic, copy)NSString *exposition;//展馆号
@property(nonatomic, copy)NSString *price;//价格
@property(nonatomic, copy)NSString *endTime;//绑定时间
@property(nonatomic, copy)NSString *startTime;//绑定时间
@property(nonatomic, copy)NSString *imagesId;//图片id
@property(nonatomic, copy)NSString *exhibitorId;//图片id
@property(nonatomic, copy)NSString *url;//图片链接
@property(nonatomic, copy)NSString *country;//图片链接
@property(nonatomic, copy)NSString *city;//图片链接
@property(nonatomic, copy)NSNumber *total;//绑定展会的分享码
@property(nonatomic, copy)NSNumber *bindSize;//已使用的分享码
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
