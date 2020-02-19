//
//  ZWSaveIndustryScreenList.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSaveIndustryScreenList.h"

@implementation ZWSaveIndustryScreenList
static ZWSaveIndustryScreenList *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}
/**
 *   保存和获取行业三级筛选列表
 */
- (void)saveIndustriesListData:(NSArray *)level3Industries {
    
    NSMutableData *dataLevel3Industries = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataLevel3Industries];
    [archiver encodeObject:level3Industries forKey:@"level3Industries"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataLevel3Industries forKey:@"level3Industries"];
    [userDefaults synchronize];
    
}
- (NSArray *)takeLevel3Industries {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataLevel3Industries = [userDefaults dataForKey:@"level3Industries"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataLevel3Industries];
    NSArray *level3Industries = [unarchiver decodeObjectForKey:@"level3Industries"];
    [unarchiver finishDecoding];
    return level3Industries;
    
}
@end
