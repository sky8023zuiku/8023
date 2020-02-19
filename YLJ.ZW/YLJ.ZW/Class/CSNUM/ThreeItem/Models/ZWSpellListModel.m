//
//  ZWSpellListModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSpellListModel.h"

@implementation ZWSpellListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.contacts = myDic[@"contacts"];
        self.decorateEndTime = myDic[@"decorateEndTime"];
        self.decorateStartTime = myDic[@"decorateStartTime"];
        self.endTime = myDic[@"endTime"];
        self.exhibitionHall = myDic[@"exhibitionHall"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.hallNumber = myDic[@"hallNumber"];
        self.invalidTime = myDic[@"invalidTime"];
        self.origin = myDic[@"origin"];
        self.remarks = myDic[@"remarks"];
        self.requirement = myDic[@"requirement"];
        self.size = myDic[@"size"];
        self.spellId = myDic[@"spellId"];
        self.startTime = myDic[@"startTime"];
        self.status = myDic[@"status"];
        self.telephone = myDic[@"telephone"];
        self.title = myDic[@"title"];
        self.material = myDic[@"material"];
        self.exhibitorCount = myDic[@"exhibitorCount"];
        self.dismanted = myDic[@"dismanted"];
        self.destination = myDic[@"destination"];
    }
    return self;
}
@end
