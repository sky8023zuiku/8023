//
//  ZWExhibitorIndustryModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorIndustryModel.h"

@implementation ZWExhibitorIndustryModel
/**
 * 行业展商筛选
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listId = myDic[@"id"];
        self.name = myDic[@"name"];
    }
    return self;
}

@end
