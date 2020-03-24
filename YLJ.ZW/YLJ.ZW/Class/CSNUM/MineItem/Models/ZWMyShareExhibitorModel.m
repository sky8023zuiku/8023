//
//  ZWMyShareExhibitorModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMyShareExhibitorModel.h"

@implementation ZWMyShareExhibitorModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitorId = myDic[@"exhibitorInviteVo"][@"exhibitorId"];
        self.merchantName = myDic[@"exhibitorInviteVo"][@"merchantName"];
        self.exhibitionName = myDic[@"exhibitorInviteVo"][@"exhibitionName"];
        self.profile = myDic[@"exhibitorInviteVo"][@"profile"];
        self.coverImage = myDic[@"exhibitorInviteVo"][@"coverImage"];
    }
    return self;
}
@end
