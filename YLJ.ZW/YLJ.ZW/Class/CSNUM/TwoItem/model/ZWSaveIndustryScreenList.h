//
//  ZWSaveIndustryScreenList.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSaveIndustryScreenList : NSObject
+ (instancetype)shareAction;
/**
 *   保存和获取行业三级筛选列表
 */
- (void)saveIndustriesListData:(NSArray *)level3Industries;
- (NSArray *)takeLevel3Industries;
@end

NS_ASSUME_NONNULL_END
