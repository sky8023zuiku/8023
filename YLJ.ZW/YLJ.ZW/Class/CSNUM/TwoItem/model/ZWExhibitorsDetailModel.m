//
//  ZWExhibitorsDetailModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsDetailModel.h"

@implementation ZWExhibitorsDetailModel
/**
 * 行业展商详情
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.address = myDic[@"address"];
        self.product = myDic[@"product"];
        self.website = myDic[@"website"];
        self.name = myDic[@"name"];
        self.email = myDic[@"email"];
        self.requirement = myDic[@"requirement"];
        self.name = myDic[@"name"];
        self.telephone = myDic[@"telephone"];
        self.productUrl = myDic[@"productUrl"];
        self.profile = myDic[@"profile"];
        self.images = myDic[@"images"];
    }
    return self;
}
@end
