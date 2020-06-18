//
//  ZWAuditMessageModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/24.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWAuditMessageModel : NSObject
@property(nonatomic, copy)NSString *listId;
@property(nonatomic, copy)NSString *readStatus;
@property(nonatomic, copy)NSString *message;
@property(nonatomic, copy)NSString *type;

@property(nonatomic, copy)NSString *myDescription;
@property(nonatomic, copy)NSNumber *create;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *status;
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end


NS_ASSUME_NONNULL_END
