//
//  ZWAreaCodeModels.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAreaCodeModels.h"

@implementation ZWAreaCodeModels
/**
 *   获取国家编号
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.country = myDic[@"country"];
        self.pretel = myDic[@"pretel"];
        self.initial = myDic[@"initial"];
    }
    return self;
}
@end
