//
//  ZWModelToolAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/23.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWModelToolAction.h"

@implementation ZWModelToolAction

static ZWModelToolAction *shareAction = nil;

+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}


- (id)arrayOrDicWithObject:(id)origin {
   if ([origin isKindOfClass:[NSArray class]]) {
       //数组
       NSMutableArray *array = [NSMutableArray array];
       for (NSObject *object in origin) {
           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
               //string , bool, int ,NSinteger
               [array addObject:object];

           } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
               //数组或字典
               [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];

           } else {
               //model
               [array addObject:[self dicFromObject:object]];
           }
       }

       return [array copy];

   } else if ([origin isKindOfClass:[NSDictionary class]]) {
       //字典
       NSDictionary *originDic = (NSDictionary *)origin;
       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       for (NSString *key in originDic.allKeys) {
           id object = [originDic objectForKey:key];

           if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
               //string , bool, int ,NSinteger
               [dic setObject:object forKey:key];

           } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
               //数组或字典
               [dic setObject:[self arrayOrDicWithObject:object] forKey:key];

           } else {
               //model
               [dic setObject:[self dicFromObject:object] forKey:key];
           }
       }

       return [dic copy];
   }

   return [NSNull null];
}


//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
 
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
 
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
 
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
 
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
 
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
        
    }
    return [dic copy];
}

@end
