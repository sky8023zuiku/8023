//
//  ZWPayVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWPayVC : UIViewController
@property(nonatomic, strong)NSDictionary *membersDic;
@property(nonatomic, assign)NSInteger type;//1为会刊，2为会员
@property(nonatomic, strong)ZWOrderListModel *model;//已有订单的模型
@property(nonatomic, strong)ZWCreateOrderModel *orderModel;//创建订单时的模型

@property(nonatomic, assign)NSInteger status;//1是生成订单，2从订单列表进入支付订单

@end

NS_ASSUME_NONNULL_END
