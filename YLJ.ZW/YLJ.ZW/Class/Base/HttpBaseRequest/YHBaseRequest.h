//
//  YHBaseRequest.h
//  YHEnterpriseB2B
//
//  Created by zhangyong on 2019/1/16.
//  Copyright © 2019年 yh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHRequestValidDelegate.h"
#import "YHConfigUrl.h"

@class YHBaseRespense;


typedef void (^DataCompletionBlock)(YHBaseRespense *respense);


@interface YHBaseRequest : NSObject<YHRequestValidDelegate>

@property (nonatomic, copy) NSString *url;

/**
 *  是否显示 加载HUD 默认不显示 。默认为YES
 */
@property (nonatomic, assign,getter=isShowProgressHUD) BOOL showProgressHUD;

/**
 *  是否显示 错误提示 。默认为YES
 */
@property (nonatomic, assign,getter=isShowErrorMsg) BOOL showErrorMsg;

/**
 *  是否显示 无网提示 。默认为NO
 */
@property (nonatomic, assign,getter=isShowNoNetMsg) BOOL showNoNetMsg;

/**
 *  通过字典模型 创建对象
 */
+(instancetype)createWithParams:(NSDictionary*)params;
/**
 *  获取参数列表
 */
-(NSDictionary *)getParams;
/**
 get请求
 
 @param respenseBlock 请求完成回调
 */
- (void)getRequestCompleted:(DataCompletionBlock)respenseBlock;

/**
 *  发送网络请求
 *
 *  @param respenseBlock 请求完成回调
 */
- (void)postRequestCompleted:(DataCompletionBlock)respenseBlock;

- (void)postFormDataWithProgress:(NSData*)data RequestCompleted:(DataCompletionBlock)respenseBlock;
/**
 *  发送网络请求,在UIViewController dealloc 时 自动销毁，vc block使用@weak(self),@strong(self).
 *
 *  @param respenseBlock 请求完成回调
 */
- (void)postRequestinVC:(UIViewController *)vc completed:(DataCompletionBlock)respenseBlock;

/**
 *  取消请求
 */
- (void)cancelRequest;

-(NSURLSessionTask *)getCurrentTask;

//后续加入 本地缓存。
@end


typedef NS_ENUM(NSInteger,RespenseType) {
    RespenseTypeNone,
    RespenseTypeSuccess,
    RespenseTypeFailed,
    RespenseTypeError,
    RespenseTypeOther
};
@interface YHBaseRespense : NSObject

@property (nonatomic, assign,readonly,getter=isFinished) BOOL finished;
@property (nonatomic, assign,readonly,getter=isFailed) BOOL failed;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id result;
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger code;//200成功
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) RespenseType type;


@end
