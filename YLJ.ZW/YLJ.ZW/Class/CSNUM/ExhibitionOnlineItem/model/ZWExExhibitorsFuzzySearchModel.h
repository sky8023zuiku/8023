//
//  ZWExExhibitorsFuzzySearchModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExExhibitorsFuzzySearchModel : NSObject
@property(nonatomic, copy)NSString *merchantId;//列表id
@property(nonatomic, copy)NSString *merchantName;//展会展商id
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
