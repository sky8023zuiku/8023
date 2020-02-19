//
//  ZWMainSaveLocation.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/15.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMainSaveLocation.h"

@implementation ZWMainSaveLocation
static ZWMainSaveLocation *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}
/**
 *   保存国家数据
*/
- (void)saveCountroiesList:(NSArray *)countroies {
    NSMutableData *dataCountroies = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataCountroies];
    [archiver encodeObject:countroies forKey:@"countroiesData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataCountroies forKey:@"countroiesData"];
    [userDefaults synchronize];
}
- (NSArray *)takeCountroiesListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataCountroies = [userDefaults dataForKey:@"countroiesData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataCountroies];
    NSArray *countroiesData = [unarchiver decodeObjectForKey:@"countroiesData"];
    [unarchiver finishDecoding];
    return countroiesData;
}
/**
 *   保存城市数据
 */
- (void)saveCitiesList:(NSArray *)cities {
    NSMutableData *dataCities = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataCities];
    [archiver encodeObject:cities forKey:@"citiesData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataCities forKey:@"citiesData"];
    [userDefaults synchronize];
}
- (NSArray *)takeCitiesListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataCities = [userDefaults dataForKey:@"citiesData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataCities];
    NSArray *citiesData = [unarchiver decodeObjectForKey:@"citiesData"];
    [unarchiver finishDecoding];
    return citiesData;
}
/**
 *   保存行业数据
 */
- (void)saveIndustriesList:(NSArray *)industries {
    NSMutableData *dataIndustries = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataIndustries];
    [archiver encodeObject:industries forKey:@"cindustriesData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataIndustries forKey:@"cindustriesData"];
    [userDefaults synchronize];
}
- (NSArray *)takeIndustriesListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataIndustries = [userDefaults dataForKey:@"cindustriesData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataIndustries];
    NSArray *cindustriesData = [unarchiver decodeObjectForKey:@"cindustriesData"];
    [unarchiver finishDecoding];
    return cindustriesData;
}
@end
