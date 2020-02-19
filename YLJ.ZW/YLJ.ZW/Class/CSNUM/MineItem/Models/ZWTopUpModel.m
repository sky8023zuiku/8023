//
//  ZWTopUpModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWTopUpModel.h"

@implementation ZWTopUpModel
/**
 *   联系人列表
*/
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.phonePrice = myDic[@"phonePrice"];
        self.score = myDic[@"score"];
        self.ID = myDic[@"id"];
    }
    return self;
}
@end
