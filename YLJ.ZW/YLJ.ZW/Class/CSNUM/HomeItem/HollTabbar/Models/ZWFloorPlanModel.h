//
//  ZWFloorPlanModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWFloorPlanModel : NSObject
@property(nonatomic, copy)NSString *hallNumberId;
@property(nonatomic, copy)NSString *hallNumberName;
@property(nonatomic, copy)NSString *imageUrl;
@property(nonatomic, copy)NSArray *images;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
