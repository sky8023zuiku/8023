//
//  ZWSaveTransactionReceipt.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/31.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSaveTransactionReceipt.h"

@implementation ZWSaveTransactionReceipt
static ZWSaveTransactionReceipt *shareReceipt = nil;
+ (instancetype)shareReceipt{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareReceipt = [[self alloc] init];
    });
    return shareReceipt;
}
/**
 *  保存苹果支付凭据
*/
- (void)saveUserReceipt:(NSDictionary *)receipt {
    NSMutableData *dataReceipt = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataReceipt];
    [archiver encodeObject:receipt forKey:@"receipt"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataReceipt forKey:@"receipt"];
    [userDefaults synchronize];
}
- (NSDictionary *)takeUserReceipt {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataReceipt = [userDefaults dataForKey:@"receipt"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataReceipt];
    NSDictionary *receiptData = [unarchiver decodeObjectForKey:@"receipt"];
    [unarchiver finishDecoding];
    return receiptData;
}

- (void)removeLocation{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"receipt"];
}
@end
