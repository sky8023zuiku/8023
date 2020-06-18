//
//  ZWExhPlanDetailModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/8.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhPlanDetailModel.h"

@implementation ZWExhPlanDetailModel
/**
 * 计划展会详情
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.city = myDic[@"city"];
        self.country = myDic[@"country"];
        self.ID = myDic[@"id"];
        self.endTime = myDic[@"endTime"];
        self.startTime = myDic[@"startTime"];
        self.name = myDic[@"name"];
        self.url = myDic[@"url"];
        self.industryName = myDic[@"industryName"];
        self.hallName = myDic[@"hallName"];
        self.sponsor = myDic[@"sponsor"];
        self.sponsorUrl = myDic[@"sponsorUrl"];
    }
    return self;
}
@end
