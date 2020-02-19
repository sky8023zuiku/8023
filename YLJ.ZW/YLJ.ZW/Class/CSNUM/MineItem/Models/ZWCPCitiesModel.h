//
//  ZWCPCitiesModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCPCitiesModel : NSObject
@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *value;
@property(nonatomic, copy)NSString *key;
@property(nonatomic, copy)NSString *level;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
