//
//  ZWHallListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallListModel.h"

@implementation ZWHallListModel
/**
 * 展馆列表
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.hallId = myDic[@"hallId"];
        self.hallName = myDic[@"hallName"];
        self.coverImage = myDic[@"coverImage"];
        self.website = myDic[@"website"];
        self.telephone = myDic[@"telephone"];
        self.address = myDic[@"address"];
        self.longitude = myDic[@"longitude"];
        self.latitude = myDic[@"latitude"];
    }
    return self;
}
@end
