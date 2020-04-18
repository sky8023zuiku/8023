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
        self.userId = myDic[@"userId"];
        self.headImage = myDic[@"headImage"];
        self.phone = myDic[@"phone"];
        self.username = myDic[@"username"];
        self.created = myDic[@"created"];
    }
    return self;
}
@end
