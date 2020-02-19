//
//  CSSearchView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapActionBlock)(NSString *str);
@interface CSSearchView : UIView
@property (nonatomic, copy) TapActionBlock tapAction;

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;
@end

NS_ASSUME_NONNULL_END
