//
//  ZWConditionsListVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWConditionsListVC : UIViewController
@property(nonatomic, strong)NSString *exhibitionId;
@property(nonatomic, strong)NSNumber *industryId;
@property(nonatomic, strong)NSArray *dataArray;
@end

NS_ASSUME_NONNULL_END
