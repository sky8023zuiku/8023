//
//  ZWHomeMainTuiView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/10.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZWHomeMainTuiView;
@protocol ZWHomeMainTuiViewDelegate <NSObject>
-(void)industryCancelTheCollection:(ZWHomeMainTuiView *)cell withIndex:(NSInteger)index;
@end

@interface ZWHomeMainTuiView : UIView
@property(nonatomic, weak)id<ZWHomeMainTuiViewDelegate> delegate;
@property(nonatomic, strong)NSString *collectionBtnBackImageName;
@property(nonatomic, strong)NSDictionary *myData;
@property(nonatomic, strong)UIButton *collectionBtn;
@end

NS_ASSUME_NONNULL_END
