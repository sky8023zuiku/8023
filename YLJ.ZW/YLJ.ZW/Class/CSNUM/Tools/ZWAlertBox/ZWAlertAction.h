//
//  ZWAlertAction.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^myActionOne)(UIAlertAction *actionOne);
typedef void (^myActionTwo)(UIAlertAction *actionTwo);
typedef void (^myActionCancel)(UIAlertAction *actionCancel);
@interface ZWAlertAction : NSObject

@property(nonatomic, copy)myActionOne actionOne;
@property(nonatomic, copy)myActionTwo actionTwo;
@property(nonatomic, copy)myActionCancel actionCancel;

+ (instancetype)sharedAction;

- (void)showOneAlertTitle:(NSString *)title
                  message:(NSString *)message
             confirmTitle:(NSString *)confTitle
                actionOne:(myActionOne)actionOne
               showInView:(UIViewController *)controller;

- (void)showTwoAlertTitle:(NSString *)title
                  message:(NSString *)message
              cancelTitle:(NSString *)cancelTitle
             confirmTitle:(NSString *)confTitle
                actionOne:(myActionOne)actionOne
             actionCancel:(myActionCancel)actionCancel
               showInView:(UIViewController *)controller;

- (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
             actionOne:(myActionOne)actionOne
             sctionTwo:(myActionTwo)actionTwo
          actionCancel:(myActionCancel)actionCancel
            showInView:(UIViewController *)controller;

@end
NS_ASSUME_NONNULL_END
