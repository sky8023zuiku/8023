//
//  ZWHotExhibitionsCollectionViewCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
NS_ASSUME_NONNULL_BEGIN
@class ZWHotExhibitionsCollectionViewCell;
@protocol ZWHotExhibitionsCollectionViewCellDelegate <NSObject>

-(void)collectionItemWithIndex:(ZWHotExhibitionsCollectionViewCell *)cell withIndex:(NSInteger)index;

@end
@interface ZWHotExhibitionsCollectionViewCell : UICollectionViewCell
@property(nonatomic, weak)id<ZWHotExhibitionsCollectionViewCellDelegate> delegate;
@property(nonatomic, strong)ZWExhibitionListModel *model;

@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;
@end

NS_ASSUME_NONNULL_END
