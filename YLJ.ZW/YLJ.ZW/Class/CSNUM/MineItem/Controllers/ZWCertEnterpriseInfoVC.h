//
//  ZWCertEnterpriseInfoVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/31.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWCertEnterpriseInfoVC : UIViewController
@property(nonatomic, assign)NSInteger merchantStatus;
@property(nonatomic, strong)NSString *identityId;
@property(nonatomic, strong)ZWAuthenticationModel *model;
@end

NS_ASSUME_NONNULL_END
