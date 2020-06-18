//
//  ZWMineSaveSpellListAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/10.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMineSaveSpellListAction : NSObject
+ (instancetype)shareAction;
/**
 *    保存获取木结构拼单
*/
- (void)saveOneSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeOneSpellList;
- (void)removeOneSpellList;

/**
 *    保存获取木结构拼单
*/
- (void)saveTwoSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeTwoSpellList;
- (void)removeTwoSpellList;


/**
 *    保存获取木结构拼单
*/
- (void)saveThreeSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeThreeSpellList;
- (void)removeThreeSpellList;

/**
 *    保存获取木结构拼单
*/
- (void)saveFourSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeFourSpellList;
- (void)removeFourSpellList;

/**
 *    保存获取木结构拼单
*/
- (void)saveFiveSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeFiveSpellList;
- (void)removeFiveSpellList;

/**
 *    保存获取木结构拼单
*/
- (void)saveSixSpellList:(NSDictionary *)spellListData;
- (NSDictionary *)takeSixSpellList;
- (void)removeSixSpellList;

/**
 *    删除本地所有拼单
*/
- (void)removeAllSpellList;

@end

NS_ASSUME_NONNULL_END
