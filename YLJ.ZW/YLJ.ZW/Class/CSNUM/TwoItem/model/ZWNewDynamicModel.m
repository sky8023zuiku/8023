//
//  ZWNewDynamicModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWNewDynamicModel.h"

@implementation ZWNewDynamicModel
/**
 * 动态列表
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
//        self.exhibitionName = myDic[@"exhibitionName"];
//        self.merchantName = myDic[@"merchantName"];
//        self.created = myDic[@"created"];
//        self.url = myDic[@"url"];
//        self.merchantId = myDic[@"merchantId"];
//        self.ID = myDic[@"id"];
//        self.endTime = myDic[@"endTime"];
//        self.startTime = myDic[@"startTime"];
//        self.describe = myDic[@"describe"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.exhibitionId = myDic[@"exhibitionId"];
        self.exhibitorId = myDic[@"exhibitorId"];
        self.merchantId = myDic[@"merchantId"];
        self.exposition = myDic[@"exposition"];
        self.imagesId = myDic[@"imagesId"];
        self.images = myDic[@"images"];
        self.price = myDic[@"price"];
        self.purchased = myDic[@"purchased"];
    }
    return self;
}
@end
