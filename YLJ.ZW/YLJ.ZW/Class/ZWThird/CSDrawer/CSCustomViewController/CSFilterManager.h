//
//  CSFilterManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CSFilterManagerDelegate <NSObject>

- (void)takeFilterData:(NSDictionary *)data;

@end

@interface CSFilterManager : NSObject

@property(nonatomic, strong)id<CSFilterManagerDelegate> delegate;

@property(nonatomic, strong)NSDictionary *selectDictionary;//记录被选中的字典

+ (instancetype)shareManager;
//国家，城市，行业，年，月
- (void)showFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data;
//行业，国家，城市
- (void)showExhibitorsFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data;
//国家，城市，行业
- (void)showPlanExhibitionFilterMenu:(UIViewController *)viewController setSelectedData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
