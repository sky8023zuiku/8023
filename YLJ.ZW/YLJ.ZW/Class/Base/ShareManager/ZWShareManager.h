//
//  ZWShareManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWShareManager : NSObject
+ (instancetype)shareManager;
- (void)configurationShare;
- (void)showShareAlertWithViewController:(UIViewController *)viewController
                           withDataModel:(ZWShareModel *)model
                           withExtension:(id)extension
                                withType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
