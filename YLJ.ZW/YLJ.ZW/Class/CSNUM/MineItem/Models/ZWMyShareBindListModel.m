//
//  ZWMyShareBindListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareBindListModel.h"

@implementation ZWMyShareBindListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitionId = myDic[@"exhibitionId"];
        self.merchantId = myDic[@"merchantId"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.exposition = myDic[@"exposition"];
        self.price = myDic[@"price"];
        self.imagesId = myDic[@"imagesId"];
        self.endTime = myDic[@"endTime"];
        self.startTime = myDic[@"startTime"];
        self.exhibitorId = myDic[@"exhibitorId"];
        NSDictionary *dic = myDic[@"images"];
        if (dic) {
            self.url = myDic[@"images"][@"url"];
        }
        self.city = myDic[@"city"];
        self.country = myDic[@"country"];
        self.total = myDic[@"total"];
        self.bindSize = myDic[@"bindSize"];
    }
    return self;
}
@end
