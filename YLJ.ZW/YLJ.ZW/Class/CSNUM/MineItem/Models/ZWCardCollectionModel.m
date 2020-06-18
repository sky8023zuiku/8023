//
//  ZWCardCollectionModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/25.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWCardCollectionModel.h"

@implementation ZWCardCollectionModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listId = myDic[@"id"];
        self.readStatus = myDic[@"readStatus"];
        self.created = myDic[@"created"];
        self.sender = myDic[@"sender"];
        self.headImage = myDic[@"headImage"];
        self.userCard = myDic[@"userCard"];
        NSData *jsonData = [self.userCard  dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        self.contacts = dic[@"contacts"];
        self.phone = dic[@"phone"];
    }
    return self;
}
@end
