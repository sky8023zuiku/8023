//
//  ZWExhibitorsSaveLocation.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsSaveLocation.h"

@implementation ZWExhibitorsSaveLocation

static ZWExhibitorsSaveLocation *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}

/**
 *   保存行业展商详情
 */
- (void)saveExhibitorsDetails:(NSDictionary *)detailsData {
    NSMutableData *dataDetails = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataDetails];
    [archiver encodeObject:detailsData forKey:@"exhibitorsDetailsData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataDetails forKey:@"exhibitorsDetailsData"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeExhibitorsDetailsData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataDetails = [userDefaults dataForKey:@"exhibitorsDetailsData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataDetails];
    NSDictionary *detailsData = [unarchiver decodeObjectForKey:@"exhibitorsDetailsData"];
    [unarchiver finishDecoding];
    return detailsData;
}
/**
 *   保存行业展商产品展示
 */
- (void)saveExhibitorsProductList:(NSArray *)productData {
    NSMutableData *dataProducts = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataProducts];
    [archiver encodeObject:productData forKey:@"exhibitorsProductsData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataProducts forKey:@"exhibitorsProductsData"];
    [userDefaults synchronize];
}
- (NSArray *)takeExhibitorsProductListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataProducts = [userDefaults dataForKey:@"exhibitorsProductsData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataProducts];
    NSArray *productData = [unarchiver decodeObjectForKey:@"exhibitorsProductsData"];
    [unarchiver finishDecoding];
    return productData;
}
/**
 *   保存行业展商动态列表
 */
- (void)saveExhibitorsDynamicList:(NSDictionary *)dynamicData {
    NSMutableData *dataDynamic = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataDynamic];
    [archiver encodeObject:dynamicData forKey:@"exhibitorsDynamicData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataDynamic forKey:@"exhibitorsDynamicData"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeExhibitorsDynamicListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataDynamic = [userDefaults dataForKey:@"exhibitorsDynamicData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataDynamic];
    NSDictionary *dynamicData = [unarchiver decodeObjectForKey:@"exhibitorsDynamicData"];
    [unarchiver finishDecoding];
    return dynamicData;
}
/**
 *   保存行业展商联系方式列表
 */
- (void)saveExhibitorsContactList:(NSArray *)contactData {
    NSMutableData *dataContact = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataContact];
    [archiver encodeObject:contactData forKey:@"exhibitorsContactData"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataContact forKey:@"exhibitorsContactData"];
    [userDefaults synchronize];
}
- (NSArray *)takeExhibitorsContactListData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataContact = [userDefaults dataForKey:@"exhibitorsContactData"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataContact];
    NSArray *contactData = [unarchiver decodeObjectForKey:@"exhibitorsContactData"];
    [unarchiver finishDecoding];
    return contactData;
}

@end
