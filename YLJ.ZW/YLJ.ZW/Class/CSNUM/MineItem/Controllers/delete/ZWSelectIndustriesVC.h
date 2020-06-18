//
//  ZWSelectIndustriesVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWSelectIndustriesVC : UIViewController
@property(nonatomic, strong)NSArray *myIndustries;

@property(nonatomic, strong)ZWAuthenticationModel *model;
@property(nonatomic, strong)UIImage *coverImage;
@property(nonatomic, strong)NSDictionary *parameter;
@property(nonatomic, assign)NSInteger merchantStatus;

@property(nonatomic, strong)NSArray *industriesArr;

@property(nonatomic, assign)NSInteger type;//1.为公司认证进入 2.为变更行业进入

@end

NS_ASSUME_NONNULL_END
