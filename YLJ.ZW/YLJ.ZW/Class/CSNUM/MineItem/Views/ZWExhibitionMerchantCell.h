//
//  ZWExhibitionMerchantCell.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
#import "ZWExExhibitorsModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ZWExhibitionMerchantCell;
@protocol ZWExhibitionMerchantCellDelegate <NSObject>

-(void)clickBtnWithIndex:(NSInteger)index;

-(void)exhibitorsItemWithIndex:(ZWExhibitionMerchantCell *)cell withIndex:(NSInteger)index;

@end

@interface ZWExhibitionMerchantCell : UIView
@property(nonatomic, weak)id<ZWExhibitionMerchantCellDelegate> delegate;
@property(nonatomic, strong)ZWExExhibitorsModel *model;

@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;

@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UIImageView *titleImage;//标题图片
@property(nonatomic, strong)UILabel *mainBusiness;//主营业务
@property(nonatomic, strong)UILabel *demandLabel;//需求
@property(nonatomic, strong)UILabel *boothNumber;//展位号
@property(nonatomic, strong)NSArray *dataImages;//

@end

NS_ASSUME_NONNULL_END
