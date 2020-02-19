//
//  ZWMainSaveLocation.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/15.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMainSaveLocation : NSObject
+ (instancetype)shareAction;
/**
 *   保存国家数据
 */
- (void)saveCountroiesList:(NSArray *)countroies;
- (NSArray *)takeCountroiesListData;
/**
 *   保存城市数据
 */
- (void)saveCitiesList:(NSArray *)cities;
- (NSArray *)takeCitiesListData;
/**
 *   保存行业数据
 */
- (void)saveIndustriesList:(NSArray *)industries;
- (NSArray *)takeIndustriesListData;
@end

NS_ASSUME_NONNULL_END
