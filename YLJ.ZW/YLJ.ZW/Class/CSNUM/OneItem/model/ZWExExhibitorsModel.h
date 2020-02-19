//
//  ZWExExhibitorsModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExExhibitorsModel : NSObject
@property(nonatomic, copy)NSString *exhibitorId;//展会展商id
@property(nonatomic, copy)NSString *merchantId;//获取产品时需要
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *coverImages;//标题图片
@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *exposition;//展位号
@property(nonatomic, copy)NSString *product;//主营项目
@property(nonatomic, copy)NSNumber *collection;//
@property(nonatomic, copy)NSString *expositionUrl;//展位图
@property(nonatomic, copy)NSString *requirement;//需求
@property(nonatomic, copy)NSString *vipVersion;//0.普通用户 1.vip 2.svip
@property(nonatomic, assign)NSInteger exhibitorsType;//0为全部 1为新品 默认为0;
@property(nonatomic, assign)NSInteger selectType;// 默认为0 行业索引
@property(nonatomic, assign)NSInteger JumpType;//0为展会导航进入  1为个人中心进入
@property(nonatomic, assign)NSInteger isRreadAll;//0为不可查看 1为可查看
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
