//
//  ZWServiceResponse.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWServiceResponse.h"

@implementation ZWServiceResponse
/*********************************************占个位***********************************************/
@end
/**
 * 主推列表
 */
@implementation ZWServiceMainListModel

@end
/**
 * 服务商列表
 */
@implementation ZWServiceProvidersListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.providersId = myDic[@"id"];
        self.name = myDic[@"name"];
        self.business = myDic[@"business"];
        self.headLine = myDic[@"headLine"];
        self.speciality = myDic[@"speciality"];
        self.imagesUrl = myDic[@"imagesUrl"];
        self.total = myDic[@"total"];
        self.vipVersion = myDic[@"vipVersion"];
    }
    return self;
}
@end

/**
 * 拼单列表
 */
@implementation ZWServiceSpellListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.spellId = myDic[@"spellId"];
        self.created = myDic[@"created"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.contacts = myDic[@"contacts"];
        self.telephone = myDic[@"telephone"];
        self.merchantName = myDic[@"merchantName"];
        self.size = myDic[@"size"];
        self.exhibitionHall = myDic[@"exhibitionHall"];
        self.decorateTime = myDic[@"decorateTime"];
        self.startTime = myDic[@"startTime"];
        self.origin = myDic[@"origin"];
        self.type = @"";
    }
    return self;
}
@end
/**
 * 服务商详情
 */
@implementation ZWServiceProvidersDetailModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.telephone = myDic[@"telephone"];
        self.address = myDic[@"address"];
        self.name = myDic[@"name"];
        self.profile = myDic[@"profile"];
        self.imagesUrl = myDic[@"imagesUrl"];
    }
    return self;
}
@end


