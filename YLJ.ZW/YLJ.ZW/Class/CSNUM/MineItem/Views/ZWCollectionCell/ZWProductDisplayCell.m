//
//  ZWProductDisplayCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/10.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWProductDisplayCell.h"

@implementation ZWProductDisplayCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self.contentView addSubview:self.mianImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mianImageView.frame), frame.size.width, 0.05*kScreenWidth)];
        self.titleLabel.font = smallMediumFont;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
