//
//  ZWExhibitionCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN
@class ZWExhibitionListsCell;
@protocol ZWExhibitionListsCellDelegate <NSObject>

-(void)collectionItemWithIndex:(ZWExhibitionListsCell *)cell withIndex:(NSInteger)index;

@end
@interface ZWExhibitionListsCell : UIView
@property(nonatomic, weak)id<ZWExhibitionListsCellDelegate> delegate;
@property(nonatomic, strong)ZWExhibitionListModel *model;

@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;
@end

NS_ASSUME_NONNULL_END
