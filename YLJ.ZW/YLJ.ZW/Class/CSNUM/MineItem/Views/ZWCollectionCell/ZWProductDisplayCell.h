//
//  ZWProductDisplayCell.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/10.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWProductDisplayCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *mianImageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIButton *deleteBtn;
@property(nonatomic, assign)BOOL isDelete;
@end

NS_ASSUME_NONNULL_END
