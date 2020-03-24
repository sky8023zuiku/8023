//
//  ZWMyShareExhibitionUserModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/3.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyShareExhibitionUserModel : NSObject

@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *coverImage;//用户头像
@property(nonatomic, copy)NSString *phone;//用户电话号码
@property(nonatomic, copy)NSString *inviteCode;//用户绑定的分享码
@property(nonatomic, copy)NSString *userName;//用户昵称
@property(nonatomic, copy)NSString *bindTime;//绑定时间
+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
