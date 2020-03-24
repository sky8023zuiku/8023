//
//  ZWMyShareExhibitionListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareExhibitionListModel.h"

@implementation ZWMyShareExhibitionListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitionId = myDic[@"exhibitionId"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.bindSize = myDic[@"bindSize"];
        self.total = myDic[@"total"];
    }
    return self;
}
@end
