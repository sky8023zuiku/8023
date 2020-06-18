//
//  ZWExhibitionServerListVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/16.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionServerListVC : UIViewController
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)NSMutableDictionary *myParameter;
@property (nonatomic,strong)NSMutableDictionary *mySpellParameter;
@property (nonatomic,strong)NSString *selectedCity;

@end

NS_ASSUME_NONNULL_END
