//
//  ZWPdfManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWPdfManager : NSObject

+ (instancetype)shareManager;

- (void)createPdfBreview:(UIViewController *)viewController withUrl:(NSString *)url withFileName:(NSString *)fileName;

- (void)downloadPdfProfile:(UIViewController *)viewController withUrl:(NSString *)url withFileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
