//
//  ZWBadgeAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/21.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWBadgeAction : NSObject
+ (instancetype)shareAction;
-(void)createBadge:(NSInteger)num withImageStr:(NSString *)imageName withNavigationItem:(UINavigationItem *)item target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
