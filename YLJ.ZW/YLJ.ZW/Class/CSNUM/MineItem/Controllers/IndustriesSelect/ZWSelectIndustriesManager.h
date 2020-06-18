//
//  ZWSelectIndustriesManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSelectIndustriesManager : NSObject

@property(nonatomic, assign)NSInteger *selectNumber;//选择的数量
@property(nonatomic, strong)NSArray *industries;//选择后的数组

@end

NS_ASSUME_NONNULL_END
