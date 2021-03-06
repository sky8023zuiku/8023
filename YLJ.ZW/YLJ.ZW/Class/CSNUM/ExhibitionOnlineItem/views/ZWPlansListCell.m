//
//  ZWPlansListView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWPlansListCell.h"
@interface ZWPlansListCell()

@property(nonatomic, strong)UIImageView *titleImage;//标题图
@property(nonatomic, strong)UILabel *areaLabel;//区域
@property(nonatomic, strong)UILabel *dateLabel;//日期
@property(nonatomic, strong)UILabel *detailLabel;//详细

@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *hostLabel;//主办方
@property(nonatomic, strong)UIImageView *labelImage;//标签

@end

@implementation ZWPlansListCell
 
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = boldNormalFont;
        titleLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:43.0/255.0  blue:43.0/255.0  alpha:1];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"h1.jpg"];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleImage = imageView;
        [self addSubview:imageView];
        
        UIImageView *labelImage = [[UIImageView alloc]init];
        self.labelImage = labelImage;
        [imageView addSubview:labelImage];
        
        
        UILabel *areaLabel = [[UILabel alloc]init];
        areaLabel.text = @"中国 上海";
        areaLabel.font = smallMediumFont;
        areaLabel.numberOfLines = 2;
        areaLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.areaLabel = areaLabel;
        [self addSubview:self.areaLabel];
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2018/12/21-2018/12/22";
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.dateLabel = dateLabel;
        [self addSubview:self.dateLabel];
        
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.text = @"2018年上海国际汽车配件、维修检测诊断设备及服务用品展览会刊";
        detailLabel.font = smallMediumFont;
        detailLabel.numberOfLines = 2;
        detailLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.detailLabel = detailLabel;
        [self addSubview:self.detailLabel];
        
        UILabel *hostLabel = [[UILabel alloc]init];
        hostLabel.text = @"主办方：上海展览股份有限公司";
        hostLabel.font = smallMediumFont;
        hostLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.hostLabel = hostLabel;
        [self addSubview:hostLabel];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
//    CGFloat titleH = 0.25*size.height;
    
    CGFloat contentH = 0.7*size.height;
    
//    self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-20, titleH);
    
    self.titleImage.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), contentH, contentH);
    
    self.labelImage.frame = CGRectMake(CGRectGetWidth(self.titleImage.frame)-30, 0, 30, 30);
    
    self.dateLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMaxY(self.titleLabel.frame), (size.width-CGRectGetWidth(self.titleImage.frame)-30), 0.25*contentH);
    
    self.areaLabel.frame = CGRectMake(CGRectGetMinX(self.dateLabel.frame), CGRectGetMaxY(self.dateLabel.frame), CGRectGetWidth(self.dateLabel.frame), CGRectGetHeight(self.dateLabel.frame));
    
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.areaLabel.frame), CGRectGetMaxY(self.areaLabel.frame), CGRectGetWidth(self.dateLabel.frame), CGRectGetHeight(self.areaLabel.frame));
    
    self.hostLabel.frame = CGRectMake(CGRectGetMinX(self.detailLabel.frame), CGRectGetMaxY(self.detailLabel.frame), CGRectGetWidth(self.detailLabel.frame), CGRectGetHeight(self.detailLabel.frame));
}

-(void)setModel:(ZWExhPlanListModel *)model {
    
    NSString *mText;
    
    if ([model.developingState isEqualToString:@"0"]) {
        mText = @"";
        self.labelImage.image = [UIImage imageNamed:@""];
    }else if ([model.developingState isEqualToString:@"1"]) {
        mText = @"【延期】";
        self.labelImage.image = [UIImage imageNamed:@"delay_icon"];
    }else {
        mText = @"【取消】";
        self.labelImage.image = [UIImage imageNamed:@"cancel_icon"];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",mText,model.name]];
    NSRange range = [[str string] rangeOfString:mText];
    UIColor *textColor;
    if ([mText isEqualToString:@"【取消】"]) {
        textColor = skinColor;
    }else {
        textColor = [UIColor redColor];
    }
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    self.titleLabel.attributedText = str;
    
    if (![model.developingState isEqualToString:@"0"]) {
        
        self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-80, 0.25*self.frame.size.height);
                
        UIButton *annBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [annBtn setTitle:@"查看公告" forState:UIControlStateNormal];
        [annBtn setTitleColor:skinColor forState:UIControlStateNormal];
        annBtn.titleLabel.font = smallMediumFont;
        annBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 60, 0.25*self.frame.size.height);
        annBtn.tag = self.tag;
        [annBtn addTarget:self action:@selector(annBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:annBtn];

    }else {
        self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-20, 0.25*self.frame.size.height);
    }
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    self.areaLabel.text = [NSString stringWithFormat:@"地    点：%@  %@",model.country,model.city];
    NSString *start = [model.startTime substringWithRange:NSMakeRange(0, 10)];
    NSString *end = [model.endTime substringWithRange:NSMakeRange(0, 10)];
    NSString *startTime = [start stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    NSString *endTime = [end stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"时    间：%@~%@",startTime,endTime];
    self.hostLabel.text = [NSString stringWithFormat:@"主办方：%@",model.sponsor];
    self.detailLabel.text =[NSString stringWithFormat:@"展    馆：%@",model.exhibitionHallName];
}

- (void)annBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(respondToEventsWithIndex:)]) {
        [self.delegate respondToEventsWithIndex:btn.tag];
    }
}

@end
