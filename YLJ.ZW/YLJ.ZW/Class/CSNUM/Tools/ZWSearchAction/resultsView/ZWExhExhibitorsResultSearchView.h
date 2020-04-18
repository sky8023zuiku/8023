//
//  ZWExhExhibitorsResultSearchView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhExhibitorsResultSearchView : UIView
- (instancetype)initWithFrame:(CGRect)frame withParameter:(id)obj;

@property (nonatomic, strong) ZWBaseEmptyTableView *contentTableView;

@property(nonatomic, strong)NSString *searchText;

@property(nonatomic, strong)NSString *isRreadAll;//0为不能读取全部 1为能读取全部

@property(nonatomic, strong)NSString *exhibitionId;//展会id

@property(nonatomic, strong)NSString *price;//展会价格

@end

NS_ASSUME_NONNULL_END
