//
//  ZWExhPlanDetailModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/8.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhPlanDetailModel : NSObject
@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *country;
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, strong)NSArray *industryName;
@property(nonatomic, copy)NSString *endTime;
@property(nonatomic, copy)NSString *startTime;
@property(nonatomic, copy)NSString *hallName;
@property(nonatomic, copy)NSString *sponsor;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *sponsorUrl;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
