//
//  CSMenuViewController.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CSMenuViewController : UIViewController
@property(nonatomic, strong)NSMutableArray *conditions;//获取点击itme之后的值
@property(nonatomic, strong)NSMutableArray *itemsIndex;//获取点击itme的索引
@property(nonatomic, strong)NSString *industriesId;//行业id
@property(nonatomic, assign)NSInteger screenType;//1为展会筛选 2为展商筛选

@property(nonatomic, strong)NSArray *screenValues;//筛选条件
@end

NS_ASSUME_NONNULL_END
