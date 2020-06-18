//
//  ZWAuditMessageModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/24.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWAuditMessageModel.h"

@implementation ZWAuditMessageModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listId = myDic[@"id"];
        self.readStatus = myDic[@"readStatus"];
        self.type = myDic[@"type"];
        self.message = myDic[@"message"];
        NSData *jsonData = [self.message dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        self.myDescription = dic[@"description"];
        self.create = dic[@"create"];
        self.title = dic[@"title"];
        self.status= dic[@"status"];
    }
    return self;
}
@end
