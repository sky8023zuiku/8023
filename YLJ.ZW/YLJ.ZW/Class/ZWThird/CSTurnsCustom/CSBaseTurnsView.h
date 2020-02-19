//
//  CSBaseTurnsView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/1.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSBaseTurnsView : UIView
/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;
/**
 *  主视图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

@end

NS_ASSUME_NONNULL_END
