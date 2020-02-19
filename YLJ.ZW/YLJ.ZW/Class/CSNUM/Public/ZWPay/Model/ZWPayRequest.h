//
//  ZWPayRequest.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWPayRequest : YHBaseRequest
@property(nonatomic, strong)NSString *orderNum;
@property(nonatomic, strong)NSString *score;
@end


NS_ASSUME_NONNULL_END
