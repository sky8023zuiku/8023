//
//  YHBaseRequest.m
//  YHEnterpriseB2B
//
//  Created by zhangyong on 2019/1/16.
//  Copyright © 2019年 yh. All rights reserved.
//

#import "YHBaseRequest.h"
#import "HYBNetworking.h"
#import <YYModel.h>

#import "YHRequestHeaderConfig.h"
//#import "NSString+FFString.h"

#import "AFURLResponseSerialization.h"

#import "FFRequestHUD.h"
#import "AFNetworkReachabilityManager.h"

#import "FFProgressHUD.h"

@interface YHBaseRequest()

@property (nonatomic , weak) HYBURLSessionTask *urlSession;


- (void)postWithParams:(NSDictionary *)params requestCompleted:(DataCompletionBlock)respenseBlock;



+ (void)cancelRequestWithUrl:(NSString *)url;

+ (void)cancelRequestAll;


@end

static NSMutableDictionary *cancelVCDic;

@implementation YHBaseRequest

+(void)load {
    [HYBNetworking configRequestType:kHYBRequestTypeJSON responseType:kHYBResponseTypeJSON shouldAutoEncodeUrl:NO callbackOnCancelRequest:NO];
    [HYBNetworking enableInterfaceDebug:NO];
}

-(instancetype)init
{
    self = [super init];
    [self setDefault];
    return self;
}
-(void)setDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cancelVCDic = [NSMutableDictionary dictionaryWithCapacity:1];
    });
    _url = [self requestUrl];
    _showProgressHUD = YES;
    _showErrorMsg = YES;
    _showNoNetMsg = NO;
    [self setupData];
}
-(void)setupData
{
    
}

-(NSString *)requestUrl
{
    return [[self requestHandler] stringByAppendingString:[self requestMethod]];
}

-(NSString *)requestHandler
{
    return nil;
}
-(NSString *)requestMethod
{
    return nil;
}

+(NSArray *)getIgnoredKeys
{
    return @[];
}

/**
 *  2016-09-01 14:14:06 突然出现bug 待解决 及使用 YYModel 替换
 */
+(NSMutableArray *)mj_totalIgnoredPropertyNames
{
    return @[@"url",@"showProgressHUD",@"showErrorMsg",@"showNoNetMsg",@"debugDescription",@"description",@"hash",@"superclass",@"urlSession"].mutableCopy;
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    NSArray *ignoredArr = [self getIgnoredKeys];
    NSArray *baseArr = [self mj_totalIgnoredPropertyNames];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:baseArr];
    [mArr addObjectsFromArray:ignoredArr];
    return mArr.copy;
}


-(NSDictionary *)getParams
{
    NSMutableDictionary *paramDic = [self yy_modelToJSONObject];
    return paramDic.copy;
}

+(instancetype)createWithParams:(NSDictionary*)params
{
    YHBaseRequest *ins = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        ins = [self yy_modelToJSONObject];
    }
    return ins;
}

- (void)getRequestCompleted:(DataCompletionBlock)respenseBlock{
    
    [self addHeaderParam];
    NSDictionary *params = [self getParams];
    BOOL showHUD = _showProgressHUD;
    if (showHUD) {
        [[FFRequestHUD sharedRequestHUD] showRequestBusying];
    }
    [self getWithUrl:_url Param:params completed:^(YHBaseRespense *respense) {
        if (showHUD) {
            [[FFRequestHUD sharedRequestHUD] hideRequestBusying];
        }
        respenseBlock(respense);
    }];
}

- (void)postRequestCompleted:(DataCompletionBlock)respenseBlock
{
    [self addHeaderParam];
    [self requestValidator];
    NSDictionary *params = [self getParams];
    NSLog(@"%@",params);
    BOOL showHUD = _showProgressHUD;
    if (showHUD) {
        [[FFRequestHUD sharedRequestHUD] showRequestBusying];
    }
    //    [MobClick beginEvent:@"request_duration" label:self.url];
    //    NSInteger rDuration = [NSDate date].timeIntervalSinceReferenceDate * 1000;
    [self postWithUrl:self.url params:params completed:^(YHBaseRespense *respense) {
        //        int dd =  [NSDate date].timeIntervalSinceReferenceDate * 1000 - rDuration;
        //        NSLog(@"统计时长:%zd",dd);
        //        [MobClick event:@"request_duration" label:self.url durations:dd] ;
        //        if(self.url){
        //            [MobClick event:@"request_duration" attributes:@{@"url" : self.url} counter:dd];
        //            [MobClick event:@"request_duration" attributes:@{@"url" : self.url} durations:dd];
        //        }
        //        [MobClick endEvent:@"request_duration" label:self.url];
        if (showHUD) {
            [[FFRequestHUD sharedRequestHUD] hideRequestBusying];
        }
        respenseBlock(respense);
    }];
}

- (void)postFormDataWithProgress:(NSData*)data RequestCompleted:(DataCompletionBlock)respenseBlock
{
    [self addHeaderParam];
    [self requestValidator];
    NSDictionary *params = [self getParams];
    
    BOOL showHUD = _showProgressHUD;
    if (showHUD) {
        [[FFRequestHUD sharedRequestHUD] showRequestBusying];
    }
    //    [MobClick beginEvent:@"request_duration" label:self.url];
    //    NSInteger rDuration = [NSDate date].timeIntervalSinceReferenceDate * 1000;
    [self postFormDataWithUrl:self.url params:params data:data completed:^(YHBaseRespense *respense) {
        if (showHUD) {
            [[FFRequestHUD sharedRequestHUD] hideRequestBusying];
        }
        respenseBlock(respense);
    }];

}

- (void)postWithParams:(NSDictionary *)params requestCompleted:(DataCompletionBlock)respenseBlock
{
    [self postWithUrl:self.url params:params completed:^(YHBaseRespense *respense) {
        respenseBlock(respense);
    }];
}

- (void)postRequestinVC:(UIViewController *)vc completed:(DataCompletionBlock)respenseBlock
{
    NSString *vcStr = [NSString stringWithFormat:@"%p",vc];
    [cancelVCDic setValue:self forKey:vcStr];
    [self postRequestCompleted:^(YHBaseRespense *respense) {
        [cancelVCDic removeObjectForKey:vcStr];
        respenseBlock(respense);
    }];
}

- (void)cancelRequest
{
    if (_urlSession) {
        if (_showProgressHUD) {
            [[FFRequestHUD sharedRequestHUD] hideRequestBusying];
        }
        [HYBNetworking cancelRequestWithTask:_urlSession];
        _urlSession = nil;
    }
}

+ (void)cancelRequestWithUrl:(NSString *)url
{
    [HYBNetworking cancelRequestWithURL:url];
}

+ (void)cancelRequestAll
{
    [HYBNetworking cancelAllRequest];
}

- (HYBURLSessionTask *)getWithUrl:(NSString*)url
                            Param:(NSDictionary *)param
                        completed:(DataCompletionBlock)successBlock
{
    
    url = _url;
    [HYBNetworking cacheGetRequest:NO shoulCachePost:NO];
    HYBURLSessionTask *task = [HYBNetworking getWithUrl:url refreshCache:YES params:param success:^(id response) {
        successBlock([self parseRespense:response]);
    } fail:^(NSError *error) {
        successBlock([self parseNetworkError:error]);
    }];
    //    HYBURLSessionTask *task = [HYBNetworking getWithUrl:url refreshCache:YES success:^(id response) {
    //        successBlock([self parseRespense:response]);
    //    } fail:^(NSError *error) {
    //        successBlock([self parseNetworkError:error]);
    //    }];
    _urlSession = task;
    return task;
}




- (HYBURLSessionTask *)postWithUrl:(NSString*)url params:(id )params completed:(DataCompletionBlock)successBlock
{
    
    NSDictionary *paramDic;
    if ([params isKindOfClass:[YHBaseRequest class]]) {
        paramDic = [(YHBaseRequest*)(params) getParams];
    }else{
        paramDic = [params copy];
    }
    
    NSDictionary *addParams = [self addDefaultParams];
    if (addParams) {
        NSMutableDictionary *tempDic = [paramDic mutableCopy];
        [tempDic addEntriesFromDictionary:addParams];
        paramDic = [tempDic copy];
    }
    
    url = _url;
    
    
    HYBURLSessionTask *task = [HYBNetworking postWithUrl:url refreshCache:NO params:paramDic success:^(id response) {
        successBlock([self parseRespense:response]);
    } fail:^(NSError *error) {
        successBlock([self parseNetworkError:error]);
    }];
    _urlSession = task;
    return task;
}
- (HYBURLSessionTask *)postFormDataWithUrl:(NSString*)url params:(id )params data:(NSData*)data completed:(DataCompletionBlock)successBlock
{
    
    NSDictionary *paramDic;
    if ([params isKindOfClass:[YHBaseRequest class]]) {
        paramDic = [(YHBaseRequest*)(params) getParams];
    }else{
        paramDic = [params copy];
    }
    
    NSDictionary *addParams = [self addDefaultParams];
    if (addParams) {
        NSMutableDictionary *tempDic = [paramDic mutableCopy];
        [tempDic addEntriesFromDictionary:addParams];
        paramDic = [tempDic copy];
    }
    
    url = _url;
    
    HYBURLSessionTask *task = [HYBNetworking postFormData:url refreshCache:YES data:data params:params success:^(id response) {
        successBlock([self parseRespense:response]);
    } fail:^(NSError *error) {
        successBlock([self parseNetworkError:error]);
    }];
    
    _urlSession = task;
    return task;
}

-(NSURLSessionTask *)getCurrentTask{
    return (NSURLSessionTask *)_urlSession;
}

#pragma mark - normal response
- (YHBaseRespense *)parseRespense:(id)info
{
    if (![info isKindOfClass:[NSDictionary class]]) {
        return [YHBaseRespense new];
    }
    
    // success
    NSInteger code = [info[@"status"] integerValue];
    
    if (code == 200||code == 205) {
        YHBaseRespense *baseRespense = [YHBaseRespense new];
        id itemsDic = [info objectForKey:@"result"];
        baseRespense.result = itemsDic;
        id dataDic = [info objectForKey:@"data"];
        NSString *errMsg = [NSString stringWithFormat:@"%@",info[@"msg"]];
        baseRespense.message = errMsg;
        baseRespense.data = dataDic;
        baseRespense.type = RespenseTypeSuccess;
        return [self parseRespenseData:baseRespense];
    }
    
    // fail
    return [self parseFailResponse:info];
}

#pragma mark - response fail
- (YHBaseRespense *)parseFailResponse:(NSDictionary *)info {
    BOOL shouldShowErr = YES;
    YHBaseRespense *baseRespense = [YHBaseRespense new];
    NSInteger code = [info[@"status"] integerValue];
    NSString *errMsg = [NSString stringWithFormat:@"%@",info[@"msg"]];
    baseRespense.code = code;
    baseRespense.message = errMsg;
    baseRespense.result = info;
    baseRespense.data = info;
    baseRespense.type = RespenseTypeFailed;
//    if (code == -1) {
//    errMsg = @"系统异常";
//    }
    
    if (_showErrorMsg && shouldShowErr) {
//        [[FFProgressHUD sharedProgressHUD] toastTitle:[NSString stringWithFormat:@"%@\n(code:%zd)",errMsg,code]];
//        [[FFProgressHUD sharedProgressHUD] toastTitle:[NSString stringWithFormat:@"%@",errMsg]];
        //********************************************有改动*************************************************/
        NSLog(@"%@",[NSString stringWithFormat:@"--%@",errMsg]);
        if ([errMsg isEqualToString:@"账号在别处登录，请重新登录或修改密码"]||[errMsg isEqualToString:@"请重新登录"]||[errMsg isEqualToString:@"请先登录"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"beBroughtUp" object:nil];
        }
    }
    
    return [self parseRespenseData:baseRespense];
}

#pragma mark - network Error
- (YHBaseRespense *)parseNetworkError:(NSError *)error {
    YHBaseRespense *baseRespense = [YHBaseRespense new];
    baseRespense.error = error;
    baseRespense.type = RespenseTypeError;
    NSInteger statusCode = [self getStatusCodeFromError:error];
    baseRespense.code = statusCode;
    NSString *errMsg = @"网络异常";
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        errMsg = @"无法连接到网络，请稍后再试";
    }else if (error.code == NSURLErrorTimedOut) {
        errMsg = @"请求超时,请稍后再试";
    }
    baseRespense.message = errMsg;
    if (_showNoNetMsg) {
        [[FFProgressHUD sharedProgressHUD] toastTitle:[NSString stringWithFormat:@"%@(code:%ld)",errMsg,(long)statusCode]];
//        NSLog(@"%@",[NSString stringWithFormat:@"%@(code:%ld)",errMsg,(long)statusCode]);
    }
    return baseRespense;
}

-(NSInteger)getStatusCodeFromError:(NSError*)error
{
    NSError *responseError = error.userInfo[@"NSUnderlyingError"];
    NSHTTPURLResponse *response = responseError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger statusCode = 0;
    if (response) {
        statusCode = response.statusCode;
        if (statusCode == 0) {
            statusCode = -1;
        }
    }else{
        statusCode = error.code;
    }
    return statusCode;
}

-(void)addHeaderParam
{
    NSDictionary *paramDic = [[YHRequestHeaderConfig shareConfig] appendHeadersWithUrl:_url];
    [HYBNetworking configCommonHttpHeaders:paramDic];
    [HYBNetworking setTimeout:defaultTimeOut];
}
-(void)resetHeaderParam
{
    [HYBNetworking configCommonHttpHeaders:nil];
    [HYBNetworking setTimeout:defaultTimeOut];
}

- (BOOL)requestValidator {
    return YES;
}

-(NSDictionary *)addDefaultParams
{
    return nil;
}


- (YHBaseRespense *)parseRespenseData:(YHBaseRespense *)baseRespense
{
    return baseRespense;
}
-(void)dealloc
{
    //    DDLogWarn(@"%@---dealloc",NSStringFromClass([self class]));
}

@end

@implementation YHBaseRespense

-(BOOL)isFinished
{
    return _type == RespenseTypeSuccess;
}
-(BOOL)isFailed
{
    return _type == RespenseTypeFailed;
}


//-(void)dealloc
//{
//    NSLog(@"%@---dealloc",NSStringFromClass([self class]));
//}

@end



@interface UIViewController (RequestDealloc)

@end

@implementation UIViewController (RequestDealloc)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController swizzling];
    });
}

+ (void)swizzling
{
    
    Class class = [self class];
    
    SEL originalSelector = NSSelectorFromString(@"dealloc");
    SEL swizzledSelector = @selector(request_dealloc);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)request_dealloc{
    //    NSLog(@"-------------%@----------------",NSStringFromClass([self class]));
    YHBaseRequest *request = [cancelVCDic objectForKey:[NSString stringWithFormat:@"%p",self]];
    if (request) {
        [request cancelRequest];
        request = nil;
    }
    [self request_dealloc];
}
@end
