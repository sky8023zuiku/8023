//
//  ZWExhibitorsInfomationVC.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitorsInfomationVC : UIViewController
@property(nonatomic, strong)NSString *exhibitorId;
@property(nonatomic, assign)NSInteger enterType;//0为展示进入 1为编辑进入
@property(nonatomic, assign)NSInteger exhibitorType;//0展会展商 1行业展商
@end

NS_ASSUME_NONNULL_END
