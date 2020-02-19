//
//  ZWPlansListView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWExhPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ZWPlansListCellDelegate<NSObject>

-(void)respondToEventsWithIndex:(NSInteger)index;

@end
@interface ZWPlansListCell : UIView
@property(nonatomic, weak)id<ZWPlansListCellDelegate> delegate;
@property(nonatomic, strong)ZWExhPlanListModel *model;
@end

NS_ASSUME_NONNULL_END
