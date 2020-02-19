//
//  ZWApplePayAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWApplePayAction : NSObject
+ (instancetype)shareIAPAction;

- (void)requestProducts:(NSDictionary *)productId withViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
