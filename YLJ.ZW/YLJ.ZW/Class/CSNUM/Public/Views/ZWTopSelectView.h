//
//  ZWTopSelectView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWTopSelectViewDelegate <NSObject>

- (void)clickItemWithIndex:(NSInteger)index;

@end
@interface ZWTopSelectView : UIView
@property(nonatomic, strong)NSArray *titles;
@property(nonatomic, strong)id<ZWTopSelectViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
