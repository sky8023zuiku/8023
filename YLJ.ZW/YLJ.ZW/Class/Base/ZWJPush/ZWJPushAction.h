//
//  ZWJPushAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/20.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWJPushAction : NSObject
+ (instancetype)shareAction;
- (void)registerJPush:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
