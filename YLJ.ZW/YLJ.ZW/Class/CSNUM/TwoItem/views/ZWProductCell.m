//
//  ZWProductCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWProductCell.h"

@implementation ZWProductCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self addSubview:self.titleImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame), frame.size.width, 0.08*kScreenWidth)];
        [self addSubview:self.titleLabel];
    }
    return self;
}
@end
