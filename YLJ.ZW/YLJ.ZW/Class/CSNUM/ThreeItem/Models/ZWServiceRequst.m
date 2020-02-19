//
//  ZWServiceRequst.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/2.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWServiceRequst.h"

@implementation ZWServiceRequst
/*********************************************占个位***********************************************/
@end
/**
 * 轮播图
 */
@implementation ZWServiceLBTRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/service/provider/advert.json";
}

@end

/**
 * 主推列表
 */
@implementation ZWServiceMainListRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"。。。。";
}
@end
/**
 * 服务商列表
 */
@implementation ZWServiceProvidersListRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/service/provider/page_list.json";
}

@end

/**
 * 服务商详情
 */
@implementation ZWServiceProvidersDetailRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/service/provider/detail.json";
}

@end
/**
 * 拼单列表
 */
@implementation ZWServiceSpellListRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/spell/list/page_list.json";
}

@end
/**
 * 展商联想查询
 */
@implementation ZWExhibitorAssociationListRequst

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/merchant/fuzzy_result.json";
}

@end
