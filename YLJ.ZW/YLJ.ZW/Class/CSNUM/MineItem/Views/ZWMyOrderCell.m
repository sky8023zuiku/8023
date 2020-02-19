//
//  ZWOrderNotPayCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyOrderCell.h"
@interface ZWMyOrderCell()
@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UIImageView *titleImage;//标题图片
@property(nonatomic, strong)UILabel *stateLabel;//支付状态
@property(nonatomic, strong)UILabel *dateLabel;//时间
@property(nonatomic, strong)UILabel *unitPrice;//单价
@property(nonatomic, strong)UILabel *numberLabel;//商品数量
@property(nonatomic, strong)UILabel *totalPrice;//商品总价
@property(nonatomic, strong)UILabel *orderNumber;//订单编号
@property(nonatomic, strong)UILabel *typeLabel;//订单类型
@end

@implementation ZWMyOrderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"2018新国际亚洲混凝土世界会刊";
        titleLabel.font = normalFont;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        UIImageView *titleImage = [[UIImageView alloc]init];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
    
        UILabel *stateLabel = [[UILabel alloc]init];
        stateLabel.text = @"未支付";
        stateLabel.font = smallMediumFont;
        stateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.stateLabel = stateLabel;
        [self addSubview:self.stateLabel];
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2018-11-29 10: 11: 31";
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.dateLabel = dateLabel;
        [self addSubview:self.dateLabel];
        
        UILabel *orderNumber = [[UILabel alloc]init];
        orderNumber.text = @"订单编号：88888888888888888";
        orderNumber.font = smallMediumFont;
        orderNumber.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.orderNumber = orderNumber;
        [self addSubview:self.orderNumber];
        
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.text = @"展会会刊x1";
        typeLabel.font = normalFont;
        typeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.typeLabel = typeLabel;
        [self addSubview:self.typeLabel];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = @"小计：";
        numberLabel.font = smallMediumFont;
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.numberLabel = numberLabel;
        [self addSubview:self.numberLabel];
        
        
        UILabel *totalPrice = [[UILabel alloc]init];
        totalPrice.text = @"￥50.00";
        totalPrice.font = bigFont;
        totalPrice.textColor = [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
        self.totalPrice = totalPrice;
        [self addSubview:self.totalPrice];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.titleLabel.frame = CGRectMake(15, 5, size.width-70, 30);
    
    self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 5, 60, 30);
    
    self.titleImage.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame), size.height-25, size.height-45);
    
    self.dateLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), size.width/2, 0.25*CGRectGetHeight(self.titleImage.frame));
    
    self.orderNumber.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.dateLabel.frame), size.width-CGRectGetWidth(self.titleImage.frame)-30, 0.25*CGRectGetHeight(self.titleImage.frame));
    
    self.typeLabel.frame = CGRectMake(CGRectGetMinX(self.dateLabel.frame), CGRectGetMaxY(self.orderNumber.frame), size.width/2, 0.25*CGRectGetHeight(self.titleImage.frame));
    
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    contactBtn.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame), CGRectGetMaxY(self.typeLabel.frame), 0.25*kScreenWidth, 0.25*CGRectGetHeight(self.titleImage.frame));
    contactBtn.titleLabel.font = smallMediumFont;
    [contactBtn setTitle:@"开票联系客服" forState:UIControlStateNormal];
    [self addSubview:contactBtn];
    
    
    self.numberLabel.frame = CGRectMake(size.width-200, CGRectGetMaxY(self.titleImage.frame)-20, 80, 0.25*CGRectGetHeight(self.titleImage.frame));

    self.totalPrice.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, 120, 0.25*CGRectGetHeight(self.titleImage.frame));

}

- (void)setModel:(ZWOrderListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (model.paymentStatus == 1) {
        self.stateLabel.text = @"未支付";
    }else {
        self.stateLabel.text = @"已支付";
    }
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.cover_images]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",model.created];
    self.orderNumber.text = [NSString stringWithFormat:@"订单编号：%@",model.order_num];
    if ([model.type isEqualToString:@"1"]) {
        self.typeLabel.text = [NSString stringWithFormat:@"展会会刊 X%@",model.count];
    }
    self.numberLabel.text = @"小记：";
    
    int count = [model.count intValue];
    
    NSInteger price = [model.price integerValue]*10*count;
    
    self.totalPrice.text = [NSString stringWithFormat:@"%ld会展币",(long)price];
    
    self.numberLabel.frame = CGRectMake(self.frame.size.width-160, CGRectGetMaxY(self.titleImage.frame)-20, 80, 0.25*CGRectGetHeight(self.titleImage.frame));
    
    CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:self.totalPrice.text labelFont:bigFont]+10;
    
    self.totalPrice.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, width, 0.25*CGRectGetHeight(self.titleImage.frame));
}
@end
