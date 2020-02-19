//
//  ZWExhibitionTimelineModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/13.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionTimelineModel.h"

@implementation ZWExhibitionTimelineModel
/**
 * 展会排期
 */
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listID = myDic[@"id"];
        self.startTime = myDic[@"startTime"];
        self.endTime = myDic[@"endTime"];
        self.name = myDic[@"name"];
        self.url = myDic[@"url"];
        self.sponsor = myDic[@"sponsor"];
        self.announcementImages = myDic[@"announcementImages"];
        self.developingState = myDic[@"developingState"];
    }
    return self;
}
@end
