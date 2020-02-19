//
//  ZWMyCatalogueCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/27.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyCatalogueCell.h"
#import <UIImageView+WebCache.h>
#import "ZWMineRqust.h"
@interface ZWMyCatalogueCell()
@property(nonatomic, strong)UIImageView *titleImage;//标题图
@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *dateLabel;//日期
@property(nonatomic, strong)UILabel *locationLabel;//位置
@property(nonatomic, strong)UILabel *priceLabel;//价格
@property(nonatomic, strong)UILabel *numberLabel;//人数
@end

@implementation ZWMyCatalogueCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"h1.jpg"];
        self.titleImage = imageView;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"2018年上海国际汽车配件、维修检测诊断设备展览会";
        titleLabel.font = normalFont;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2018/12/21-23";
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.dateLabel = dateLabel;
        [self addSubview:self.dateLabel];
        
        
        UILabel *locationLabel = [[UILabel alloc]init];
        locationLabel.text = @"中国  上海";
        locationLabel.font = normalFont;
        locationLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.locationLabel = locationLabel;
        [self addSubview:self.locationLabel];
        

        UILabel *priceLabel = [[UILabel alloc]init];
        priceLabel.text = @"￥50:00";
        priceLabel.font = bigFont;
        priceLabel.textColor = [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
        self.priceLabel = priceLabel;
        [self addSubview:self.priceLabel];
        
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = @"2395";
        numberLabel.font = [UIFont fontWithName:@"PingFang SC" size: 12];
        numberLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.numberLabel = numberLabel;
        [self addSubview:self.numberLabel];
        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        collectionBtn.tag = self.tag;
        self.collectionBtn = collectionBtn;
        [self addSubview:collectionBtn];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.titleImage.frame = CGRectMake(10, 10, size.height-20, size.height-20);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), kScreenWidth-size.height-10, 45);
    self.dateLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), (size.width-CGRectGetWidth(self.titleImage.frame)-50)/3*1.8, 25);
    self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.dateLabel.frame), 25);
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, 0.25*kScreenWidth, 20);
    
    UIImageView *numberImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+10, CGRectGetMinY(self.priceLabel.frame), 20, 20)];
    numberImage.image = [UIImage imageNamed:@"numbers_icon"];
    [self addSubview:numberImage];

    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(numberImage.frame)+5, CGRectGetMinY(numberImage.frame), 0.2*kScreenWidth, 20);
    
    self.collectionBtn.frame = CGRectMake(kScreenWidth-40, CGRectGetMaxY(self.titleImage.frame)-20, 20, 20);

}

- (void)setModel:(ZWMyCatalogueModel *)model {
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    NSString *startTime = [model.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *endTime = [model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    self.locationLabel.text = [NSString stringWithFormat:@"%@  %@",model.country,model.city];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.merchantCount];
    
    NSLog(@"---%@",model.collection);
    
    if ([model.collection isEqualToNumber: @1]) {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
    }else {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
    }
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
}

- (void)collectionBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(collectionItemWithIndex:withIndex:)]) {
        [self.delegate collectionItemWithIndex:self withIndex:btn.tag];
    }
}
@end
