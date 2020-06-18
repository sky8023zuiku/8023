//
//  ZWShareViewController.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWShareViewController : UIViewController
@property(nonatomic, strong)ZWShareModel *model;
@property(nonatomic, assign)NSInteger type;//0.为正常分享进入，1.为展会展商详情分享进入
@property(nonatomic, assign)id extension;//扩展
@end

NS_ASSUME_NONNULL_END
