//
//  ZWCountriesListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/15.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCountriesListModel.h"

@implementation ZWCountriesListModel
/**
 * 获取国家
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.countriesId = myDic[@"id"];
        self.name = myDic[@"name"];
    }
    return self;
}
@end
