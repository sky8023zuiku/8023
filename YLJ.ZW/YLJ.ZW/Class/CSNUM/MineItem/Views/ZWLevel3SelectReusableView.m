//
//  ZWLevel3SelectReusableView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWLevel3SelectReusableView.h"

@implementation ZWLevel3SelectReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*kScreenWidth, 0, frame.size.width/2, frame.size.height)];
        titleLabel.font = smallMediumFont;
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];

        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-0.25*frame.size.height-0.03*frame.size.width, 0.475*frame.size.height, 0.25*frame.size.height, 0.25*frame.size.height)];
        arrowImageView.image = [UIImage imageNamed:@"arrow_left_icon"];
        self.arrowImageView = arrowImageView;
        [self addSubview:arrowImageView];
        
    }
    return self;
}

@end
