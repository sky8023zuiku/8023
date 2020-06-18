//
//  ZWMyBusinessCardListVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/22.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMyBusinessCardListVC : UIViewController
@property(nonatomic, assign)NSInteger type;//0为选择进入，1为编辑进入
@property(nonatomic, strong)NSString* merchantId;//公司id
@end

NS_ASSUME_NONNULL_END
