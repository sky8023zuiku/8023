//
//  ZWExhibitorsDetailModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitorsDetailModel : NSObject
@property(nonatomic, copy)NSString *address;//展商地址
@property(nonatomic, copy)NSString *product;//主营
@property(nonatomic, copy)NSNumber *website;//网站
@property(nonatomic, copy)NSString *name;//公司名称
@property(nonatomic, copy)NSString *email;//公司邮箱
@property(nonatomic, copy)NSString *requirement;//需求
@property(nonatomic, copy)NSString *telephone;//电话号码
@property(nonatomic, copy)NSString *productUrl;//pdf
@property(nonatomic, copy)NSString *profile;//pdf
@property(nonatomic, strong)NSArray *images;//图片
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
