//
//  ZWRequestAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDataAction.h"
#import <MBProgressHUD.h>
@implementation ZWDataAction

static id _action = nil;
+ (instancetype)sharedAction {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _action = [super allocWithZone:zone];
    });
    return _action;
}

- (void)setRequestHeader:(AFHTTPSessionManager *)manager {
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:user.uuid forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:@"phone" forHTTPHeaderField:@"request-terminal"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)setResponseHeader:(AFHTTPSessionManager *)manager {
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/plain",@"application/rdf+xml",@"text/html",@"text/javascript", nil];
}

- (void)myParametes:(id)parametes  {
    if (parametes) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parametes options:NSJSONWritingPrettyPrinted error:nil];
        NSString * parametesStr= [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"__参数__%@",parametesStr);
        NSLog(@"__方式__Get");
    }
}
- (void)myData:(id)_data {
    if (_data) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_data options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"___数据___%@",str);
        NSDictionary *mydic = _data;
        if ([mydic[@"msg"] isEqualToString:@"账号在别处登录，请重新登录或修改密码"]||[mydic[@"msg"] isEqualToString:@"请重新登录"]||[mydic[@"msg"] isEqualToString:@"请先登录"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"beBroughtUp" object:nil];
        }
        
    }
}

- (void)getReqeustWithURL:(NSString *)url
                parametes:(id)parametes
             successBlock:(mySuccess)success
             failureBlock:(myFailure)failure
               showInView:(UIView *)view{
    [self myParametes:parametes];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setResponseHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 30;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager GET:urlStr parameters:parametes progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getReqeustWithURL:(NSString *)url
                parametes:(id)parametes
             successBlock:(mySuccess)success
             failureBlock:(myFailure)failure {
    [self myParametes:parametes];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setResponseHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 30;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager GET:urlStr parameters:parametes progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post请求
- (void)postReqeustWithURL:(NSString *)url
                 parametes:(id)parametes
              successBlock:(mySuccess)success
              failureBlock:(myFailure)failure
                showInView:(UIView *)view {
    [self myParametes:parametes];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setResponseHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 30;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
     NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager POST:urlStr parameters:parametes progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (error) {
            failure(error);
            NSLog(@"%@,",error);
            NSLog(@"___错误信息___%@",error.userInfo);
        }
        
    }];
}

//不要进度条的请求
- (void)postReqeustWithURL:(NSString *)url
                 parametes:(id)parametes
              successBlock:(mySuccess)success
              failureBlock:(myFailure)failure{
    [self myParametes:parametes];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setRequestHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 100;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
     NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager POST:urlStr parameters:parametes progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

//表单提交
- (void)postFormDataReqeustWithURL:(NSString *)url
                 parametes:(id)parametes
              successBlock:(mySuccess)success
              failureBlock:(myFailure)failure
                showInView:(UIView *)view {
    [self myParametes:parametes];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setRequestHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 100;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
     NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager POST:urlStr parameters:parametes constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (error) {
            failure(error);
        }
    }];
}

- (void)postFormDataReqeustWithURL:(NSString *)url
                         parametes:(id)parametes
                      successBlock:(mySuccess)success
                      failureBlock:(myFailure)failure {
    [self myParametes:parametes];
    self.success = success;
    self.failure = failure;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setRequestHeader:manager];
    [self setRequestHeader:manager];
    AFJSONResponseSerializer *jsonSer =(AFJSONResponseSerializer*) manager.responseSerializer;
    jsonSer.removesKeysWithNullValues = YES;
    manager.requestSerializer.timeoutInterval = 100;
    NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
     NSLog(@"__链接__%@",urlStr);
    __weak typeof (self) weakSelf = self;
    [manager POST:urlStr parameters:parametes constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf myData:responseObject];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
    
}

@end
