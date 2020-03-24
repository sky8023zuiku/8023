//
//  CSSearchBarStyle.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSSearchBarStyle.h"
#import <UIKit/UIKit.h>
@interface CSSearchBarStyle()
@property(nonatomic,assign) BOOL isChangeFrame;//是否要改变searchBar的frame
@end
@implementation CSSearchBarStyle

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews[0].subviews) {
        for (UIView *subView in view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
               [view removeFromSuperview];
            }
            if ([subView isKindOfClass:[UITextField class]]) {
                CGFloat height = self.bounds.size.height;
                CGFloat width = self.bounds.size.width;
                if (_isChangeFrame) {
                    NSLog(@"%@", self.showsCancelButton ? @"YES":@"NO");
                    if (self.showsCancelButton) {
                        subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - 2 * _contentInset.left-50, height - 2 * _contentInset.top);
                    }else {
                        subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - 2 * _contentInset.left, height - 2 * _contentInset.top);
                    }
                } else {
                    CGFloat top = (height - 30.0) / 2.0;
                    CGFloat bottom = top;
                    CGFloat left = 8.0;
                    CGFloat right = left;
                    _contentInset = UIEdgeInsetsMake(top, left, bottom, right);
                }
            }
        }
    }
}

#pragma mark - set method
- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset.top = contentInset.top;
    _contentInset.bottom = contentInset.bottom;
    _contentInset.left = contentInset.left;
    _contentInset.right = contentInset.right;
    self.isChangeFrame = YES;
    [self layoutSubviews];
}

- (void)setIsChangeFrame:(BOOL)isChangeFrame {
    
    if (_isChangeFrame != isChangeFrame) {
        _isChangeFrame = isChangeFrame;
    }
}

@end
