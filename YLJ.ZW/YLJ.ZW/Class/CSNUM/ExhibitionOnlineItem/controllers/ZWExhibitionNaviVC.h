//
//  ZWExhibitionNaviVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionNaviVC : UIViewController
@property(nonatomic, strong)NSString *exhibitionId;//展会id;
@property(nonatomic, strong)NSString *price;//展会价格
@property(nonatomic, strong)NSDictionary *shareData;//分享数据
@end

NS_ASSUME_NONNULL_END
