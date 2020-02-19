//
//  ZWBaseModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWBaseModel : NSObject <NSCopying,NSCoding>
/**
 *  将json字典转换成Model
 *
 *  @param jsonDic NSDictionary类型的json
 *
 *  @return model
 */
+ (id)ff_convertModelWithJsonDic:(NSDictionary *)jsonDic;

/**
 *  将json字符串转换成Model
 *
 *  @param jsonStr NSString类型的json
 *
 *  @return model
 */
+ (id)ff_convertModelWithJsonStr:(NSString *)jsonStr;

/**
 *  将json数组model化
 *
 *  @param jsonArr NSArray类型json
 *
 *  @return 包含model的NSArray
 */
+ (NSArray *)ff_convertModelWithJsonArr:(NSArray *)jsonArr;

#pragma mark - 在子类中实现以下方法
/**
 *  当 JSON 转为 Model 完成后，该方法会被调用,你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。你也可以在这里做一些自动转换不能完成的工作。
 *
 *  @param dic
 *
 *  @return
 */
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;

/**
 *  当 Model 转为 JSON 完成后，该方法会被调用。你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。 你也可以在这里做一些自动转换不能完成的工作
 *
 *  @param dic
 *
 *  @return
 */
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;

/**
 *  如果实现了该方法，则处理过程中会忽略该列表内的所有属性
 *
 *  @return
 */
//+ (NSArray *)modelPropertyBlacklist;

/**
 *  如果实现了该方法，则处理过程中不会处理该列表外的属性
 *
 *  @return
 */
//+ (NSArray *)modelPropertyWhitelist;

@end
@interface NSObject (ZWBaseModel)

/**
 *  将model转成json对象
 *
 *  @return NSDictionary 或 NSArray类型
 */
- (NSMutableDictionary *)ff_modelToJsonDictionary;


- (NSString *)ff_modelToJsonString;

@end

@interface NSString (YHBaseModel)

- (NSDictionary *)ff_stringToJsonDictionary;

@end

NS_ASSUME_NONNULL_END
