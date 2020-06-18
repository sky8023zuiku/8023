//
//  ZWBusinessCardModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/23.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWBusinessCardModel.h"

@implementation ZWBusinessCardModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.contacts = myDic[@"contacts"];
        self.merchantName = myDic[@"merchantName"];
        self.post = myDic[@"post"];
        self.telephone = myDic[@"telephone"];
        self.mail = myDic[@"mail"];
        self.address = myDic[@"address"];
        self.qq = myDic[@"qq"];
        self.phone = myDic[@"phone"];
        self.cardId = myDic[@"id"];
        self.requirement = myDic[@"requirement"];
    }
    return self;
}
@end
