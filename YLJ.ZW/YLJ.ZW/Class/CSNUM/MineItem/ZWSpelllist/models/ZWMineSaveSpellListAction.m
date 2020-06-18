//
//  ZWMineSaveSpellListAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/10.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineSaveSpellListAction.h"

@implementation ZWMineSaveSpellListAction
static ZWMineSaveSpellListAction *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}
/**
 *   保存获取木结构拼单
 */
- (void)saveOneSpellList:(NSDictionary *)spellListData {
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListOne"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListOne"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeOneSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListOne"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListOne"];
    [unarchiver finishDecoding];
    return spellListData;
}

- (void)removeOneSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListOne"];
}

/**
 *   保存和获取桁架拼单
 */
- (void)saveTwoSpellList:(NSDictionary *)spellListData{
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListTwo"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListTwo"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeTwoSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListTwo"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListTwo"];
    [unarchiver finishDecoding];
    return spellListData;
}
- (void)removeTwoSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListTwo"];
}

/**
 *   保存和获取型材铝料拼单
 */
- (void)saveThreeSpellList:(NSDictionary *)spellListData{
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListThree"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListThree"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeThreeSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListThree"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListThree"];
    [unarchiver finishDecoding];
    return spellListData;
}
- (void)removeThreeSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListThree"];
}

/**
 *   保存和获取看馆拼单
 */
- (void)saveFourSpellList:(NSDictionary *)spellListData{
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListFour"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListFour"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeFourSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListFour"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListFour"];
    [unarchiver finishDecoding];
    return spellListData;
}

- (void)removeFourSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListFour"];
}

/**
 *   保存和获取保险拼单
 */
- (void)saveFiveSpellList:(NSDictionary *)spellListData{
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListFive"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListFive"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeFiveSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListFive"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListFive"];
    [unarchiver finishDecoding];
    return spellListData;
}

- (void)removeFiveSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListFive"];
}
/**
 *   保存和获取货车拼单
 */
- (void)saveSixSpellList:(NSDictionary *)spellListData{
    NSMutableData *dataSpellList = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataSpellList];
    [archiver encodeObject:spellListData forKey:@"SpellListSix"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dataSpellList forKey:@"SpellListSix"];
    [userDefaults synchronize];
}

- (NSDictionary *)takeSixSpellList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSpellList = [userDefaults dataForKey:@"SpellListSix"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataSpellList];
    NSDictionary *spellListData = [unarchiver decodeObjectForKey:@"SpellListSix"];
    [unarchiver finishDecoding];
    return spellListData;
}

- (void)removeSixSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListSix"];
}

- (void)removeAllSpellList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListOne"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListTwo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListThree"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListFour"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListFive"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpellListSix"];
}

@end
