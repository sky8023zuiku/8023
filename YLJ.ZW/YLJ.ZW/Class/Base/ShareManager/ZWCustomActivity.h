//
//  ZWCustomActivity.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/25.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWCustomActivity : UIActivity
- (instancetype)initWithTitle:(NSString *)title ActivityImage:(UIImage *)activityImage URL:(NSURL *)url ActivityType:(NSString *)activityType;
@end

NS_ASSUME_NONNULL_END
