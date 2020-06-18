//
//  ZWMineMenuViewCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/29.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWMineMenuViewCell.h"

@implementation ZWMineMenuViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-frame.size.width/8+5, frame.size.width/2-frame.size.width/4, frame.size.width/4-10, frame.size.width/4-10)];
        self.mianImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.mianImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mianImageView.frame)+10, frame.size.width, 0.05*kScreenWidth)];
        self.titleLabel.font = smallMediumFont;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        UIView *horLineView = [[UIView alloc] init];
        horLineView.backgroundColor = zwGrayColor;
        [self.contentView addSubview:horLineView];
        horLineView.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);

        UIView *verLineView = [[UIView alloc] init];
        verLineView.backgroundColor = zwGrayColor;
        [self.contentView addSubview:verLineView];
        verLineView.frame = CGRectMake(self.bounds.size.width-1, 0, 1, self.bounds.size.height);
    }
    return self;
}
@end
