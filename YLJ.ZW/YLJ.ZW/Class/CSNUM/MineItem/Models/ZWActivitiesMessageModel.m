//
//  ZWActivitiesMessageModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWActivitiesMessageModel.h"

@implementation ZWActivitiesMessageModel

+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listId = myDic[@"id"];
        self.readStatus = myDic[@"readStatus"];
        self.type = myDic[@"type"];
        self.message = myDic[@"message"];
        self.created = myDic[@"created"];
        NSData *jsonData = [self.message dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (dic) {
            self.description2 = dic[@"description"];
            self.create = dic[@"create"];
            self.title = dic[@"title"];
        }
    }
    return self;
}

@end
