//
//  ZWExhibitinServerSecondaryIndustryModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitinServerSecondaryIndustryModel.h"

@implementation ZWExhibitinServerSecondaryIndustryModel
//+ (id)parseJSON:(NSDictionary *)jsonDic {
//    return [[self alloc]initWithJSON:jsonDic];
//}
//- (id)initWithJSON:(NSDictionary *)myDic {
//    if (self = [super init]) {
//        self.industryId = myDic[@"id"];
//        self.name = myDic[@"name"];
//    }
//    return self;
//}

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"industryId":@"id"};
}

@end
