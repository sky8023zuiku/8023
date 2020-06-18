//
//  ZWExhibitionNaviModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionNaviModel : NSObject

@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *nExhibitorCount;//新品展商的数量
@property(nonatomic, copy)NSString *endTime;//结束时间
@property(nonatomic, copy)NSString *merchantCount;//展商数量
@property(nonatomic, copy)NSString *exhibitionName;//展会名称
@property(nonatomic, copy)NSString *hallName;//展馆名称
@property(nonatomic, strong)NSArray *topImagesUrl;//平面图
@property(nonatomic, strong)NSArray *belowImagesUrl;//鸟瞰图
@property(nonatomic, copy)NSString *startTime;//开始时间

@end

NS_ASSUME_NONNULL_END
