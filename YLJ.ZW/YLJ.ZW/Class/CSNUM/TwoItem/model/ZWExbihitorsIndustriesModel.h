//
//  ZWExbihitorsIndustriesModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/15.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExbihitorsIndustriesModel : NSObject
@property(nonatomic, copy)NSString *secondIndustryName;//二级行业名称
@property(nonatomic, copy)NSString *secondIndustryId;//二级行业id
@property(nonatomic, copy)NSString *thirdIndustryName;//三级行业名称
@property(nonatomic, copy)NSString *thirdIndustryId;//三级行业id
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
