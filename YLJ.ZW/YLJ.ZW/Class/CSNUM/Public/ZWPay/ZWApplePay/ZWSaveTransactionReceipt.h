//
//  ZWSaveTransactionReceipt.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/31.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSaveTransactionReceipt : NSObject
+ (instancetype)shareReceipt;
/**
 *   保存苹果支付凭据
 */
- (void)saveUserReceipt:(NSDictionary *)receipt;
- (NSDictionary *)takeUserReceipt;
- (void)removeLocation;
@end

NS_ASSUME_NONNULL_END
