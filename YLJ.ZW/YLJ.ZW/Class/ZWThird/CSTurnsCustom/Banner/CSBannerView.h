//
//  CSBannerView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/2.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSBaseTurnsView.h"
#import "CSTurnsView.h"
#import "CSBaseBannerView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CSBannerViewDelegate <NSObject>
-(void)didSelectCell:(UIView *)subView withIndex:(NSInteger)index;
@end

@interface CSBannerView : CSBaseTurnsView<CSTurnsViewDelegate,CSTurnsViewDataSource>
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images;
@property(nonatomic, weak)id<CSBannerViewDelegate> delegate;
@property(nonatomic, strong)CSTurnsView *turnsView;
@end

NS_ASSUME_NONNULL_END
