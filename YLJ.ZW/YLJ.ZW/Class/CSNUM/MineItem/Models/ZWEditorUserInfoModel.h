//
//  ZWEditorUserInfoModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWEditorUserInfoModel : NSObject
@property(nonatomic, strong)NSString *headImages;//头像
@property(nonatomic, strong)NSString *identityId;//身份id
@property(nonatomic, strong)NSArray *industryIdList;//行业列表
@property(nonatomic, strong)NSString *mail;//邮箱
@property(nonatomic, strong)NSString *userName;//用户名称
@end

NS_ASSUME_NONNULL_END
