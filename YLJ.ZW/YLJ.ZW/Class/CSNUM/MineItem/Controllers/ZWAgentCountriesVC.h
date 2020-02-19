//
//  ZWAgentCountriesVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZWAgentCountriesVC : UIViewController
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, assign)NSInteger status;//0.是从主页进 1.是从编辑个人信息进
@end

NS_ASSUME_NONNULL_END
