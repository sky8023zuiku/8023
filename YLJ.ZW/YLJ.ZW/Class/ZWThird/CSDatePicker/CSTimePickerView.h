//
//  CSTimePickerView.h
//  DateTimePickerViewDemo
//
//  Created by 王小姐 on 2020/6/9.
//  Copyright © 2020 TZF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CSTimePickerView;
typedef enum : NSUInteger {
    DatePickerViewDateTimeMode,//年月日,时分
    DatePickerViewDateMode,//年月日
    DatePickerViewTimeMode//时分
} DatePickerViewMode;

@protocol CSTimePickerViewDelegate <NSObject>

@optional
/**
 * 确定按钮
 */
-(void)didClickFinishDateTimePickerView:(NSString*)date;

-(void)createDatePickerView:(CSTimePickerView *)pickerView withDateStr:(NSString *)date;
/**
 * 取消按钮
 */
-(void)didClickCancelDateTimePickerView;

@end

@interface CSTimePickerView : UIView
/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate*currentDate;
/**
 * 设置中心标题文字
 */
@property(nonatomic, strong)UILabel *titleL;

@property(nonatomic, strong)id<CSTimePickerViewDelegate>delegate;
/**
 * 模式
 */
@property (nonatomic, assign) DatePickerViewMode pickerViewMode;
/**
 * 掩藏
 */
- (void)hideDateTimePickerView;
/**
 * 显示
 */
- (void)showDateTimePickerView;


@end

NS_ASSUME_NONNULL_END
