//
//  ZWHomeTuiExhibitorsView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWInduExhibitorsModel.h"
NS_ASSUME_NONNULL_BEGIN
@class ZWHomeTuiExhibitorsView;
@protocol ZWHomeTuiExhibitorsViewDelegate <NSObject>
-(void)industryCancelTheCollection:(ZWHomeTuiExhibitorsView *)cell withIndex:(NSInteger)index;
@end
@interface ZWHomeTuiExhibitorsView : UIView
@property(nonatomic, weak)id<ZWHomeTuiExhibitorsViewDelegate> delegate;
@property(nonatomic, strong)ZWInduExhibitorsModel *model;
@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)UIButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END
