//
//  ZWAreaCodeVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/25.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZWAreaCodeModels;
@protocol ZWAreaCodeVCDelegate <NSObject>

-(void)ZWAreaCodeViewControllerDelegate:(ZWAreaCodeModels*)pres;

@end

@interface ZWAreaCodeVC : UIViewController
@property (weak, nonatomic) id <ZWAreaCodeVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
