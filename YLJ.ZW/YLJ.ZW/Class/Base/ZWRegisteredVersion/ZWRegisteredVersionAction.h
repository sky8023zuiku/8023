//
//  ZWRegisteredVersionAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/20.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZWRegisteredVersionAction : NSObject
+ (instancetype)shareAction;
- (void)versionUpdate:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
