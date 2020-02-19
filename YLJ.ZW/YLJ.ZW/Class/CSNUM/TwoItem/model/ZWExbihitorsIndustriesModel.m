//
//  ZWExbihitorsIndustriesModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/15.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExbihitorsIndustriesModel.h"

@implementation ZWExbihitorsIndustriesModel
/**
 * 所属行业
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.secondIndustryName = myDic[@"secondIndustryName"];
        self.secondIndustryId = myDic[@"secondIndustryId"];
        self.thirdIndustryName = myDic[@"thirdIndustryName"];
        self.thirdIndustryId = myDic[@"thirdIndustryId"];
    }
    return self;
}
@end
