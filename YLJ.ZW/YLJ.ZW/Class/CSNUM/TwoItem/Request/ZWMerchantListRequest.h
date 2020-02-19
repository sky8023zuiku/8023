//
//  ZWMerchantListRequest.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/19.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
//查询展商列表
@interface ZWMerchantListRequest : YHBaseRequest

@property (nonatomic, copy) NSString *baseIndustryId;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *isNewMerchant;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDictionary *pageQuery;

@end

NS_ASSUME_NONNULL_END
