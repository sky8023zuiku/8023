//
//  ZWLevel3SelectView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWIndustriesModel.h"
#import "ZWChosenIndustriesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWLevel3SelectView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)ZWIndustriesModel *model;
@property(nonatomic, strong)NSMutableArray *selectArray;
@end

NS_ASSUME_NONNULL_END
