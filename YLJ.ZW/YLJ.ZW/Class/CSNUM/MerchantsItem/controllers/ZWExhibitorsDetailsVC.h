//
//  ZWExhibitorsDetailsVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWInduExhibitorsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitorsDetailsVC : UIViewController
@property(nonatomic, strong)NSString *merchantId;
@property(nonatomic, strong)ZWInduExhibitorsModel *shareModel;
@end

NS_ASSUME_NONNULL_END
