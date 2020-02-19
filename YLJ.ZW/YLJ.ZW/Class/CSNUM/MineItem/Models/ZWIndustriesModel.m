//
//  ZWIndustriesModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIndustriesModel.h"

@implementation ZWIndustriesModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.secondIndustryName = myDic[@"secondIndustryName"];
        self.secondIndustryId = myDic[@"secondIndustryId"];
        self.thirdIndustryList = myDic[@"thirdIndustryList"];
        NSArray *myData = myDic[@"thirdIndustryList"];
        NSMutableArray *myArray = [NSMutableArray array];
        for (NSDictionary *myDic in myData) {
            ZW3IndustriesModel *model = [ZW3IndustriesModel parseJSON:myDic];
            [myArray addObject:model];
        }
        self.thirdIndustryList = myArray;
        
    }
    return self;
}
@end

@implementation ZW3IndustriesModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.industryId = myDic[@"id"];
        self.name = myDic[@"name"];
        self.isSelected = NO;
    }
    return self;
}
@end
