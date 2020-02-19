//
//  ZWAlertAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWAlertAction.h"

@implementation ZWAlertAction
static id _action = nil;
+ (instancetype)sharedAction {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _action = [super allocWithZone:zone];
    });
    return _action;
}
- (void)showOneAlertTitle:(NSString *)title
                  message:(NSString *)message
             confirmTitle:(NSString *)confTitle
                actionOne:(myActionOne)actionOne
               showInView:(UIViewController *)controller {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:confTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (action) {
            actionOne(action);
        }
    }];
    [alertC addAction:action1];
    [controller presentViewController:alertC animated:YES completion:nil];
    
}

- (void)showTwoAlertTitle:(NSString *)title
                  message:(NSString *)message
              cancelTitle:(NSString *)cancelTitle
             confirmTitle:(NSString *)confTitle
                actionOne:(myActionOne)actionOne
             actionCancel:(myActionCancel)actionCancel
               showInView:(UIViewController *)controller {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (action) {
            actionCancel(action);
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:confTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (action) {
            actionOne(action);
        }
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [controller presentViewController:alertC animated:YES completion:nil];
    
}

- (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
             actionOne:(myActionOne)actionOne
             sctionTwo:(myActionTwo)actionTwo
          actionCancel:(myActionCancel)actionCancel
            showInView:(UIViewController *)controller {
    
}
@end
