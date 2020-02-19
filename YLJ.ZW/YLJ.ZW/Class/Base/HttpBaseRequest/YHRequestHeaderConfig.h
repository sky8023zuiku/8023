//
//  YHRequestHeaderConfig.h
//  YHEnterpriseB2B
//
//  Created by zhangyong on 2019/1/16.
//  Copyright © 2019年 yh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHRequestHeaderConfig : NSObject

+ (instancetype)shareConfig;
/**
 *  http Header
 *
 *  @param requestUrl 请求的url
 *
 *  @return NSDictionary
 */
- (NSDictionary *)appendHeadersWithUrl:(NSString *)requestUrl;

/**
 *  用户资料更新
 */
- (void)updateUser;

/**
 *  后台配置更新
 */
- (void)updateServerConfig:(NSDictionary *)serverConfig;

-(void)updateDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
