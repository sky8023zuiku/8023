//
//  ZWExhServiceListCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhServiceListCell.h"
@interface ZWExhServiceListCell()
@property(nonatomic, strong)UIImageView *titleIamge;
@property(nonatomic, strong)UIImageView *memberImage;
@end
@implementation ZWExhServiceListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleIamge = [[UIImageView alloc]init];
        titleIamge.image = [UIImage imageNamed:@"h1.jpg"];
        self.titleIamge = titleIamge;
        [self addSubview:titleIamge];
        
        UIImageView *memberImage = [[UIImageView alloc]init];
        self.memberImage = memberImage;
        [titleIamge addSubview:memberImage];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上海展网网络科技有限公司";
        titleLabel.font = boldNormalFont;
        titleLabel.textColor = [UIColor blackColor];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.text = @"我们是展台搭建服务，报价咨询等";
        detailLabel.font = smallMediumFont;
        self.detailLabel = detailLabel;
        [self addSubview:detailLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.titleIamge.frame = CGRectMake(0.03*size.width, 0.1*size.height, size.height, 0.8*size.height);
    
    self.titleIamge.layer.borderColor = zwGrayColor.CGColor;
    self.titleIamge.layer.borderWidth = 1;
    
    self.memberImage.frame = CGRectMake(CGRectGetWidth(self.titleIamge.frame)/3*2, 0, CGRectGetWidth(self.titleIamge.frame)/3, 0.12*size.height);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleIamge.frame)+5, CGRectGetMinY(self.titleIamge.frame), size.width-CGRectGetWidth(self.titleIamge.frame)-35, 0.05*kScreenWidth);
    
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleIamge.frame)-0.06*kScreenWidth, CGRectGetWidth(self.titleLabel.frame), 0.06*kScreenWidth);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.03*size.width, size.height-1, 0.94*size.width, 1)];
    [self addSubview:lineView];
    [self drawDashLine:lineView lineLength:0.94*size.width lineSpacing:0.1 lineColor:zwGrayColor];
}




- (void)drawDashLine:(UIView *)lineView lineLength:(CGFloat)lineLength lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [lineView.layer addSublayer:shapeLayer];
    
}




-(void)setModel:(ZWServiceProvidersListModel *)model {
    
    NSArray  *labels = [model.business componentsSeparatedByString:@","];
    NSArray *bgColors = @[[UIColor colorWithRed:20/255.0 green:180/255.0 blue:230/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:159/255.0 blue:0/255.0 alpha:1.0],[UIColor colorWithRed:107/255.0 green:210/255.0 blue:251/255.0 alpha:1.0]];
    NSMutableArray * subLabels = [NSMutableArray array];
    if (labels.count > 3) {
        [subLabels addObjectsFromArray:[labels subarrayWithRange:NSMakeRange(0, 3)]];
    }else {
        [subLabels addObjectsFromArray:labels];
    }
    NSLog(@"我的数据：%@",subLabels);
    for (NSString *str in subLabels) {
        if ([str isEqualToString:@""]) {
            [subLabels removeObject:str];
        }
    }
    NSLog(@"我的数据2222：%@",subLabels);
    CGFloat leftWith = self.frame.size.height+0.03*self.frame.size.width;
    if (subLabels.count != 0) {
        for (int i = 0; i<subLabels.count ; i++) {
            CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:subLabels[i] labelFont:smallFont]+10;
            UILabel *ywLabel = [[UILabel alloc]init];
            ywLabel.frame = CGRectMake(leftWith+5, self.frame.size.height/2-10, width, 18);
            ywLabel.backgroundColor = bgColors[i];
            ywLabel.textColor = [UIColor whiteColor];
            ywLabel.text = subLabels[i];
            ywLabel.font = smallFont;
            ywLabel.textAlignment = NSTextAlignmentCenter;
            ywLabel.layer.masksToBounds = YES;
            [self addSubview:ywLabel];
            [self setTheRoundedCorners:ywLabel];
            leftWith += width+5;
        }
    }
    

    if ([model.vipVersion isEqualToString:@"1"]) {
        self.memberImage.image = [UIImage imageNamed:@"vip_fuwu"];
    }else if ([model.vipVersion isEqualToString:@"2"]) {
        self.memberImage.image = [UIImage imageNamed:@"svip_fuwu"];
    }else {
        self.memberImage.image = [UIImage imageNamed:@""];
    }
     
    [self.titleIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imagesUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    
    self.titleLabel.text = model.name;
    
    self.detailLabel.text = model.speciality;
    
    
}


- (void)setTheRoundedCorners:(UILabel *)label {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(6,6)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = label.bounds;
    maskLayer.path = maskPath.CGPath;
    label.layer.mask = maskLayer;
}

@end
