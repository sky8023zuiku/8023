//
//  ZWAgentProvinceVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCPCitiesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWAgentProvinceVC : UIViewController
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)ZWCPCitiesModel *countriesModel;
@property(nonatomic, assign)NSInteger status;//0.是从拼单 1.是从编辑个人信息进
@property(nonatomic, assign)NSInteger pageIndex;//需要返回到哪个页面
@end

NS_ASSUME_NONNULL_END
