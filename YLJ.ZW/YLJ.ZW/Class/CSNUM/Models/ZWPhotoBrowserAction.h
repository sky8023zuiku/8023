//
//  ZWPhotoBrowserAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWPhotoBrowserAction : NSObject
+ (instancetype)shareAction;
- (void)showImageViewUrls:(NSArray *)images tapIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
