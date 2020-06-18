//
//  ZWMessageNumAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/27.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMessageNumAction.h"

@implementation ZWMessageNumAction

static ZWMessageNumAction *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}

- (void)takeMessageNumber {
    NSDictionary *userInfo = [[ZWSaveDataAction shareAction]takeUserInfoData];
    if (userInfo) {
        [[ZWDataAction sharedAction]getReqeustWithURL:zwGetMessageNum parametes:@{} successBlock:^(NSDictionary * _Nonnull data) {
            NSLog(@"-----我的消息数量是多少%@",data);
            if (zw_issuccess) {
                [[ZWSaveDataAction shareAction]saveMessageNum:data[@"data"]];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        }];
    }
}





@end
