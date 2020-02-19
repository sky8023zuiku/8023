//
//  ZWLicenseUploadVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWLicenseUploadVC : UIViewController
@property(nonatomic, strong)ZWAuthenticationModel *model;
@property(nonatomic, strong)UIImage *coverImage;
@property(nonatomic, assign)NSInteger merchantStatus;
@property(nonatomic, strong)NSDictionary *parameter;
@end

NS_ASSUME_NONNULL_END
