//
//  ZWExhibitionCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/6.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionListsCell.h"
#import <UIImageView+WebCache.h>
#import "ZWMineRqust.h"
#import "ZWAnnouncementVC.h"
#import <YYText.h>
#import <YYLabel.h>
@interface ZWExhibitionListsCell()
@property(nonatomic, strong)UIImageView *titleImage;//标题图
@property(nonatomic, strong)YYLabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *dateLabel;//日期
@property(nonatomic, strong)UILabel *locationLabel;//位置
@property(nonatomic, strong)UILabel *priceLabel;//价格
@property(nonatomic, strong)UILabel *numberLabel;//人数
@property(nonatomic, strong)UIImageView *labelImage;//标签图标
@end
@implementation ZWExhibitionListsCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"h1.jpg"];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        self.titleImage = imageView;
        [self addSubview:imageView];
        
        UIImageView *labelImage = [[UIImageView alloc]init];
        self.labelImage = labelImage;
        [imageView addSubview:labelImage];
        
        YYLabel *titleLabel = [[YYLabel alloc]init];
        titleLabel.text = @"2018年上海国际汽车配件、维修检测诊断设备展览会";
        titleLabel.font = normalFont;
        titleLabel.numberOfLines = 2;
        titleLabel.layer.borderWidth = 2;
        titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
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
        priceLabel.font = normalFont;
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
    
    self.labelImage.frame = CGRectMake(CGRectGetWidth(self.titleImage.frame)-30, 0, 30, 30);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), kScreenWidth-size.height-10, 0.38*size.height);
    
    self.dateLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), (size.width-CGRectGetWidth(self.titleImage.frame)-50)/3*1.8, 25);
    self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.dateLabel.frame), 25);
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleImage.frame)-20, 0.25*kScreenWidth, 20);

    UIImageView *numberImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+10, CGRectGetMinY(self.priceLabel.frame), 20, 20)];
    numberImage.image = [UIImage imageNamed:@"numbers_icon"];
    [self addSubview:numberImage];

    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(numberImage.frame)+5, CGRectGetMinY(numberImage.frame), 0.2*kScreenWidth, 20);
    
    self.collectionBtn.frame = CGRectMake(kScreenWidth-40, CGRectGetMaxY(self.titleImage.frame)-20, 20, 20);

}

- (void)setModel:(ZWExhibitionListModel *)model {
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    
    NSString *mtext;
    if ([model.developingState isEqualToString:@"1"]) {
        mtext = @"【延期】";
        self.labelImage.image = [UIImage imageNamed:@"delay_icon"];
    }else if ([model.developingState isEqualToString:@"2"]) {
        mtext = @"【取消】";
        self.labelImage.image = [UIImage imageNamed:@"cancel_icon"];
    }else {
        self.labelImage.image = [UIImage imageNamed:@""];
    }
    
    if (![model.developingState isEqualToString:@"0"]) {
        NSMutableAttributedString *labelStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"查看公告%@%@",mtext,model.name]];
        labelStr.yy_font = normalFont;
        labelStr.yy_lineSpacing = 5;
        NSRange rangeOne = [[labelStr string]rangeOfString:@"查看公告"];
        [labelStr yy_setTextHighlightRange:rangeOne color:skinColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            ZWAnnouncementVC *VC = [[ZWAnnouncementVC alloc]init];
            VC.hidesBottomBarWhenPushed = YES;
            VC.imageUrl = model.announcementImages;
            VC.title = @"公告";
            [self.ff_navViewController pushViewController:VC animated:YES];
        }];
        NSRange rangeTwo = [[labelStr string]rangeOfString:mtext];
        UIColor *textColor;
        if ([mtext isEqualToString:@"【取消】"]) {
            textColor = skinColor;
        }else {
            textColor = [UIColor redColor];
        }
        [labelStr yy_setTextHighlightRange:rangeTwo color:textColor backgroundColor:[UIColor whiteColor] userInfo:nil];
        self.titleLabel.attributedText = labelStr;
    }else {
        NSMutableAttributedString *labelStr = [[NSMutableAttributedString alloc]initWithString:model.name];
        labelStr.yy_font = normalFont;
        labelStr.yy_lineSpacing = 5;
        self.titleLabel.attributedText = labelStr;
    }
    

    NSString *startTime = [model.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *endTime = [model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    self.locationLabel.text = [NSString stringWithFormat:@"%@  %@",model.country,model.city];
    
//    NSNumber *price =(NSNumber *)model.price;
    
    if ([model.price isEqualToString:@"0"]) {
        self.priceLabel.text = @"限时免费";
    }else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@0会展币",model.price];
    }
    
//    if ([price isEqualToNumber:@0]) {
//
//    }else {
//
//    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.merchantCount];
    
    NSLog(@"---%@",model.collection);
    
    if ([model.collection isEqualToString:@"1"]) {
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


