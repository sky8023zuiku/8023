//
//  ZWExExhibitorsVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExExhibitorsVC : UIViewController
@property(nonatomic, strong)NSString *exhibitionId;
@property(nonatomic, strong)NSString *price;//展会价格
@property(nonatomic, strong)NSString *exExhibitorsNum;//展会展商数量
@property(nonatomic, strong)NSString *nExExhibitorsNum;//新品展会展商数量
@end

NS_ASSUME_NONNULL_END
