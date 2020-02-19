//
//  FFRequestValidDelegate.h
//  Funmily
//
//  Created by kevin on 16/8/31.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

@class YHBaseRespense;

@protocol YHRequestValidDelegate <NSObject>

@optional

/**
 *  设置默认信息
 */
-(void)setupData;

/**
 *  添加请求 头信息
 */
-(void)addHeaderParam;
-(void)resetHeaderParam;

/**
 *  请求的URL
 */
-(NSString *)requestUrl;

-(NSString *)requestMethod;
-(NSString *)requestHandler;

/**
 *  过滤的参数
 */
+(NSArray *)getIgnoredKeys;

/**
 *  默认参数
 */
-(NSDictionary *)addDefaultParams;


/**
 *  参数处理
 */
- (BOOL)requestValidator;

/**
 *  返回值处理
 */
- (YHBaseRespense *)parseRespenseData:(YHBaseRespense *)baseRespense;
- (YHBaseRespense *)parseRespense:(id )info;

@end

