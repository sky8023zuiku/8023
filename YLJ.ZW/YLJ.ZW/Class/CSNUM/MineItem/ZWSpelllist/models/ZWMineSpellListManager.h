//
//  ZWMineSpellListManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/4.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZWMineSpellListManagerDelegate <NSObject>

-(void)popToViewControllers:(BOOL)animated;

@end

@interface ZWMineSpellListManager : NSObject
+ (instancetype)shareManager;
@property(nonatomic, weak)id<ZWMineSpellListManagerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
