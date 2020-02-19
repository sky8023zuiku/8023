//
//  ZWMyCatalogueVC.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWMyCatalogueVCDelegate <NSObject>

-(void)ZWMyCatalogueVCDelegate:(NSArray<NSIndexPath *> *)indexpaths;

@end
@interface ZWMyCatalogueVC : UIViewController
@property (weak, nonatomic) id <ZWMyCatalogueVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
