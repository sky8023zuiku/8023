//
//  ZWPayRequest.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWPayRequest.h"

@implementation ZWPayRequest

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}
- (NSString *)requestMethod {
    return @"zwkj/order/wxPayApp.json";
}

@end

