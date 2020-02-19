//
//  ZWExhibitionDelayCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"

NS_ASSUME_NONNULL_BEGIN

@class ZWExhibitionDelayCell;
@protocol ZWExhibitionDelayCellDelegate <NSObject>

-(void)collectionItemWithCell:(ZWExhibitionDelayCell *)cell withIndex:(NSInteger)index;

@end

@interface ZWExhibitionDelayCell : UIView

@property(nonatomic, weak)id<ZWExhibitionDelayCellDelegate> delegate;
@property(nonatomic, strong)ZWExhibitionListModel *model;

@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END
