//
//  ZWProductDetailVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/7.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWProductDetailVC : UIViewController
@property(nonatomic, strong)NSString *productId;
@property(nonatomic, assign)NSInteger productType;//0.为行业展商商品 1.为展会展商商品
@end

NS_ASSUME_NONNULL_END
