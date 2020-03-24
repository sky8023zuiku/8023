//
//  ZWMyShareExhibitionUserModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareExhibitionUserModel.h"

@implementation ZWMyShareExhibitionUserModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitionId = myDic[@"exhibitionId"];
        self.coverImage = myDic[@"coverImage"];
        self.phone = myDic[@"phone"];
        self.inviteCode = myDic[@"inviteCode"];
        self.userName = myDic[@"userName"];
        self.bindTime = myDic[@"bindTime"];
    }
    return self;
}
@end
