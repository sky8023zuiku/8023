//
//  ZWExhServiceListCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWExhibitionServerListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWExhServiceListCell : UIView
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@property(nonatomic, strong)ZWExhibitionServerListModel *model;

@end

NS_ASSUME_NONNULL_END
