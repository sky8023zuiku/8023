//
//  ZWPlanDelayCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWExhPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZWPlanDelayCellDelegate<NSObject>

-(void)respondToEventsWithDelayIndex:(NSInteger)index;

@end

@interface ZWPlanDelayCell : UIView
@property(nonatomic, weak)id<ZWPlanDelayCellDelegate> delegate;
@property(nonatomic, strong)ZWExhPlanListModel *model;
@end

NS_ASSUME_NONNULL_END
