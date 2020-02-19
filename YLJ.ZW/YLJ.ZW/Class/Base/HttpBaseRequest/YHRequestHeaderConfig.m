//
//  YHRequestHeaderConfig.m
//  YHEnterpriseB2B
//
//  Created by zhangyong on 2019/1/16.
//  Copyright © 2019年 yh. All rights reserved.
//

#import "YHRequestHeaderConfig.h"
#import "YHConfigUrl.h"

@interface YHConfigUrl ()
@property(nonatomic,copy)NSString *token;


@end
@implementation YHRequestHeaderConfig


+ (instancetype)shareConfig {
    
    static YHRequestHeaderConfig *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[YHRequestHeaderConfig alloc] init];
    });
    return ins;
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    
}

-(NSDictionary *)appendHeadersWithUrl:(NSString *)requestUrl{
    
//    NSDictionary *dic = @{@"application/json":@"Content-Type"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //设置请求头
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setValue:user.uuid forKey:@"uuid"];
    [dict setValue:@"phone" forKey:@"request-terminal"];
    [dict setValue:@"application/json" forKey:@"Content-Type"];

    return dict;
}
-(void)updateDict:(NSDictionary *)dict{
    
}
@end
