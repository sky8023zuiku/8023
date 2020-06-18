//
//  ZWExhibitionServerListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionServerListModel : NSObject

@property(nonatomic, strong)NSNumber * providersId;//服务商ID
@property(nonatomic, copy)NSString * name;//服务商名称
@property(nonatomic, copy)NSString * business;//业务标签
@property(nonatomic, copy)NSString * headLine;//公司标语
@property(nonatomic, copy)NSString * speciality;//服务类型
@property(nonatomic, copy)NSString * imagesUrl;//封面图片
@property(nonatomic, strong)NSNumber * total;//列表总数
@property(nonatomic, strong)NSString *vipVersion;//0，1为vip 2为svip

@end

NS_ASSUME_NONNULL_END
