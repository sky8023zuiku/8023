//
//  ZWServiceProviderSearchResultsView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWServiceProviderSearchResultsView : UIView
- (instancetype)initWithFrame:(CGRect)frame withParameter:(id)obj;

@property (nonatomic, strong) ZWBaseEmptyTableView *contentTableView;

@property(nonatomic, strong)NSString *searchText;
@end

NS_ASSUME_NONNULL_END
