//
//  CSBaseTurnsView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/1.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSBaseTurnsView.h"

@implementation CSBaseTurnsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverView];
        [self addSubview:self.mainImageView];
    }
    return self;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _coverView;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _mainImageView;
}

@end
