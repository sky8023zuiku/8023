//
//  SecureCodeTimerManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginCountDownCompletedNotification            @"kLoginCountDownCompletedNotification"
#define kFindPasswordCountDownCompletedNotification     @"kFindPasswordCountDownCompletedNotification"
#define kRegisterCountDownCompletedNotification         @"kRegisterCountDownCompletedNotification"
#define kModifyPhoneCountDownCompletedNotification      @"kModifyPhoneCountDownCompletedNotification"

#define kLoginCountDownExecutingNotification            @"kLoginCountDownExecutingNotification"
#define kFindPasswordCountDownExecutingNotification     @"kFindPasswordCountDownExecutingNotification"
#define kRegisterCountDownExecutingNotification         @"kRegisterCountDownExecutingNotification"
#define kModifyPhoneCountDownExecutingNotification      @"kModifyPhoneCountDownExecutingNotification"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kCountDownType) {
    kCountDownTypeLogin,
    kCountDownTypeFindPassword,
    kCountDownTypeRegister,
    kCountDownTypeModifyPhone,
};

@interface SecureCodeTimerManager : NSObject

@property (nonatomic, nullable, strong) dispatch_source_t loginTimer;//登录界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t findPwdTimer;//找回密码界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t registerTimer;//注册界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t modifyPhoneTimer;//修改手机号界面倒计时timer

DEF_SINGLETON(SecureCodeTimerManager)
- (void)timerCountDownWithType:(kCountDownType)countDownType;
- (void)cancelTimerWithType:(kCountDownType)countDownType;
@end

NS_ASSUME_NONNULL_END
