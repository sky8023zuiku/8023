//
//  ZWLabelView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BtnBlock)(NSInteger index);
@interface ZWLabelView : UIView

@property (nonatomic,copy) BtnBlock btnBlock;

-(void) btnClickBlock:(BtnBlock) btnBlock;

-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
