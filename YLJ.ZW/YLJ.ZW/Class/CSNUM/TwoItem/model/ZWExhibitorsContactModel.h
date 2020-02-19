//
//  ZWExhibitorsContactModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/14.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitorsContactModel : NSObject
@property(nonatomic, copy)NSString *phone;//展会名称
@property(nonatomic, copy)NSString *ID;//列表id
@property(nonatomic, copy)NSString *mail;//公司名称
@property(nonatomic, copy)NSString *qq;//时间
@property(nonatomic, copy)NSString *contacts;//标题图
@property(nonatomic, copy)NSString *telephone;//公司id
@property(nonatomic, copy)NSString *type;//结束时间
@property(nonatomic, copy)NSString *post;//结束时间
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
