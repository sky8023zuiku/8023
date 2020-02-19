//
//  ZWRequestAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^mySuccess)(NSDictionary *data);
typedef void (^myFailure)(NSError *error);

@interface ZWDataAction : NSObject

@property(nonatomic, copy)mySuccess success;
@property(nonatomic, copy)myFailure failure;
//单例
+ (instancetype)sharedAction;

//get请求
- (void)getReqeustWithURL:(NSString *)url
                parametes:(id)parametes
             successBlock:(mySuccess)success
             failureBlock:(myFailure)failure
               showInView:(UIView *)view;

- (void)getReqeustWithURL:(NSString *)url
                parametes:(id)parametes
             successBlock:(mySuccess)success
             failureBlock:(myFailure)failure;


//post请求
- (void)postReqeustWithURL:(NSString *)url
                 parametes:(id)parametes
              successBlock:(mySuccess)success
              failureBlock:(myFailure)failure
                showInView:(UIView *)view;

- (void)postReqeustWithURL:(NSString *)url
                 parametes:(id)parametes
              successBlock:(mySuccess)success
              failureBlock:(myFailure)failure;

//表单提交
- (void)postFormDataReqeustWithURL:(NSString *)url
                         parametes:(id)parametes
                      successBlock:(mySuccess)success
                      failureBlock:(myFailure)failure
                        showInView:(UIView *)view;

- (void)postFormDataReqeustWithURL:(NSString *)url
                         parametes:(id)parametes
                      successBlock:(mySuccess)success
                      failureBlock:(myFailure)failure;



@end

NS_ASSUME_NONNULL_END
