//
//  ZWOrderAlreadyPayCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWOrderAlreadyPayCell.h"
@interface ZWOrderAlreadyPayCell()
@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UIImageView *titleImage;//标题图片
@property(nonatomic, strong)UILabel *dateLabel;//时间
@property(nonatomic, strong)UILabel *nameLabel;//单价
@property(nonatomic, strong)UILabel *numberLabel;//商品数量
@property(nonatomic, strong)UILabel *totalPrice;//商品总价
@end
@implementation ZWOrderAlreadyPayCell

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
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2018-11-29 10: 11: 31";
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.dateLabel = dateLabel;
        [self addSubview:self.dateLabel];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"展会会刊x1";
        nameLabel.font = normalFont;
        nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.nameLabel = nameLabel;
        [self addSubview:self.nameLabel];
        
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = @"共一件商品 小计：";
        numberLabel.font = smallMediumFont;
        numberLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.numberLabel = numberLabel;
        [self addSubview:self.numberLabel];
        
        
        UILabel *totalPrice = [[UILabel alloc]init];
        totalPrice.text = @"￥50.00";
        totalPrice.font = normalFont;
        totalPrice.textColor = [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
        self.totalPrice = totalPrice;
        [self addSubview:self.totalPrice];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.titleLabel.frame = CGRectMake(15, 5, size.width-90, 30);
    
    self.titleImage.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame), size.height-25, size.height-45);
    
    self.dateLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), size.width/2, 20);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMinX(self.dateLabel.frame), CGRectGetMidY(self.titleImage.frame)-15, size.width/2, 30);
    
    
    CGFloat textW = [[ZWToolActon shareAction]adaptiveTextWidth:@"联系客服" labelFont:normalFont];
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, textW, 20);
    [contactBtn setTitleColor:[UIColor colorWithRed:65/255.0 green:159/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    contactBtn.titleLabel.font = normalFont;
    [contactBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [self addSubview:contactBtn];
    
    
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(contactBtn.frame)+10, CGRectGetMaxY(self.titleImage.frame)-20, 0.28*size.width, 20);
    
    self.totalPrice.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, 0.6*size.width, 20);
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(size.width-40, 10, 20, 20);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"ren_wding_icon_shan"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    
}

@end
