//
//  FFToolsUtils.h
//  Funmily
//
//  Created by kevin on 16/10/14.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFToolsUtils : NSObject
+(NSString *)nullString:(NSString*)str;
+(BOOL)isNullString:(id)str;
+ (BOOL)isNullOrSpaceString:(id)str;
+ (NSUInteger)unicodeLengthOfString:(NSString *)text;//计算字符串长度

@end
