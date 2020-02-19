//
//  ZWInduExhibitorsModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWInduExhibitorsModel : NSObject
@property(nonatomic, copy)NSString *merchantId;//行业展商id
@property(nonatomic, copy)NSString *product;//主营
@property(nonatomic, copy)NSNumber *collection;//是否收藏
@property(nonatomic, copy)NSString *imageUrl;//行业展商标题图
@property(nonatomic, copy)NSString *vipVersion;//0为普通 1为vip 2为svip
@property(nonatomic, copy)NSString *requirement;//需求
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *seq;//
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
