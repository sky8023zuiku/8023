//
//  ZWMyShareExhibitionListModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyShareExhibitionListModel : NSObject
@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *exhibitionName;//展会名称
@property(nonatomic, copy)NSString *bindSize;//用户绑定个数
@property(nonatomic, copy)NSString *total;//展会绑定次数
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
