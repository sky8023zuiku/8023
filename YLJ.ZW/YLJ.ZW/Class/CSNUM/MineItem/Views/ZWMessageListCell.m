//
//  ZWMessageListCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/26.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMessageListCell.h"
#import "ZWToolActon.h"

@interface ZWMessageListCell()

@property(nonatomic, strong)UIImageView *heardImage;//消息头像
@property(nonatomic, strong)UILabel *titelLabel;//用户姓名
@property(nonatomic, strong)UILabel *dateLabel;//接收消息的信息
@property(nonatomic, strong)UILabel *nameLabel;//用户名称
@property(nonatomic, strong)UILabel *phoneLabel;//用户电话号码
@property(nonatomic, strong)UILabel *emailLabel;//邮箱
@property(nonatomic, strong)UILabel *wechatLabel;//微信
@property(nonatomic, strong)UILabel *addressLabel;//地址
@property(nonatomic, strong)UITextView *detailsView;//详情

@end

@implementation ZWMessageListCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        UIImageView *heardImage = [[UIImageView alloc]init];
        heardImage.image = [UIImage imageNamed:@"h1.jpg"];
        heardImage.layer.cornerRadius = 0.07*frame.size.width;
        heardImage.layer.masksToBounds = YES;
        self.heardImage = heardImage;
        [self addSubview:heardImage];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"游戏人生";
        titleLabel.font = normalFont;
        self.titelLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2019/05/06";
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.dateLabel = dateLabel;
        [self addSubview:dateLabel];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"姓名：李小姐";
        nameLabel.font = smallMediumFont;
        nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        phoneLabel.text = @"电话：18888888888";
        phoneLabel.font = smallMediumFont;
        phoneLabel.textAlignment = NSTextAlignmentRight;
        phoneLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        
        UILabel *emailLabel = [[UILabel alloc]init];
        emailLabel.text = @"邮箱：1888888@163.com";
        emailLabel.font = smallMediumFont;
        emailLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.emailLabel = emailLabel;
        [self addSubview:emailLabel];
        
        UILabel *wechatLabel = [[UILabel alloc]init];
        wechatLabel.text = @"微信：1888888";
        wechatLabel.font = smallMediumFont;
        wechatLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.wechatLabel = wechatLabel;
        [self addSubview:wechatLabel];
        
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.text = @"地址：上海市某个区某个路某个号";
        addressLabel.font = smallMediumFont;
        addressLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.addressLabel = addressLabel;
        [self addSubview:addressLabel];
        
        UITextView *detailsView = [[UITextView alloc]init];
        detailsView.text = @"详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情详情";
        detailsView.editable = NO;
        detailsView.font = smallMediumFont;
        detailsView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.detailsView = detailsView;
        [self addSubview:detailsView];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    self.heardImage.frame = CGRectMake(15, 15, 0.14*size.width, 0.14*size.width);
    self.titelLabel.frame = CGRectMake(CGRectGetMaxX(self.heardImage.frame)+10, CGRectGetMinY(self.heardImage.frame), 0.5*size.width, CGRectGetHeight(self.heardImage.frame));
    
    CGPoint point = CGPointMake(size.width-25, CGRectGetMidY(self.heardImage.frame));
    CAShapeLayer *layer = [self createIndicatorWithPosition:point color:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    [self.layer addSublayer:layer];

    self.dateLabel.frame = CGRectMake(size.width-35-0.2*kScreenWidth, CGRectGetMinY(self.heardImage.frame), 0.2*kScreenWidth, CGRectGetHeight(self.heardImage.frame));
    
    self.nameLabel.frame = CGRectMake(CGRectGetMinX(self.heardImage.frame), CGRectGetMaxY(self.heardImage.frame)+15, 0.5*size.width-10, 20);
    self.phoneLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMinY(self.nameLabel.frame), CGRectGetWidth(self.nameLabel.frame)-15, CGRectGetHeight(self.nameLabel.frame));
    self.emailLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame)+10, size.width-30, 20);

    self.wechatLabel.frame = CGRectMake(CGRectGetMinX(self.emailLabel.frame), CGRectGetMaxY(self.emailLabel.frame)+10, CGRectGetWidth(self.phoneLabel.frame), CGRectGetHeight(self.emailLabel.frame));
    
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.emailLabel.frame), CGRectGetMaxY(self.wechatLabel.frame)+10, size.width-30, CGRectGetHeight(self.emailLabel.frame));
    
    self.detailsView.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame)-5, CGRectGetMaxY(self.addressLabel.frame)+10, CGRectGetWidth(self.addressLabel.frame), 0.2*size.width);
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(size.width-100, 0, 100, 100);
    closeBtn.tag = self.tag;
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
}

//指示器
- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)position color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(5, -5)];
    [path moveToPoint:CGPointMake(5, -5)];
    [path addLineToPoint:CGPointMake(10, 0)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = position;
    return layer;
}
-(void)setModel:(ZWMessageListModel *)model {
    self.titelLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.userName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",model.phone];
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",model.email];
    self.wechatLabel.text = [NSString stringWithFormat:@"微信：%@",model.wechart];
    self.addressLabel.text = [NSString stringWithFormat:@"位置：%@",model.address];
    self.detailsView.text = [NSString stringWithFormat:@"备注：%@",model.demand];
}

-(void)closeBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(tapClose:)]) {
        [self.delegate tapClose:btn.tag];
    }
}

@end
