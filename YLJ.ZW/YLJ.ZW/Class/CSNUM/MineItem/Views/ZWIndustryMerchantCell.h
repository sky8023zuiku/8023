//
//  ZWIndustryMerchantCell.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWMineResponse.h"
#import "ZWInduExhibitorsModel.h"
NS_ASSUME_NONNULL_BEGIN
@class ZWIndustryMerchantCell;
@protocol ZWIndustryMerchantCellDelegate <NSObject>
-(void)industryCancelTheCollection:(ZWIndustryMerchantCell *)cell withIndex:(NSInteger)index;
@end


@interface ZWIndustryMerchantCell : UIView
@property(nonatomic, weak)id<ZWIndustryMerchantCellDelegate> delegate;
@property(nonatomic, strong)ZWIndustryExhibitorsListModel *model;

@property(nonatomic, strong)ZWInduExhibitorsModel *showModel;

@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;

@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *EnglishName;//公司英文名称
@property(nonatomic, strong)UIImageView *titleImage;//标题图片
@property(nonatomic, strong)UILabel *mainBusiness;//主营业务
@property(nonatomic, strong)UILabel *demandLabel;//需求
@end

NS_ASSUME_NONNULL_END
