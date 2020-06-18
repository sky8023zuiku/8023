//
//  ZWAreaManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWAreaManagerDelegate <NSObject>

- (void)accessToAreas:(NSDictionary *)dic;

@end

@interface ZWAreaManager : NSObject

+ (instancetype)shareManager;

@property(nonatomic, strong)id<ZWAreaManagerDelegate> delegate;

- (void)areaSelectionShow:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
