//
//  ZWIndustriesItemView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/15.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWIndustriesItemView.h"
@interface ZWIndustriesItemView()
@property(nonatomic, strong)UILabel *topLabel;
@property(nonatomic, strong)UILabel *bottomLabel;
@end
@implementation ZWIndustriesItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0.005*frame.size.height, frame.size.width-10, 0.4*frame.size.height)];
        topLabel.text = @"二级行业";
        topLabel.font = boldSmallFont;
        topLabel.numberOfLines = 2;
        topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel = topLabel;
        [self addSubview:topLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-0.075*frame.size.height, CGRectGetMaxY(topLabel.frame)+0.015*frame.size.height, 0.15*frame.size.height, 0.15*frame.size.height)];
        imageView.image = [UIImage imageNamed:@"double_arrow_icon"];
        [self addSubview:imageView];
        
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame)+0.015*frame.size.height, frame.size.width-10, 0.4*frame.size.height)];
        bottomLabel.text = @"三级行业三";
        bottomLabel.font = smallFont;
        bottomLabel.numberOfLines = 2;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel = bottomLabel;
        [self addSubview:bottomLabel];
        
    }
    return self;
}

-(void)setModel:(ZWExbihitorsIndustriesModel *)model {
    self.topLabel.text = model.secondIndustryName;
    self.bottomLabel.text = model.thirdIndustryName;
}

@end
