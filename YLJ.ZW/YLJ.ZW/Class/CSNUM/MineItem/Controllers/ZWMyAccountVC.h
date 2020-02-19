//
//  ZWMyAccountVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWTopUpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWMyAccountVC : UIViewController
@property(nonatomic, assign)NSInteger jumpType;//0为余额不足进入充值 1为正常进入页面充值
@property(nonatomic, strong)NSArray<ZWTopUpModel *> *models;
@end

NS_ASSUME_NONNULL_END
