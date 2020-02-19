//
//  ZWSaveDataAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSaveDataAction.h"

@implementation ZWSaveDataAction
static ZWSaveDataAction *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}
/**
 *   保存和获取城市列表
 */
- (void)saveCityData:(NSDictionary *)cityData{
    NSMutableData *dataCity = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataCity];
    [archiver encodeObject:cityData forKey:@"cityData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataCity forKey:@"cityData"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeCityData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataCity = [userDefaults dataForKey:@"cityData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataCity];
    NSDictionary *cityData = [unarchiver decodeObjectForKey:@"cityData"];
    [unarchiver finishDecoding];
    return cityData;
}
/**
 *   保存和获取城市列表
 */
- (void)saveIndustryData:(NSDictionary *)industryData {
    NSMutableData *dataIndustry = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataIndustry];
    [archiver encodeObject:industryData forKey:@"industryData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataIndustry forKey:@"industryData"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeIndustryData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataIndustry = [userDefaults dataForKey:@"industryData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataIndustry];
    NSDictionary *industryData = [unarchiver decodeObjectForKey:@"industryData"];
    [unarchiver finishDecoding];
    return industryData;
}
/**
 *   保存和获取用户信息
 */
- (void)saveUserInfoData:(NSDictionary *)userInfoData {
    NSMutableData *dataUserInfo = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataUserInfo];
    [archiver encodeObject:userInfoData forKey:@"userInfoData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataUserInfo forKey:@"userInfoData"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeUserInfoData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataUserInfo = [userDefaults dataForKey:@"userInfoData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataUserInfo];
    NSDictionary *userInfoData = [unarchiver decodeObjectForKey:@"userInfoData"];
    [unarchiver finishDecoding];
    return userInfoData;
}
/**
 *   保存和获取当前的城市名称
*/
- (void)saveCityName:(NSDictionary *)cityName  {
    NSMutableData *cityNameInfo = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cityNameInfo];
    [archiver encodeObject:cityName forKey:@"cityName"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityNameInfo forKey:@"cityName"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeCityName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *cityNameInfo = [userDefaults dataForKey:@"cityName"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:cityNameInfo];
    NSDictionary *cityName = [unarchiver decodeObjectForKey:@"cityName"];
    [unarchiver finishDecoding];
    return cityName;
}

- (void)removeLocation {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoData"];
}

@end
