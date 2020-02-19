//
//  ZWIndustriesModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWIndustriesModel : NSObject
@property(nonatomic, copy)NSString *secondIndustryName;
@property(nonatomic, copy)NSNumber *secondIndustryId;
@property(nonatomic, strong)NSArray *thirdIndustryList;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

@interface ZW3IndustriesModel : NSObject
@property(nonatomic, copy)NSNumber *industryId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)BOOL isSelected;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
