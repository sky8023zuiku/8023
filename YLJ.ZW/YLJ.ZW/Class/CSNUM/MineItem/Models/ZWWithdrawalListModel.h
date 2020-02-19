//
//  ZWWithdrawalListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWWithdrawalListModel : NSObject
@property(nonatomic, strong)NSNumber *status;
@property(nonatomic, strong)NSString *count;
@property(nonatomic, strong)NSString *created;
@property(nonatomic, strong)NSString *ID;
@property(nonatomic, strong)NSNumber *applyType;
@property(nonatomic, strong)NSString *cardNumber;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
