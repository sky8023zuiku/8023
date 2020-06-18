//
//  ZWExhPlanListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/8.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhPlanListModel.h"

@implementation ZWExhPlanListModel
/**
 * 计划展会列表
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
        self.developingState = myDic[@"developingState"];
        self.announcementImages = myDic[@"announcementImages"];
        self.myNewStartTime = myDic[@"newStartTime"];
        self.myNewEndTime = myDic[@"newEndTime"];
        self.exhibitionHallName = myDic[@"exhibitionHallName"];
        self.sponsor = myDic[@"sponsor"];
    }
    return self;
}
@end
