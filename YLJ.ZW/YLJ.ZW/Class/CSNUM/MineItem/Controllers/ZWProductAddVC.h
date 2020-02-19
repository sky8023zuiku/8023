//
//  ZWProductAddVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWProductAddVC : UIViewController
@property(nonatomic, strong)NSString *exhibitorId;
@property(nonatomic, strong)NSString *productId;
@property(nonatomic, assign)NSInteger status;//0为展示，1为编辑，2新增
@end

NS_ASSUME_NONNULL_END
