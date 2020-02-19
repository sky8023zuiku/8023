//
//  ZWCitiesListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCitiesListModel : NSObject
@property(nonatomic, copy)NSString *citiesId;
@property(nonatomic, copy)NSString *name;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
