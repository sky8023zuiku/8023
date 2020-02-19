//
//  CSDrawerCountriesModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/20.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSDrawerCountriesModel.h"

@implementation CSDrawerCountriesModel
/**
 * 获取国家模型
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.name = myDic[@"name"];
        self.countriesId = myDic[@"id"];
        self.isSelected = NO;
    }
    return self;
}
@end
