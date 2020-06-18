//
//  ZWMerchantListRequest.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMerchantListRequest.h"

@implementation ZWMerchantListRequest

-(NSString *)requestHandler{
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

-(NSString *)requestMethod{
    
    
    return @"zwkj/merchant/page_lists.json";
}

@end
