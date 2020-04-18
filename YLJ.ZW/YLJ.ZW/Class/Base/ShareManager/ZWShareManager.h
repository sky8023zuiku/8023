//
//  ZWShareManager.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWShareModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ZWShareManagerDelegate <NSObject>

- (void)clickItemWithIndex:(NSInteger)index;

@end
@interface ZWShareManager : NSObject

@property(nonatomic, strong)id<ZWShareManagerDelegate> delegate;

+ (instancetype)shareManager;
- (void)shareWithData:(ZWShareModel *)model;
- (void)shareTwoActionSheetWithData:(ZWShareModel *)model;
@end

NS_ASSUME_NONNULL_END
