//
//  ZWExhibitionServerDetailCaseModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/19.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionServerDetailCaseModel.h"

@implementation ZWExhibitionServerDetailCaseModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.caseId = myDic[@"id"];
        self.descriptionStr = myDic[@"description"];
        self.caseUrl = myDic[@"url"];
    }
    return self;
}

@end
