//
//  ZWMessageListCell.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZWMessageListCellDelegate <NSObject>

-(void)tapClose:(NSInteger)index;

@end

@interface ZWMessageListCell : UIView
@property(nonatomic, weak)id<ZWMessageListCellDelegate> delegate;
@property(nonatomic, strong)ZWMessageListModel *model;
@end

NS_ASSUME_NONNULL_END
