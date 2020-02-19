//
//  ZWPlanExhibitionFuzzyModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWPlanExhibitionFuzzyModel : NSObject
@property(nonatomic, copy)NSString *name;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
