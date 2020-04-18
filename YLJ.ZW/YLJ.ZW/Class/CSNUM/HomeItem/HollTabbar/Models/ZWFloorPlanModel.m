//
//  ZWFloorPlanModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWFloorPlanModel.h"

@implementation ZWFloorPlanModel
/**
 * 展厅平面图
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.hallNumberId = myDic[@"hallNumberId"];
        self.hallNumberName = myDic[@"hallNumberName"];
        self.imageUrl = myDic[@"imageUrl"];
        self.images = myDic[@"images"];
    }
    return self;
}
@end
