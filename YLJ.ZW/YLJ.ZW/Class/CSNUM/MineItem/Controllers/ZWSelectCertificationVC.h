//
//  ZWSelectCertificationVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/31.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSelectCertificationVC : UIViewController
@property(nonatomic, assign)NSInteger authenticationStatus;//0未认证 1审核中 2认证通过 3审核未通过
@property(nonatomic, assign)NSInteger identityId;//1为观众 2为展商 3服务商 3设计公司
@end

NS_ASSUME_NONNULL_END
