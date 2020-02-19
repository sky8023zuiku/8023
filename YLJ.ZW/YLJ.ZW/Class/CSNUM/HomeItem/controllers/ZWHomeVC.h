//
//  ZWHomeVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWHomeVCDelegate <NSObject>

- (void)zwHomeTableRollValue:(CGFloat)value;

@end

@interface ZWHomeVC : UIViewController
@property(nonatomic, weak)id<ZWHomeVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
