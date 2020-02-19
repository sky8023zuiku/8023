//
//  ZWNewDynamicModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWNewDynamicModel : NSObject
//@property(nonatomic, copy)NSString *exhibitionName;//展会名称
//@property(nonatomic, copy)NSString *ID;//列表id
//@property(nonatomic, copy)NSString *merchantName;//公司名称
//@property(nonatomic, copy)NSString *created;//时间
//@property(nonatomic, copy)NSString *url;//标题图
//@property(nonatomic, copy)NSString *merchantId;//公司id
//@property(nonatomic, copy)NSString *startTime;//结束时间
//@property(nonatomic, copy)NSString *endTime;//结束时间
//@property(nonatomic, copy)NSString *describe;//简介

@property(nonatomic, copy)NSString *exhibitionId;//展会ID
@property(nonatomic, copy)NSString *exhibitorId;//展会ID
@property(nonatomic, copy)NSString *merchantId;//获取简介时需要此ID
@property(nonatomic, copy)NSString *exhibitionName;//展会名称
@property(nonatomic, copy)NSString *exposition;//展馆号
@property(nonatomic, copy)NSString *imagesId;//图片ID
@property(nonatomic, copy)NSString *price;//价格
@property(nonatomic, copy)NSString *purchased;//0.为未购买 1.为购买
@property(nonatomic, strong)NSDictionary *images;//图片数组
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
