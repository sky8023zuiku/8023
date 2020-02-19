//
//  ZWTopUpModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWTopUpModel : NSObject
@property(nonatomic, copy)NSString *score;//用户id
@property(nonatomic, copy)NSString *phonePrice;//银行卡名称
@property(nonatomic, copy)NSString *ID;//列表id
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
