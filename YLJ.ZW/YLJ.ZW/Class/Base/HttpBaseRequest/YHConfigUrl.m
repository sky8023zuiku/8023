//
//  YHConfigUrl.m
//  YHEnterpriseB2B
//
//  Created by zhangyong on 2019/1/17.
//  Copyright © 2019年 yh. All rights reserved.
//

#import "YHConfigUrl.h"

@interface YHConfigUrl ()

@property(nonatomic,copy,readwrite)NSString *loginHandler;

@end
@implementation YHConfigUrl


+(instancetype)shareYHConfigUrl{
    static YHConfigUrl *configUrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configUrl = [YHConfigUrl new];
    });
    return configUrl;
}

-(instancetype)init{
    if (self = [super init]) {
        
//        _webBaseInstance = @"http://192.168.7.101";
//        _webBaseInstance = @"http://192.168.7.106";
//        _webBaseInstance = API_HOST;
        
//        _webInstance = [_webBaseInstance stringByAppendingString:@":9000/"];
//        _webTestInstance = [_webBaseInstance stringByAppendingString:@":9000/"];
        
        _webInstance = [NSString stringWithFormat:@"%@/",API_HOST];
        _webTestInstance = [NSString stringWithFormat:@"%@/",API_HOST];;
        
    }
    return self;
}


@end
