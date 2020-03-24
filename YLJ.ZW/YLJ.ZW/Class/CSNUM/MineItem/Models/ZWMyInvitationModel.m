//
//  ZWMyInvitationModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyInvitationModel.h"

@implementation ZWMyInvitationModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.phone = myDic[@"phone"];
        self.headImage = myDic[@"headImage"];
        self.recommendTime = myDic[@"recommendTime"];
        self.userName = myDic[@"userName"];
        self.listId = myDic[@"id"];
    }
    return self;
}
@end
