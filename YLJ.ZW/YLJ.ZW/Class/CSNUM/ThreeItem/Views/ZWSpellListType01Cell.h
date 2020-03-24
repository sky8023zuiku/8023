//
//  ZWSpellListType01Cell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSpellListModel.h"
NS_ASSUME_NONNULL_BEGIN
//制作拼单
@interface ZWSpellListType01Cell : UIView
- (instancetype)initWithFrame:(CGRect)frame withFont:(UIFont *)font;
@property(nonatomic, strong)ZWSpellListModel *model;
@end

NS_ASSUME_NONNULL_END
