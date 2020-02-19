//
//  ZWValidationSendVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWAreaCodeModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWValidationSendVC : UIViewController

@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, strong)ZWAreaCodeModels *pres;

@end

NS_ASSUME_NONNULL_END
