//
//  ZWMyShareExhibitorModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyShareExhibitorModel : NSObject

@property(nonatomic, copy)NSString *exhibitorId;//展商id
@property(nonatomic, copy)NSString *merchantName;//公司名称
@property(nonatomic, copy)NSString *exhibitionName;//展会名称
@property(nonatomic, copy)NSString *coverImage;//公司logo
@property(nonatomic, copy)NSString *profile;//公司简介

+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
