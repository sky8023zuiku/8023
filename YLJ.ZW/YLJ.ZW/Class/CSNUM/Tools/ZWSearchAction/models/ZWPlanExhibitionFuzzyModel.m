//
//  ZWPlanExhibitionFuzzyModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPlanExhibitionFuzzyModel.h"

@implementation ZWPlanExhibitionFuzzyModel
/**
 *   计划展会模糊查询
*/
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.name = myDic[@"name"];
    }
    return self;
}
@end
