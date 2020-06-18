//
//  ZWShareItemModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareItemModel.h"

@implementation ZWShareItemModel
//活动描述
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.text = myDic[@"text"];
        self.img = myDic[@"img"];
    }
    return self;
}

@end
