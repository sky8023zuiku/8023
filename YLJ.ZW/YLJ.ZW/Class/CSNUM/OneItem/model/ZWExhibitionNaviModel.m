//
//  ZWExhibitionNaviModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionNaviModel.h"

@implementation ZWExhibitionNaviModel
/**
 * 展会导航
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitionId = myDic[@"exhibitionId"];
        self.belowImagesUrl = myDic[@"belowImagesUrl"];
        self.merchantCount = myDic[@"merchantCount"];
        self.nExhibitorCount = myDic[@"newExhibitorCount"];
        self.endTime = myDic[@"endTime"];
        self.merchantCount = myDic[@"merchantCount"];
        self.endTime = myDic[@"endTime"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.hallName = myDic[@"hallName"];
        self.topImagesUrl = myDic[@"topImagesUrl"];
        self.startTime = myDic[@"startTime"];
    }
    return self;
}

@end
