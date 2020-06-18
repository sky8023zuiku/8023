//
//  ZWSaveDataAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSaveDataAction : NSObject
+ (instancetype)shareAction;
/**
 *   保存和获取城市列表
 */
- (void)saveCityData:(NSDictionary *)cityData;
- (NSDictionary *)takeCityData;
/**
 *   保存和获取城市列表
 */
- (void)saveIndustryData:(NSDictionary *)industryData;
- (NSDictionary *)takeIndustryData;
/**
 *   保存和获取用户信息
 */
- (void)saveUserInfoData:(NSDictionary *)userInfoData;
- (NSDictionary *)takeUserInfoData;
/**
 *   保存和获取当前的城市名称
 */
- (void)saveCityName:(NSDictionary *)cityName;
- (NSDictionary *)takeCityName;
/**
 *   保存和获取消息数量
 */
- (void)saveMessageNum:(NSDictionary *)messageNum;
- (NSDictionary *)takeMessageNum;
/**
 *   删除本地信息
 */
- (void)removeLocation;
@end

NS_ASSUME_NONNULL_END
