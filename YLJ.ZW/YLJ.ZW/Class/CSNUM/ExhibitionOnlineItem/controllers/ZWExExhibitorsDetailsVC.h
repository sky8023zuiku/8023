//
//  ZWExExhibitorsDetailsVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWExExhibitorsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWExExhibitorsDetailsVC : UIViewController
//@property(nonatomic, strong)NSString *exhibitorId;
//@property(nonatomic, strong)NSString *merchantId;//获取公司简介的时候需要传列表id
@property(nonatomic, strong)ZWExExhibitorsModel *shareModel;//分享数据
@end

NS_ASSUME_NONNULL_END
