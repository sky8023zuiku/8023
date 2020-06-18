//
//  ZWExExhibitorsFuzzySearchModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExExhibitorsFuzzySearchModel.h"

@implementation ZWExExhibitorsFuzzySearchModel
/**
 * 展会展商模糊查询
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.merchantId = myDic[@"merchantId"];
        self.merchantName = myDic[@"merchantName"];
    }
    return self;
}
@end
