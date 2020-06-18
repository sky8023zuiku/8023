//
//  ZWSelectExIntIndustriesVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/9.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWSelectExIntIndustriesVC : UIViewController
@property(nonatomic, strong)NSArray *myIndustries;

@property(nonatomic, strong)ZWAuthenticationModel *model;
@property(nonatomic, strong)UIImage *coverImage;
@property(nonatomic, strong)NSDictionary *parameter;
@property(nonatomic, assign)NSInteger merchantStatus;

@property(nonatomic, strong)NSArray *industriesArr;

@property(nonatomic, strong)NSString *type;//2.展商 3.会展服务商
@end

NS_ASSUME_NONNULL_END
