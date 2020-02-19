//
//  ZWEditorUserInfoVC.h
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWEditorUserInfoVC : UIViewController
@property(nonatomic, strong)NSArray *labels;
@property(nonatomic, strong)NSArray *labelsId;
@property(nonatomic, strong)NSString *identityStr;
@property(nonatomic, strong)NSString *identityId;
@property(nonatomic, assign)NSInteger indexCount;//获取已有标签的个数
@property(nonatomic, strong)NSArray *labelArray;//标记已有标签
@property(nonatomic, strong)NSMutableArray *excavatorLabels;//每次传过来的标签
@end

NS_ASSUME_NONNULL_END
