//
//  ZWActivitiesMessageModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWActivitiesMessageModel : NSObject

@property(nonatomic, copy)NSString *created;
@property(nonatomic, copy)NSString *readStatus;
@property(nonatomic, copy)NSString *listId;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *message;

@property(nonatomic, copy)NSString *description2;
@property(nonatomic, copy)NSString *create;
@property(nonatomic, copy)NSString *title;

+ (id)parseJSON:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
