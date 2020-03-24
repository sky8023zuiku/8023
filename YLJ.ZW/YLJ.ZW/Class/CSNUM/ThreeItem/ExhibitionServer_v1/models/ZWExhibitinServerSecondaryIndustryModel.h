//
//  ZWExhibitinServerSecondaryIndustryModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitinServerSecondaryIndustryModel : NSObject
@property(nonatomic, strong)NSString *industryId;
@property(nonatomic, strong)NSString *name;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
