//
//  ZWPlanDelayCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/2/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPlanDelayCell.h"
@interface ZWPlanDelayCell()

@property(nonatomic, strong)UIImageView *titleImage;//标题图
@property(nonatomic, strong)UILabel *areaLabel;//区域
@property(nonatomic, strong)UILabel *dateLabel;//日期
@property(nonatomic, strong)UILabel *detailLabel;//详细

@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *hostLabel;//主办方
@property(nonatomic, strong)UIImageView *labelImage;//标签

@property(nonatomic, strong)UILabel *myNewDate;//最新时间

@end
@implementation ZWPlanDelayCell

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
        
        UILabel *newDate = [[UILabel alloc]init];
        newDate.text = @"2018/12/21-2018/12/22";
        newDate.font = smallMediumFont;
        newDate.textColor = [UIColor redColor];
        self.myNewDate = newDate;
        [self addSubview:self.myNewDate];
        
        
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
    
    self.myNewDate.frame = CGRectMake(CGRectGetMinX(self.dateLabel.frame), CGRectGetMaxY(self.dateLabel.frame), CGRectGetWidth(self.dateLabel.frame), CGRectGetHeight(self.dateLabel.frame));
    
    self.areaLabel.frame = CGRectMake(CGRectGetMinX(self.myNewDate.frame), CGRectGetMaxY(self.myNewDate.frame), CGRectGetWidth(self.myNewDate.frame), CGRectGetHeight(self.myNewDate.frame));
    
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
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.titleLabel.attributedText = str;
    
//    if (![model.developingState isEqualToString:@"0"]) {
//
//    }else {
//        self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-20, 0.25*self.frame.size.height);
//    }
    
    if (model.announcementImages.length == 0) {
        self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-20, 0.25*self.frame.size.height);
    }else {
        self.titleLabel.frame = CGRectMake(10, 0, kScreenWidth-80, 0.25*self.frame.size.height);
        UIButton *annBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [annBtn setTitle:@"查看公告" forState:UIControlStateNormal];
        [annBtn setTitleColor:skinColor forState:UIControlStateNormal];
        annBtn.titleLabel.font = smallMediumFont;
        annBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 60, 0.25*self.frame.size.height);
        annBtn.tag = self.tag;
        [annBtn addTarget:self action:@selector(annBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:annBtn];
    }
    
    
    
    
    
//    self.titleLabel.text = model.name;
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.url]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    self.areaLabel.text = [NSString stringWithFormat:@"地    点：%@  %@",model.country,model.city];
    self.detailLabel.text = @"展    馆：上海市中国国际展馆";
    NSString *start = [model.startTime substringWithRange:NSMakeRange(0, 10)];
    NSString *end = [model.endTime substringWithRange:NSMakeRange(0, 10)];
    NSString *startTime = [start stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    NSString *endTime = [end stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"原    定：%@~%@",startTime,endTime];
    
    NSString *newStart = [model.myNewStartTime substringWithRange:NSMakeRange(0, 10)];
    NSString *newEnd = [model.myNewEndTime substringWithRange:NSMakeRange(0, 10)];
    NSString *newStartTime = [newStart stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    NSString *newEndTime = [newEnd stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
    
    if (model.myNewEndTime.length == 0) {
        self.myNewDate.text = @"最    新：待定";
    }else {
        self.myNewDate.text = [NSString stringWithFormat:@"最    新：%@~%@",newStartTime,newEndTime];
    }
}

- (void)annBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(respondToEventsWithDelayIndex:)]) {
        [self.delegate respondToEventsWithDelayIndex:btn.tag];
    }
}

@end
