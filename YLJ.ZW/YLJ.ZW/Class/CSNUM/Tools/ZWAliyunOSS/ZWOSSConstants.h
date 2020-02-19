//
//  ZWOSSConstants.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
typedef NS_ENUM(NSInteger, DeleteImageState) {
    DeleteImageFailed   = 0,
    DeleteImageSuccess  = 1
};

@interface ZWOSSConstants : NSObject
// 获取oss上传token
+ (void)takeOSSUploadToken:(void (^)(NSDictionary *data))success failure:(void (^)(void))failure;
//上传图片
+ (void)asyncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;

+ (void)syncUploadImage:(UIImage *)image complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;

+ (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

+ (void)syncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//删除图片
+ (void)asyncDeleteImage:(NSString *)image complete:(void(^)(DeleteImageState state))complete;

+ (void)syncDeleteImage:(NSString *)image complete:(void(^)(DeleteImageState state))complete;

+ (void)asyncDeleteImages:(NSArray<NSString *> *)images complete:(void(^)(DeleteImageState state))complete;

+ (void)syncDeleteImages:(NSArray<NSString *> *)images complete:(void(^)(DeleteImageState state))complete;

@end

NS_ASSUME_NONNULL_END
