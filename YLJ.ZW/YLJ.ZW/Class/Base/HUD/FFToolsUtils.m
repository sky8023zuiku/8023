//
//  FFToolsUtils.m
//  Funmily
//
//  Created by kevin on 16/10/14.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import "FFToolsUtils.h"

@implementation FFToolsUtils


+ (NSString *)nullString:(NSString*)str
{
    if ([self isNullString:str]) {
        str = @"";
    }
    return str;
}

+ (BOOL)isNullString:(id)str
{
    if(str == nil || [str isEqual:@"<null>"] || [str isEqual:[NSNull null]] || [str isEqual:@"null"] || [str isEqual:@"(null)"] || [str isEqual:@"NULL"]) return YES;
    return NO;
}

+ (BOOL)isNullOrSpaceString:(id)str
{
    if(str == nil || [str isEqual:@"<null>"] || [str isEqual:[NSNull null]] || [str isEqual:@"null"] || [str isEqual:@"(null)"] || [str isEqual:@"NULL"] || [str isEqual:@""])
        return YES;
    if ([str isKindOfClass:[NSString class]] && [str rangeOfString:@"null null"].length>1) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)unicodeLengthOfString:(NSString *)text {
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    /*NSUInteger unicodeLength = asciiLength / 2;
     if(asciiLength % 2) {
     unicodeLength++;
     }*/
    
    return asciiLength;
}
@end
