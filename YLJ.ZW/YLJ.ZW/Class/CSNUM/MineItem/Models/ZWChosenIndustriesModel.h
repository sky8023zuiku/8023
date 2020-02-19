//
//  ZWChosenIndustriesModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/10.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWChosenIndustriesModel : NSObject
@property(nonatomic, strong)NSNumber *industries2Id;//二级行业id
@property(nonatomic, strong)NSString *industries2Name;//二级行业的名称
@property(nonatomic, strong)NSNumber *industries3Id;//三级行业的id
@property(nonatomic, strong)NSString *industries3Name;//三级行业的名称
@end

NS_ASSUME_NONNULL_END
