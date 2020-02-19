//
//  ZWMyCatalogueCell.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"

NS_ASSUME_NONNULL_BEGIN
@class ZWMyCatalogueCell;
@protocol ZWMyCatalogueCellDelegate <NSObject>

-(void)collectionItemWithIndex:(ZWMyCatalogueCell *)cell withIndex:(NSInteger)index;

@end
@interface ZWMyCatalogueCell : UIView
@property(nonatomic, weak)id<ZWMyCatalogueCellDelegate> delegate;
@property(nonatomic, strong)ZWMyCatalogueModel *model;
@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END
