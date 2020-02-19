//
//  ZWInduExhibitorsModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWInduExhibitorsModel.h"

@implementation ZWInduExhibitorsModel
/**
 * 行业展商列表
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.merchantId = myDic[@"merchantId"];
        self.product = myDic[@"product"];
        self.collection = myDic[@"collection"];
        self.imageUrl = myDic[@"imageUrl"];
        self.vipVersion = myDic[@"vipVersion"];
        self.requirement = myDic[@"requirement"];
        self.name = myDic[@"name"];
        self.seq = myDic[@"seq"];
    }
    return self;
}
@end
