//
//  CSDateManager.m
//  DateTimePickerViewDemo
//
//  Created by 王小姐 on 2020/6/9.
//  Copyright © 2020 TZF. All rights reserved.
//

#import "CSDateManager.h"
#import "CSTimePickerView.h"
@interface CSDateManager()<CSTimePickerViewDelegate>
@property(nonatomic, strong)CSTimePickerView *datePickerView;
@end

@implementation CSDateManager

static CSDateManager *shareManager = nil;
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (void)showPickerView:(UIViewController *)viewController withModeIndex:(NSInteger)modeIndex withIndex:(NSInteger)index {
        
    [viewController.view endEditing:YES];
    CSTimePickerView *pickerView = [[CSTimePickerView alloc] init];
    pickerView.delegate = self;
    if (modeIndex == 0) {
        pickerView.pickerViewMode = DatePickerViewDateTimeMode;
    }else if (modeIndex == 1) {
        pickerView.pickerViewMode = DatePickerViewDateMode;
    }else {
        pickerView.pickerViewMode = DatePickerViewTimeMode;
    }
    pickerView.tag = index;
    self.datePickerView = pickerView;
    [viewController.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
}

@end
