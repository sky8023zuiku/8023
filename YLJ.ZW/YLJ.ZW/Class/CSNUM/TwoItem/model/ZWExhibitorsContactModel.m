//
//  ZWExhibitorsContactModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/14.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitorsContactModel.h"

@implementation ZWExhibitorsContactModel
/**
 * 行业展商联系人
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.phone = myDic[@"phone"];
        self.post = myDic[@"post"];
        self.mail = myDic[@"mail"];
        self.qq = myDic[@"qq"];
        self.contacts = myDic[@"contacts"];
        self.ID = myDic[@"id"];
        self.telephone = myDic[@"telephone"];
        self.type = myDic[@"type"];
    }
    return self;
}
@end
