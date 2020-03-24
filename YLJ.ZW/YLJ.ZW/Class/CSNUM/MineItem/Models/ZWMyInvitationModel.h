//
//  ZWMyInvitationModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyInvitationModel : NSObject
@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *headImage;
@property(nonatomic, copy)NSString *recommendTime;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *listId;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
