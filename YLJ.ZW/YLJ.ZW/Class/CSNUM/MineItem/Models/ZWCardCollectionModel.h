//
//  ZWCardCollectionModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/25.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCardCollectionModel : NSObject
@property(nonatomic, copy)NSNumber *created;//时间
@property(nonatomic, copy)NSString *readStatus;//是否已读
@property(nonatomic, copy)NSString *sender;//发送人手机号码
@property(nonatomic, copy)NSString *headImage;//发送人的头像
@property(nonatomic, copy)NSString *listId;//消息id
@property(nonatomic, copy)NSString *userCard;//名片

@property(nonatomic, copy)NSString *contacts;//名字
@property(nonatomic, copy)NSString *phone;//手机号码
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
