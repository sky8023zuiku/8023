//
//  CSDateManager.h
//  DateTimePickerViewDemo
//
//  Created by 王小姐 on 2020/6/9.
//  Copyright © 2020 TZF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CSDateManagerDelegate <NSObject>

-(void)takeDateWithStr:(NSString *)date withIndex:(NSInteger)index;

@end

@interface CSDateManager : NSObject
+ (instancetype)shareManager;

@property(nonatomic, strong)id<CSDateManagerDelegate> delegate;

- (void)showPickerView:(UIViewController *)viewController withModeIndex:(NSInteger)modeIndex withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
