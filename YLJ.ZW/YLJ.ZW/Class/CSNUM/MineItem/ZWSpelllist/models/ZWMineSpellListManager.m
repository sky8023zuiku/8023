//
//  ZWMineSpellListManager.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/4.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineSpellListManager.h"

@implementation ZWMineSpellListManager

static ZWMineSpellListManager *shareManager = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

@end
