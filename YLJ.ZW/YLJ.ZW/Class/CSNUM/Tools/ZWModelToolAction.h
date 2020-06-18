//
//  ZWModelToolAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/23.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWModelToolAction : NSObject
+ (instancetype)shareAction;
//模型转换成字典
- (NSDictionary *)dicFromObject:(NSObject *)object;
@end

NS_ASSUME_NONNULL_END
