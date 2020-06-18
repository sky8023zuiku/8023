//
//  ZWReleaseSpellList04View.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/4.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSpellListModel.h"
NS_ASSUME_NONNULL_BEGIN
//**************************货车拼单*********************************/
@interface ZWReleaseSpellList04View : UIView
- (instancetype)initWithFrame:(CGRect)frame withModel:(ZWSpellListModel *)model withType:(NSInteger)type;
@property(nonatomic ,strong)NSString *selectType;//拼单类型;
@end

NS_ASSUME_NONNULL_END
