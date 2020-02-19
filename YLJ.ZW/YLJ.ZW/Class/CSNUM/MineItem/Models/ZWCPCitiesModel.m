//
//  ZWCPCitiesModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCPCitiesModel.h"

@implementation ZWCPCitiesModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.code = myDic[@"code"];
        self.value = myDic[@"value"];
        self.key = myDic[@"key"];
        self.level = myDic[@"level"];
    }
    return self;
}
@end
