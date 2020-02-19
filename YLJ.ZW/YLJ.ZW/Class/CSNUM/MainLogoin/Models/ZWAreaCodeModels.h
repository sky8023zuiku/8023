//
//  ZWAreaCodeModels.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWAreaCodeModels : NSObject

@property(nonatomic, strong)NSString *country;//国家
@property(nonatomic, strong)NSString *pretel;//编号
@property(nonatomic, strong)NSString *initial;//标题
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
