//
//  ZWCountriesListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/15.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCountriesListModel : NSObject
@property(nonatomic, copy)NSString *countriesId;
@property(nonatomic, copy)NSString *name;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
