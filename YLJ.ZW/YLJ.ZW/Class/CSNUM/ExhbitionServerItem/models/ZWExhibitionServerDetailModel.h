//
//  ZWExhibitionServerDetailModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionServerDetailModel : NSObject
@property(nonatomic, copy)NSString *address;//公司地址
@property(nonatomic, copy)NSString *name;//公司名称
@property(nonatomic, copy)NSString *profile;//公司简介
@property(nonatomic, copy)NSString *telephone;//公司电话
@property(nonatomic, strong)NSArray *imagesUrl;//轮播图数组
@end

NS_ASSUME_NONNULL_END
