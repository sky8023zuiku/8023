//
//  ZWToolActon.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWToolActon.h"

@implementation ZWToolActon

static ZWToolActon *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}

/**
 *      Label自适应
 */
-(CGFloat)adaptiveTextHeight:(NSString *)text {
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 5000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

-(CGFloat)adaptiveTextHeight:(NSString *)text textFont:(UIFont *)font textWidth:(CGFloat)width {
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

-(CGFloat)adaptiveTextHeight:(NSString *)text font:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

-(CGFloat)adaptiveTextWidth:(NSString *)text {
    
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 5000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return width;
}

-(CGFloat)adaptiveTextWidth:(NSString *)labelText labelFont:(UIFont *)font {
    
    CGSize size = [labelText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat width = size.width;
    return width;
}

- (NSString *)transformArr:(NSArray *)array {
    
    if (![array count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[array description] stringByReplacingOccurrencesOfString:@"\\u"
                                                   withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
    
}

- (NSString *)transformDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

/**
 * 倒计时
 */
- (void)theCountdownforTime:(NSInteger)minutes whthColor:(UIColor *)color withButton:(UIButton *)btn {
    __block NSInteger timeout=minutes; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [btn setTitleColor:color forState:UIControlStateNormal];
                btn.layer.borderColor = color.CGColor;
                btn.userInteractionEnabled = YES;
            });
        }else{
            NSInteger seconds = timeout % (minutes+1);
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [UIView animateWithDuration:1 animations:^{
                    [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                }];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  判断是否是手机号码
 */
- (BOOL)valiMobile:(NSString *)mobile
{
    if (mobile.length != 11) {
        return NO;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|8[0-9]|9[89]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobile];
}

/**
 *  判断是否是手机号码(国际版)
 */
- (BOOL)isMobileGuoJi:(NSString *)mobileNumbel{
    NSString *aaa = @"^\\s*\\+?\\s*(\\(\\s*\\d+\\s*\\)|\\d+)(\\s*-?\\s*(\\(\\s*\\d+\\s*\\)|\\s*\\d+\\s*))*\\s*$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aaa];
    if (([regextestct evaluateWithObject:mobileNumbel]
         )) {
        return YES;
    }
    return NO;
}

/**
 *  转换不规则的网络链接
 */
- (NSString *)transcodWithUrl:(NSString *)url {
    NSString *encodeStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    return encodeStr;
}


- (NSString *)getTimeFromTimestamp:(NSNumber *)stamp withDataStr:(NSString *)format{
    NSLog(@"-------%@",stamp);
    NSString *str = [stamp stringValue];
    double time;
    if (str.length>10) {
        time = [stamp doubleValue]/1000;
    }else {
        time = [stamp doubleValue];
    }
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

/**
 *  设置两端对齐
*/
- (NSMutableAttributedString *)createBothEndsWithLabel:(UILabel *)label textAlignmentWith:(CGFloat)width {
    
    if(label.text==nil||label.text.length==0) {
        return nil;
    }
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size;
    NSInteger length = (label.text.length-1);
    NSString* lastStr = [label.text substringWithRange:NSMakeRange(label.text.length-1,1)];
    if([lastStr isEqualToString:@":"]||[lastStr isEqualToString:@"："]) {
        length = (label.text.length-2);
    }
    CGFloat margin = (width - size.width)/length;
    NSNumber*number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,length)];
    return attribute;
    
}

/**
 *  字符串转数组
*/
- (NSArray *)strTurnArrayWithString:(NSString *)string {
    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray  *array = [strUrl componentsSeparatedByString:@","];
    return array;
}

- (void)dialTheNumber:(NSString *)number {
    NSLog(@"我的电话号码 = %@",number);
    NSString *subNumber = [self removeSpaceAndNewline:number];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",subNumber];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"OpenSuccess=%d",success);
        }];
    } else {
        [application openURL:URL];
    }
}
//去掉所有空格和字符串
- (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

//改变图片的颜色
- (UIImage *)modifyTheColorWithImageName:(NSString *)imageName imageColor:(UIColor *)imageColor {
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [imageColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
    
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
