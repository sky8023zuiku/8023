//
//  ZWMerchantSearchRequst.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWMerchantSearchRequst : YHBaseRequest

@property(nonatomic, copy)NSString *industryId;
@property(nonatomic, copy)NSString *name;

@end

NS_ASSUME_NONNULL_END
