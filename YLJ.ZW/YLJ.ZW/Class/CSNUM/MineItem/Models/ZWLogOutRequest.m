//
//  ZWLogOutRequest.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/7.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWLogOutRequest.h"

@implementation ZWLogOutRequest
-(NSString *)requestHandler{
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

-(NSString *)requestMethod{
    
    
    return @"zwkj/logout.json";
}
@end

