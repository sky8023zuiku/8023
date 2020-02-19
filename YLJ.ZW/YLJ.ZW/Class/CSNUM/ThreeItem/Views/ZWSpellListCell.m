//
//  ZWSpellListCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/24.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWSpellListCell.h"

@interface ZWSpellListCell()

@property(nonatomic, strong)UILabel *titleLabel;//公司名称
@property(nonatomic, strong)UILabel *dateLabel;//拼单日期
@property(nonatomic, strong)UILabel *detailLabel;//拼单详情
@property(nonatomic, strong)UILabel *addressLabel;//地址
@property(nonatomic, strong)UILabel *prepareLabel;//布展日期
@property(nonatomic, strong)UILabel *startLabel;//开展日期
@property(nonatomic, strong)UILabel *nameLabel;//姓名
@property(nonatomic, strong)UILabel *phoneLabel;//手机号码
@property(nonatomic, strong)UILabel *randomLabel;//大小

@end


@implementation ZWSpellListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label01 = [[UILabel alloc]init];
        label01.text = @"上海一里井会展服务有限公司";
        label01.font = normalFont;
        label01.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = label01;
        [self addSubview:label01];
        
        UILabel *label02 = [[UILabel alloc]init];
        label02.text = @"2019.07.29";
        label02.font = normalFont;
        label02.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        label02.textAlignment = NSTextAlignmentRight;
        self.dateLabel = label02;
        [self addSubview:label02];
        
        UILabel *label03 = [[UILabel alloc]init];
        label03.text = @"上海国际贸易进口博览会";
        label03.font = normalFont;
        label03.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.detailLabel = label03;
        [self addSubview:label03];
        
        UILabel *label04 = [[UILabel alloc]init];
        label04.text = @"国家会展中心（上海）-3号馆";
        label04.font = normalFont;
        label04.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.addressLabel = label04;
        [self addSubview:label04];
        
        UILabel *label05 = [[UILabel alloc]init];
        label05.text = @"布展：2019.10.23";
        label05.font = normalFont;
        label05.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.prepareLabel = label05;
        [self addSubview:label05];
        
        UILabel *label06 = [[UILabel alloc]init];
        label06.text = @"布展：2019.10.23    开展：2019.10.26";
        label06.font = normalFont;
        label06.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.startLabel = label06;
        [self addSubview:label06];
        
        UILabel *label07 = [[UILabel alloc]init];
        label07.text = @"傲寒";
        label07.font = normalFont;
        label07.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.nameLabel = label07;
        [self addSubview:label07];
        
        UILabel *label08 = [[UILabel alloc]init];
        label08.text = @"18862353837";
        label08.font = normalFont;
        label08.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.phoneLabel = label08;
        [self addSubview:label08];
        
        UILabel *randomLabel = [[UILabel alloc]init];
        randomLabel.font = normalFont;
        randomLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.randomLabel = randomLabel;
        [self addSubview:randomLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat rowHeight = (size.height-20)/6;
    self.titleLabel.frame = CGRectMake(10, 10, size.width/3*2, rowHeight);
    self.dateLabel.frame = CGRectMake(size.width/2+10, 10, size.width/2-20, rowHeight);
    
    UIImageView *detailIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+7, size.height/10, size.height/10)];
    detailIcon.image = [UIImage imageNamed:@"fu_zhantaipin_icon_ming"];
    [self addSubview:detailIcon];
    self.detailLabel.frame = CGRectMake(CGRectGetMaxX(detailIcon.frame)+5, CGRectGetMaxY(self.titleLabel.frame), size.width-rowHeight, rowHeight);
    
    UIImageView *adressIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.detailLabel.frame)+7, size.height/10, size.height/10)];
    adressIcon.image = [UIImage imageNamed:@"fu_zhantaipin_icon_guan"];
    [self addSubview:adressIcon];
    
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(adressIcon.frame)+5, CGRectGetMaxY(self.detailLabel.frame), size.width-rowHeight, rowHeight);
    
    
    UIImageView *deteIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.addressLabel.frame)+7, size.height/10, size.height/10)];
    deteIcon.image = [UIImage imageNamed:@"fu_zhantaipin_icon_shi"];
    [self addSubview:deteIcon];
    
    self.startLabel.frame = CGRectMake(CGRectGetMaxX(deteIcon.frame)+5, CGRectGetMaxY(self.addressLabel.frame), size.width-rowHeight, rowHeight);
    
    
    UIImageView *nameIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.startLabel.frame)+7, size.height/10, size.height/10)];
    nameIcon.image = [UIImage imageNamed:@"fu_zhantaipin_icon_xing"];
    [self addSubview:nameIcon];
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(nameIcon.frame)+5, CGRectGetMaxY(self.startLabel.frame), size.width/2-rowHeight, rowHeight);
    
    
    UIImageView *phoneIcon =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMaxY(self.startLabel.frame)+7, size.height/10, size.height/10)];
    phoneIcon.image = [UIImage imageNamed:@"fu_zhantaipin_icon_dianhua"];
    [self addSubview:phoneIcon];
    
    self.phoneLabel.frame = CGRectMake(CGRectGetMaxX(phoneIcon.frame)+5, CGRectGetMaxY(self.startLabel.frame), size.width/2-rowHeight, rowHeight);
    
    self.randomLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.nameLabel.frame), size.width-30, rowHeight);
    
}

-(void)setModel:(ZWServiceSpellListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.merchantName];
    self.dateLabel.text = [self timeTransformation:[NSString stringWithFormat:@"%@",model.created]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",model.exhibitionName];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",model.exhibitionHall];
    self.startLabel.text = [NSString stringWithFormat:@"布展：%@   开展：%@",[self timeTransformation:[NSString stringWithFormat:@"%@",model.created]],[self timeTransformation:[NSString stringWithFormat:@"%@",model.created]]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.contacts];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",model.telephone];
//    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.size];
    if ([model.type isEqualToString:@"1"]) {
        self.randomLabel.text = [NSString stringWithFormat:@"展台面积：%@m²",model.size];
    }else if ([model.type isEqualToString:@"2"]) {
        self.randomLabel.text = @"";
    }else if ([model.type isEqualToString:@"3"]) {
        self.randomLabel.text = [NSString stringWithFormat:@"展台面积：%@m²",model.size];
    }else {
        self.randomLabel.text = [NSString stringWithFormat:@"出发地：%@",model.origin];
    }
}

-(NSString *)timeTransformation:(NSString *)time {
    
    NSString *string = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    return [NSString stringWithFormat:@"%@",dateString];
}

@end
