//
//  ZWSpellListType02View.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/12.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSpellListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWSpellListType02View : UIView
- (instancetype)initWithFrame:(CGRect)frame withModel:(ZWSpellListModel *)model withType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
