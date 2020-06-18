//
//  ZWBusinessCardModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/23.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWBusinessCardModel : NSObject
@property(nonatomic, strong)NSString *contacts;//联系人名称
@property(nonatomic, strong)NSString *post;//职称
@property(nonatomic, strong)NSString *telephone;//联系人电话
@property(nonatomic, strong)NSString *phone;//联系人手机号码
@property(nonatomic, strong)NSString *qq;//联系人电话
@property(nonatomic, strong)NSString *mail;//联系人电话
@property(nonatomic, strong)NSString *merchantName;//公司名称
@property(nonatomic, strong)NSString *address;//地址
@property(nonatomic, strong)NSString *cardId;//卡片id
@property(nonatomic, strong)NSString *requirement;//需求
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
