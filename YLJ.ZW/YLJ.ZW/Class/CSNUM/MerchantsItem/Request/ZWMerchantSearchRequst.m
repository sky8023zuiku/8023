//
//  ZWMerchantSearchRequst.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMerchantSearchRequst.h"

@implementation ZWMerchantSearchRequst
-(NSString *)requestHandler{
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

-(NSString *)requestMethod{
    
    
    return @"zwkj/merchant/fuzzy_result.json";
}
@end
