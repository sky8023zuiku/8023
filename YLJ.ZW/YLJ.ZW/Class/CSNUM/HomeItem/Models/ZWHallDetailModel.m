//
//  ZWHallDetailModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallDetailModel.h"

@implementation ZWHallDetailModel
/**
 * 展馆详情
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.hallId = myDic[@"hallId"];
        self.hallName = myDic[@"hallName"];
        self.country = myDic[@"country"];
        self.city = myDic[@"city"];
        self.website = myDic[@"website"];
        self.telephone = myDic[@"telephone"];
        self.address = myDic[@"address"];
        self.latitude = myDic[@"latitude"];
        self.longitude = myDic[@"longitude"];
        self.profile = myDic[@"profile"];
        self.imageVos = myDic[@"imageVos"];
    }
    return self;
}
@end
