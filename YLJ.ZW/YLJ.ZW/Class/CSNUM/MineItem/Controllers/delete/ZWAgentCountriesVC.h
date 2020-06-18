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
@property(nonatomic, assign)NSInteger status;//0.上传拼单 1.是从编辑个人信息进
@property(nonatomic, assign)NSInteger pageIndex;//需要返回到哪个页面
@end

NS_ASSUME_NONNULL_END
