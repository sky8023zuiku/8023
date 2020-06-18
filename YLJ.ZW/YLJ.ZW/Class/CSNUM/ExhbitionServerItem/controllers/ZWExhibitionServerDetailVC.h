//
//  ZWExhibitionServerDetailVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/17.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWExhibitionServerListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionServerDetailVC : UIViewController
@property(nonatomic, strong)NSString *merchantId;
@property(nonatomic, strong)ZWExhibitionServerListModel *shareModel;
@end

NS_ASSUME_NONNULL_END
