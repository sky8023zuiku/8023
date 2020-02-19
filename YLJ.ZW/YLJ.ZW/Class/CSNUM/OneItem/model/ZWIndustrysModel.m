//
//  ZWIndustryModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIndustrysModel.h"

@implementation ZWIndustrysModel
/**
 * 展会展商行业列表
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitionId = myDic[@"exhibitionId"];
        self.listId = myDic[@"id"];
        self.industryId = myDic[@"industryId"];
        self.industryName = myDic[@"industryName"];
    }
    return self;
}
@end
