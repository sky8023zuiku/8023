//
//  ZWDrawerHeardView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDrawerHeardView.h"

@implementation ZWDrawerHeardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.2*frame.size.height)];
        lineView.backgroundColor = zwGrayColor;
        self.lineView = lineView;
        [self addSubview:self.lineView];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.02*kScreenWidth, CGRectGetMaxY(lineView.frame), frame.size.width/2, 0.8*frame.size.height)];
        titleLabel.font = smallMediumFont;
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];

        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2, CGRectGetMaxY(lineView.frame), frame.size.width/2-0.1*frame.size.width, 0.8*frame.size.height)];
        detailLabel.font = smallFont;
        detailLabel.textAlignment = NSTextAlignmentRight;
        self.detailLabel = detailLabel;
        [self addSubview:self.detailLabel];

        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(detailLabel.frame), 0.475*frame.size.height, 0.25*frame.size.height, 0.25*frame.size.height)];
        arrowImageView.image = [UIImage imageNamed:@"arrow_left_icon"];
        self.arrowImageView = arrowImageView;
        [self addSubview:arrowImageView];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
