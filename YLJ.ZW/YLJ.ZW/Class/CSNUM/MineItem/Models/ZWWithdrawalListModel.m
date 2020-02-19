//
//  ZWWithdrawalListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWWithdrawalListModel.h"

@implementation ZWWithdrawalListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.status = myDic[@"status"];
        self.count = myDic[@"count"];
        self.ID = myDic[@"id"];
        self.created = myDic[@"created"];
        self.applyType = myDic[@"applyType"];
        self.cardNumber = myDic[@"cardNumber"];
        
    }
    return self;
}
@end
