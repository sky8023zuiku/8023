//
//  ZWExhibitorsSaveLocation.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitorsSaveLocation : NSObject
+ (instancetype)shareAction;
/**
 *   保存行业展商详情
 */
- (void)saveExhibitorsDetails:(NSDictionary *)detailsData;
- (NSDictionary *)takeExhibitorsDetailsData;
/**
 *   保存行业展商产品展示
 */
- (void)saveExhibitorsProductList:(NSArray *)productData;
- (NSArray *)takeExhibitorsProductListData;
/**
 *   保存行业展商动态列表
 */
- (void)saveExhibitorsDynamicList:(NSDictionary *)dynamicData;
- (NSDictionary *)takeExhibitorsDynamicListData;
/**
 *   保存行业展商联系方式列表
 */
- (void)saveExhibitorsContactList:(NSArray *)contactData;
- (NSArray *)takeExhibitorsContactListData;

@end

NS_ASSUME_NONNULL_END
