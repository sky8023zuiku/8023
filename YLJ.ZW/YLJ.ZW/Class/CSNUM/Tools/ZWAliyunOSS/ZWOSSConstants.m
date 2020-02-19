//
//  ZWOSSConstants.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWOSSConstants.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import "ZWMineRqust.h"

static NSString *const BucketName = @"zhanwang";
static NSString *const Endpoint = @"http://oss-cn-shanghai.aliyuncs.com";
static NSString *kTempFolder = @"zwmds/2019_09_18_ios";

@interface ZWOSSConstants()

@property (strong, nonatomic) OSSClient *client;

@property (nonatomic, strong) OSSPutObjectRequest *normalUploadRequest;

@property (nonatomic, strong) OSSGetObjectRequest *normalDloadRequest;

@end

@implementation ZWOSSConstants
+ (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:YES complete:complete];
}
+ (void)syncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:NO complete:complete];
}
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:YES complete:complete];
}
+ (void)syncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:NO complete:complete];
}
+ (void)uploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [ZWOSSConstants takeOSSUploadToken:^(NSDictionary *data) {
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:data[@"accessKeyId"] secretKeyId:data[@"accessKeySecret"] securityToken:data[@"securityToken"]];
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:Endpoint credentialProvider:credential];
        
        NSLog(@"---我的taken：%@",data);
        NSLog(@"---我的键值：%@",data[@"accessKeyId"]);
        NSLog(@"---我的密码：%@",data[@"accessKeySecret"]);
        NSLog(@"---我的taken：%@",data[@"securityToken"]);
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = images.count;
        NSMutableArray *callBackNames = [NSMutableArray array];
        int i = 0;
        for (UIImage *image in images) {
            if (image) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    //任务执行
                    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                    put.bucketName = BucketName;
                    NSString *imageName = [kTempFolder stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                    put.objectKey = imageName;
                    [callBackNames addObject:imageName];
                    NSData *data = UIImageJPEGRepresentation(image, 0.3);
                    put.uploadingData = data;
                    OSSTask * putTask = [client putObject:put];
                    [putTask waitUntilFinished]; // 阻塞直到上传完成
                    if (!putTask.error) {
                        NSLog(@"upload object success!");
                    } else {
                        NSLog(@"upload object failed, error: %@" , putTask.error);
                    }
                    if (isAsync) {
                        if (image == images.lastObject) {
                            NSLog(@"upload object finished!");
                            if (complete) {
                                complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                            }
                        }
                    }
                }];
                if (queue.operations.count != 0) {
                    [operation addDependency:queue.operations.lastObject];
                }
                [queue addOperation:operation];
            }
            i++;
        }
        if (!isAsync) {
            [queue waitUntilAllOperationsAreFinished];
            NSLog(@"haha");
            if (complete) {
                if (complete) {
                    complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
                }
            }
        }
        
    } failure:^{
        
        
    }];
}
//获取token
+ (void)takeOSSUploadToken:(void (^)(NSDictionary *data))success failure:(void (^)(void))failure{

    ZWOSSTakenRequest *request = [[ZWOSSTakenRequest alloc]init];
    
    [request getRequestCompleted:^(YHBaseRespense *respense) {
        if (respense.isFinished) {
            success(respense.data);
        }else {
            NSLog(@"获取taken失败");
        }
    }];
    
}

+ (void)asyncDeleteImage:(NSString *)image complete:(void(^)(DeleteImageState state))complete {
    [self deleteImages:@[image] isAsync:YES complete:complete];
}

+ (void)syncDeleteImage:(NSString *)image complete:(void(^)(DeleteImageState state))complete {
    [self deleteImages:@[image] isAsync:NO complete:complete];
}

+ (void)asyncDeleteImages:(NSArray<NSString *> *)images complete:(void(^)(DeleteImageState state))complete {
    [self deleteImages:images isAsync:YES complete:complete];
}

+ (void)syncDeleteImages:(NSArray<NSString *> *)images complete:(void(^)(DeleteImageState state))complete {
    [self deleteImages:images isAsync:NO complete:complete];
}

+ (void)deleteImages:(NSArray<NSString *> *)imageNames isAsync:(BOOL)isAsync complete:(void(^)(DeleteImageState state))complete {
    
    [ZWOSSConstants takeOSSUploadToken:^(NSDictionary *data) {
        
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:data[@"accessKeyId"] secretKeyId:data[@"accessKeySecret"] securityToken:data[@"securityToken"]];
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:Endpoint credentialProvider:credential];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = imageNames.count;
        int i = 0;
        for (NSString *image in imageNames) {
            if (image) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    //任务执行
                    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
                    delete.bucketName = BucketName;
                    delete.objectKey = image;
                    
                    OSSTask * deleteTask = [client deleteObject:delete];
                    
                    [deleteTask continueWithBlock:^id(OSSTask *task) {
                        if (!task.error) {
                            
                        }
                        return nil;
                    }];

                    [deleteTask waitUntilFinished];
                    if (isAsync) {
                        if (image == imageNames.lastObject) {
                            NSLog(@"upload object finished!");
                            if (complete) {
                                complete(DeleteImageSuccess);
                            }
                        }
                    }
                }];
                if (queue.operations.count != 0) {
                    [operation addDependency:queue.operations.lastObject];
                }
                [queue addOperation:operation];
            }
            i++;
        }
        if (!isAsync) {
            [queue waitUntilAllOperationsAreFinished];
            NSLog(@"haha");
            if (complete) {
                if (complete) {
                    complete(DeleteImageSuccess);
                }
            }
        }
        
    } failure:^{
        
    }];
}

@end
