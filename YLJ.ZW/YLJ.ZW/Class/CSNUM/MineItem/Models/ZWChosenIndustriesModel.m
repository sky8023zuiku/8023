//
//  ZWChosenIndustriesModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/10.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWChosenIndustriesModel.h"

@implementation ZWChosenIndustriesModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.industries2Id = myDic[@"secondIndustryId"];
        self.industries2Name = myDic[@"secondIndustryName"];
        self.industries3Id = myDic[@"thirdIndustryId"];
        self.industries3Name = myDic[@"thirdIndustryName"];
    }
    return self;
}
@end
