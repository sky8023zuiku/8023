//
//  JhPageItemModel.m
//  JhPageItemView
//
//  Created by Jh on 2018/11/16.
//  Copyright © 2018 Jh. All rights reserved.
//

#import "JhPageItemModel.h"

@implementation JhPageItemModel
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
