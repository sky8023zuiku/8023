//
//  ZWCitiesListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCitiesListModel.h"

@implementation ZWCitiesListModel
/**
 * 获取城市
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.citiesId = myDic[@"id"];
        self.name = myDic[@"name"];
    }
    return self;
}
@end
