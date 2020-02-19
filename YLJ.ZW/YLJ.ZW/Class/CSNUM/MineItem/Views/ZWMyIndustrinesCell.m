//
//  ZWMyIndustrinesCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/13.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyIndustrinesCell.h"
@interface ZWMyIndustrinesCell()
@property(nonatomic, strong)UILabel *defaultLabel;
@end
@implementation ZWMyIndustrinesCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        CGFloat labelW = [[ZWToolActon shareAction]adaptiveTextWidth:@"默认" labelFont:smallFont]+10;
        self.defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-labelW, 0, labelW, 0.13*height)];
        self.defaultLabel.text = @"默认";
        self.defaultLabel.font = smallFont;
        self.defaultLabel.textAlignment = NSTextAlignmentCenter;
        self.defaultLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.defaultLabel];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.defaultLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.defaultLabel.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.defaultLabel.layer.mask = maskLayer;
        
        UILabel *secondLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1*width, 0.15*height, 0.8*width, 0.3*height)];
        secondLB.text = @"二级行二级行级行";
        secondLB.numberOfLines = 2;
        secondLB.font = smallMediumFont;
        secondLB.textAlignment = NSTextAlignmentCenter;
        self.secondLB = secondLB;
        [self addSubview:secondLB];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0.45*width, CGRectGetMaxY(secondLB.frame), 0.1*width, 0.1*height)];
        imageV.image = [UIImage imageNamed:@"double_arrow_icon"];
        [self addSubview:imageV];
        
        UILabel *thirdLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1*width, CGRectGetMaxY(imageV.frame), 0.8*width, 0.3*height)];
        thirdLB.text = @"三级行业三级行业三级行业三级行业";
        thirdLB.font = smallFont;
        thirdLB.numberOfLines = 2;
        thirdLB.textAlignment = NSTextAlignmentCenter;
        self.thirdLB = thirdLB;
        [self addSubview:thirdLB];
        
    }
    return self;
}


//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if(selected) {
//        self.layer.borderColor = skinColor.CGColor;
//        self.layer.borderWidth = 2;
//        self.defaultLabel.backgroundColor = skinColor;
//    }else{
//        self.layer.borderColor = zwGrayColor.CGColor;
//        self.layer.borderWidth = 0;
//        self.defaultLabel.backgroundColor = [UIColor whiteColor];
//    }
//}
@end
