//
//  ZWMerchantSearchView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/11.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMerchantSearchView : UIView
- (instancetype)initWithFrame:(CGRect)frame withSearchText:(NSString *)text;

- (void)refreshResultViewWithIsDouble:(BOOL)isDouble;

@property (nonatomic, strong) ZWBaseEmptyTableView *contentTableView;

@property(nonatomic, strong)NSString *searchText;
@end

NS_ASSUME_NONNULL_END
