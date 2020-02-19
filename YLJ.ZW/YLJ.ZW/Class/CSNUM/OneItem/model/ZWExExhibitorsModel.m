//
//  ZWExExhibitorsModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExExhibitorsModel.h"

@implementation ZWExExhibitorsModel
/**
 * 展会展商列表
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.name = myDic[@"name"];
        self.coverImages = myDic[@"coverImages"];
        self.name = myDic[@"name"];
        self.exhibitionId = myDic[@"exhibitionId"];
        self.exposition = myDic[@"exposition"];
        self.collection = myDic[@"collection"];
        self.product = myDic[@"product"];
        self.merchantId = myDic[@"merchantId"];
        self.expositionUrl = myDic[@"expositionUrl"];
        self.requirement = myDic[@"requirement"];
        self.exhibitorId = myDic[@"exhibitorId"];
        self.vipVersion = myDic[@"vipVersion"];
        self.exhibitorsType = 0;
        self.selectType = 0;
        self.JumpType = 0;
        self.isRreadAll = 0;
    }
    return self;
}
@end
